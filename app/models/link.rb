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
  validate :check_ids
  validates_uniqueness_of :med_one, scope: [:med_two]

  belongs_to :linker, class_name: 'Medium', foreign_key: 'med_one'
  belongs_to :linked, class_name: 'Medium', foreign_key: 'med_two'

  def check_ids
    errors.add(:med_one, "can't be the same as medium being linked") if med_one == med_two
  end
end
