# == Schema Information
#
# Table name: media
#
#  id             :integer          not null, primary key
#  upload         :string
#  transcript     :string
#  public_ref     :boolean
#  education_use  :boolean
#  public_archive :boolean
#  publication    :boolean
#  broadcasting   :boolean
#  editing        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#  contributor_id :integer
#
# Indexes
#
#  index_media_on_contributor_id  (contributor_id)
#

require 'tempfile'
require 'audiojs/rails'

class MediaController < ApplicationController

  def new
    @medium = Medium.new
    @medium.records.build
    @medium.build_contributor(params[:contributor_attributes])

    # By default a new contribution is a recording
    if params[:type].blank?
      @medium.type = 'Recording'
    else
      @medium.type = params[:type]
    end

    # Set the allowed upload extensions depending on the media type
    case @medium.type
      when'Recording'
          @accepted_mimes = '.wav,.mp3'
      when 'Document'
          @accepted_mimes = '.pdf'
      when 'Image'
          @accepted_mimes = '.jpeg,.jpg,.gif,.tff,.bmp,.png'
    end

  end

  def create
    # Could be *slightly* hacky, will need thorough testing!
    if params[:medium].present?
      @medium = Medium.new(medium_params("Medium"))
    elsif params[:type].present?
      @medium = Medium.new(medium_params(params[:type]))
    end

    # If the medium type is text, create a temp file to store the input, then upload as usual
    if @medium.type == 'Text'
      f = Tempfile.new(['text', '.txt'])

      f.write(@medium.text)
      @medium.upload = f
      f.close
      f.unlink
    end

    if verify_recaptcha(model: @medium) && @medium.save
      redirect_to root_url, notice: 'Upload successful, please wait for approval'
    else
      render :new
    end
  end

  def show
    @medium = Medium.where(id: params[:id]).first

    @approved_records = @medium.records.where(approved: true).order('created_at DESC')

    # TODO: change current record depending on selected
    if params.has_key?(:record_id)
      @current_record = @approved_records.find(params[:record_id])
    else
      @current_record = @approved_records.first
    end

  end

  def format_date(date)
    date.to_formatted_s(:long)
  end

  private
    def medium_params(type)
      # The media upload form submits a record as well as the contributor information
      params.require(type.underscore.to_sym).permit(:type, :upload, :upload_cache, :public_ref, :education_use,
                                                    :public_archive, :publication, :broadcasting, :editing, :copyright,
                                                    :text, records_attributes: [:title, :location, :description,
                                                                                :latitude, :longitude, :ref_date],
                                                    contributor_attributes: [:name, :email, :phone])
    end
end
