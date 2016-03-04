# == Schema Information
#
# Table name: media
#
#  id             :integer          not null, primary key
#  upload         :string
#  transcript     :string
#  public_ref     :boolean
#  education_use  :boolean
#  public_archive :boolean
#  publication    :boolean
#  broadcasting   :boolean
#  editing        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
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
