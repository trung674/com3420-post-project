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
    Faker::Config.locale = 'en-GB'
    name Faker::Name.name
    email Faker::Internet.email
    phone Faker::PhoneNumber.phone_number
  end
end
