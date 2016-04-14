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

FactoryGirl.define do
  factory :wallpaper do
    image "MyString"
    description "MyString"
  end
end
