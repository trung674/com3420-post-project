# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#  location    :string
#  time        :string
#

class Event < ActiveRecord::Base
  is_impressionable
  mount_uploader :image, EventImageUploader
end
