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

    # This dosen't seem to work
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
      else
        @accepted_mimes = ''
    end
  end

  def create
    # When creating, the form could submit with or without a type so handle both
    if params[:medium].present?
      @medium = Medium.new(medium_params('Medium'))
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
      # TODO: Error messages
      render :new
    end
  end

  # TODO: Some way for admins to see the unapproved records
  def show
    @medium = Medium.where(id: params[:id]).first

    @approved_records = @medium.records.where(approved: true).order('created_at DESC')

    # Change current record depending on selected
    if params.has_key?(:record_id)
      @current_record = @approved_records.find(params[:record_id])
    else
      @current_record = @approved_records.first
    end
  end

  def edit
    # When editing the most recent record for the medium is displayed
    @medium = Medium.where(id: params[:id]).first
    @current_record = @medium.records.where(approved: true).order('created_at').last
  end

  def update
    @medium = Medium.where(id: params[:id]).first

    if params[:medium].present?
      @record = Record.new(record_params(params['medium'])['record'])
    elsif params[:type].present?
      @record = Record.new(record_params(params[:type])['record'])
    end

    @record.medium = @medium

    if verify_recaptcha(model: @medium) && @record.save
      redirect_to root_url, notice: 'Edit successful, please wait for approval'
    else
      # TODO: Error messages
      @current_record = @record
      render :edit
    end
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

    def record_params(type)
      # Permit parameters for editing records
      params.require(type.underscore.to_sym).permit(record: [:title, :location, :description, :latitude, :longitude, :ref_date])
    end
end
