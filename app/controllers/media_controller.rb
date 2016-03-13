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
#

class MediaController < ApplicationController

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.new(medium_params)

    if verify_recaptcha(model: @medium) && @medium.save
      redirect_to root_url, notice: 'Upload successful, please wait for approval'
    else
      render :new
    end
  end

  private
    def medium_params
      params.require(:medium).permit(:upload, :upload_cache, :public_ref, :education_use, :public_archive,
                                     :publication, :broadcasting, :editing, :copyright,
                                     records_attributes: [:title, :location, :description, :ref_date])
    end
end
