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
#

class Event < ActiveRecord::Base
  mount_uploader :image, EventImageUploader
end
