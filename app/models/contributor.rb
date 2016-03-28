# == Schema Information
#
# Table name: contributors
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'auto_strip_attributes'

class Contributor < ActiveRecord::Base
  has_many :media

  auto_strip_attributes :name, :phone, :email, :squish => true

  validates :name, format: { with: /(\w|\s)*/ }
  validates :email, presence: true
  validates :phone, format: { with: /\d*/ }
end
