# == Schema Information
#
# Table name: media
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  location    :string
#  upload      :string
#  transcript  :string
#  orig_date   :date
#  approved    :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :medium do
    title "MyString"
    description "MyText"
    location "MyString"
    file_path "MyString"
    transcript_path "MyString"
    ref_date "2016-03-01"
    approved false
  end
end
