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

class Contributor < ActiveRecord::Base
  has_many :media
end
