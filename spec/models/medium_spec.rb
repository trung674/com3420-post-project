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

  it 'is valid with an upload' do
    medium = FactoryGirl.create(:medium, :with_record)
    expect(medium).to be_valid
  end

end
