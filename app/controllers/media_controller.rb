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

  private
    def post_params
      params.require(:post).permit(:title, :description, :location, :upload, :upload_cache, :orig_date)
    end
end
