# == Schema Information
#
# Table name: wallpapers
#
#  id          :integer          not null, primary key
#  image       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Wallpaper < ActiveRecord::Base
  mount_uploader :image, WallpaperUploader
end
