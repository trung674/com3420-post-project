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

FactoryGirl.define do
  factory :event do
    title "MyString"
    description "MyText"
    date "2016-04-03"
  end
end
