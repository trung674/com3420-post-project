# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  med_one    :integer
#  med_two    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Link < ActiveRecord::Base
  validates_presence_of :med_one
  validates_presence_of :med_two
end
