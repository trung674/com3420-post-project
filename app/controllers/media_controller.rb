# == Schema Information
#
# Table name: media
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  location    :string
#  upload      :string
#  transcript  :string
#  orig_date   :date
#  approved    :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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
