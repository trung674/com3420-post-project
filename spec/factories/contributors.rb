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

FactoryGirl.define do
  factory :contributor do
    name 'Joe'
    email 'joebloggs@gmail.com'
    phone '07777777777'
  end
end
