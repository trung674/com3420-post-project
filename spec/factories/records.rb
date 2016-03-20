FactoryGirl.define do
  factory :record do
    title 'Title'
    description 'A piece of history'
    location 'Braithwell Church'
    ref_date Date.today
    approved false
  end
end