require 'rails_helper'

describe 'Medium' do

  specify 'I can upload a document' do
    document = FactoryGirl.build(:document, :with_approved_record)
    record = document.records.first
    visit new_document_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(document.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Email', with: document.contributor.email
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'I can view an upload with an approved record' do
    document = FactoryGirl.create(:document, :with_approved_record)
    visit medium_path(id: document.id)
    expect(page).to have_content(document.records.first.title)
  end

end
