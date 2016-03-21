# == Schema Information
#
# Table name: editable_contents
#
#  id         :integer          not null, primary key
#  name       :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :editable_content do
    name "MyString"
    content "MyText"
  end
end
