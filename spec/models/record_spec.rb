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

require 'rails_helper'

RSpec.describe Record, type: :model do

  it 'is invalid without a title' do
    record = FactoryGirl.build(:record, :with_medium, title: nil)
    record.valid?
    expect(record.errors[:title]).to include("can't be blank")
  end

  it 'is invalid with an incorrect longitude type' do
    record = FactoryGirl.build(:record, :with_medium, longitude: 'not a number')
    record.valid?
    expect(record.errors[:longitude]).to include('is not a number')
  end

  it 'is invalid with an incorrect latitude type' do
    record = FactoryGirl.build(:record, :with_medium, latitude: 'not a number')
    record.valid?
    expect(record.errors[:latitude]).to include('is not a number')
  end

  it 'is valid with a medium' do
    record = FactoryGirl.create(:record, :with_medium)
    expect(record).to be_valid
  end

  it 'is invalid without a description' do
    record = FactoryGirl.build(:record, :with_medium, description: nil)
    record.valid?
    expect(record.errors[:description]).to include("can't be blank")
  end

  it 'is valid without a description for text upload' do
    text = FactoryGirl.create(:text, :with_record)
    record = FactoryGirl.create(:record, medium: text, description: nil)
    expect(record).to be_valid
  end

end
