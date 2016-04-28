# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  location    :string
#  ref_date    :date
#  approved    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  medium_id   :integer
#  latitude    :float
#  longitude   :float
#
# Indexes
#
#  index_records_on_medium_id  (medium_id)
#

FactoryGirl.define do
  factory :record do
    title Faker::Book.title
    description Faker::Lorem.paragraph
    location Faker::Address.city
    ref_date Date.today
    approved false
    latitude Faker::Address.latitude
    longitude Faker::Address.longitude

    trait :with_medium do
      after(:build) do |record|
        record.medium = FactoryGirl.build(:medium, records: [record])
      end
    end
  end
end
