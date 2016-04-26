require 'rails_helper'

describe 'Medium' do

  specify 'I can upload an image' do
  end

  specify 'I can view an upload with an approved record' do
    document = FactoryGirl.create(:document, :with_approved_record)
    visit medium_path(id: document.id)
    expect(page).to have_content(document.records.first.title)
  end

end
