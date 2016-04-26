# == Schema Information
#
# Table name: contributors
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Contributor, type: :model do
  it 'is invalid without an email' do
    contributor = FactoryGirl.build(:contributor, email: nil)
    contributor .valid?
    expect(contributor .errors[:email]).to include("can't be blank")
  end

  it 'is valid with all fields' do
    contributor = FactoryGirl.build(:contributor)
    expect(contributor).to be_valid
  end

  it 'is valid without a number' do
    contributor = FactoryGirl.build(:contributor, phone: nil)
    expect(contributor).to be_valid
  end

  it 'is valid without a name' do
    contributor = FactoryGirl.build(:contributor, name: nil)
    expect(contributor).to be_valid
  end
end
