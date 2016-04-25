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

require 'rails_helper'

RSpec.describe Medium, type: :model do

  it 'is invalid without an upload' do
    medium = FactoryGirl.build(:medium, :with_record, upload: nil)
    medium.valid?
    expect(medium.errors[:upload]).to include("can't be blank")
  end

  it 'is invalid without a record' do
    medium = FactoryGirl.build(:medium)
    medium.valid?
    expect(medium.errors[:records]).to include("can't be blank")
  end

  it 'is invalid without a contributor' do
    medium = FactoryGirl.build(:medium, :with_record, contributor: nil)
    medium.valid?
    expect(medium.errors[:contributor]).to include("can't be blank")
  end

  it 'Recording upload is valid' do
    # this is build since recordings run a delayed job when created
    recording = FactoryGirl.build(:recording, :with_record)
    expect(recording).to be_valid
  end

  it 'Document upload is valid' do
    document = FactoryGirl.create(:document, :with_record)
    expect(document).to be_valid
  end

  it 'Image upload is valid' do
    image = FactoryGirl.create(:image, :with_record)
    expect(image).to be_valid
  end

  it 'Image upload is invalid with incorrect file type' do
    image = FactoryGirl.build(:image, :with_record, upload: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, '/spec/fixtures/uploads/sample.wav'))))
    image.valid?
    expect(image.errors[:upload]).to include("You are not allowed to upload")
  end

end
