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
#  type           :string
#  contributor_id :integer
#
# Indexes
#
#  index_media_on_contributor_id  (contributor_id)
#

FactoryGirl.define do
  factory :medium do
    contributor
    upload Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/images/test.jpg')))

    trait :with_record do
      after(:build) do |medium|
        medium.records << FactoryGirl.create(:record, medium: medium)
      end
    end
  end
end
