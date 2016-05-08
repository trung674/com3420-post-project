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
    name "contact_address"
    content "23 Edward Street, Sheffield, UK, S3 7SF "
  end
end
