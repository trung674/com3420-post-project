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
#

class MediaController < ApplicationController

  def new
    @medium = Medium.new
  end

  def create
    @medium = Medium.new(medium_params)

    if @medium.save
      redirect_to media_url, notice: 'Upload successful'
    else
      render :new
    end
  end

  private
    def medium_params
      params.require(:medium).permit(:upload, :upload_cache, :public_ref, :education_use, :public_archive,
                                     :publication, :broadcasting, :editing, :copyright)
    end
end
