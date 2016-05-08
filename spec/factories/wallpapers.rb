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
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :wallpaper do
    image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'uploads', 'Wallpaper.jpg'), 'image/jpg') }
    description 'Test Wallpaper'
  end
end
