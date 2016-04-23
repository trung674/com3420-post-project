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
    @medium.build_contributor

    # By default a new contribution is a recording
    if params[:type].blank?
      @medium.type = 'Recording'
    else
      @medium.type = params[:type]
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
      render :new
    end
  end

  def show
    @medium = Medium.where(id: params[:id]).first

    # Change current record depending on selected
    if params.has_key?(:record_id)
      if mod_signed_in?
        # Mods have access to all records
        @current_record = @medium.all_records.find(params[:record_id])
      else
        @current_record = @medium.approved_records.find(params[:record_id])
      end
    else
      @current_record = @medium.latest_approved_record

      # This handles when there are no approved records
      if mod_signed_in? && @current_record.nil?
        @current_record = @medium.latest_record
      end
    end

    raise ActiveRecord::RecordNotFound if @current_record.nil?
  end

  def show_upload
    @medium = Medium.where(id: params[:id]).first

    if @medium.class.name == 'Text'
      # Text files are displayed as plain text so we only need to read the file
      @medium.upload.file.read
    else
      send_file(@medium.upload.path, disposition: 'inline')
    end
  end
  # Helper method so plain text can be shown for the text files
  helper_method :show_upload

  def show_transcript
    @medium = Medium.where(id: params[:id]).first
    send_file(@medium.transcript.path, disposition: 'inline')
  end

  def edit
    # When editing the most recent record for the medium is displayed
    @medium = Medium.where(id: params[:id]).first
    @current_record = @medium.latest_approved_record
  end

  def update
    @medium = Medium.where(id: params[:id]).first

    # Create a new (unapproved) record for the medium
    if params[:medium].present?
      @record = Record.new(record_params(params['medium'])['record'])
    elsif params[:type].present?
      @record = Record.new(record_params(params[:type])['record'])
    end

    @record.medium = @medium

    if verify_recaptcha(model: @medium) && @record.save
      redirect_to medium_url, notice: 'Edit successful, please wait for approval'
    else
      @current_record = @record
      render :edit
    end
  end

  def approve
    if mod_signed_in?
      record = Record.where(:id => params[:record_id]).first

      if params[:approve] && record
        record.approved = true

        if record.save
          redirect_to medium_url, record_id: record.id
          return
        end
      end

      if params[:remove]
        record.destroy
      end
    end

    redirect_to medium_url
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
