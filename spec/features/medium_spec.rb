require 'rails_helper'

describe 'Medium' do

  specify 'A user can upload a document' do
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

  specify 'A user can upload an image' do
    image = FactoryGirl.build(:image, :with_record)
    record = image.records.first
    visit new_image_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(image.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Email', with: image.contributor.email
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  # Since we are just testing the upload, queue the delayed job instead of running it
  specify 'A user can upload a recording', delayed_job: true do
    recording = FactoryGirl.build(:recording, :with_record)
    record = recording.records.first
    visit new_recording_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(recording.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Email', with: recording.contributor.email
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'A user can upload text' do
    text = FactoryGirl.build(:text, :with_record)
    record = text.records.first
    visit new_text_path
    fill_in 'Title', with: record.title
    fill_in 'Text', with: File.read(File.absolute_path(text.upload.path))
    fill_in 'Email', with: text.contributor.email
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'A user can upload a recording with extra information', delayed_job: true do
    recording = FactoryGirl.build(:recording, :with_record)
    record = recording.records.first
    visit new_recording_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(recording.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Email', with: recording.contributor.email
    fill_in 'Date', with: record.ref_date.strftime("%d/%m/%Y")
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'A user can upload a contribution with contact information' do

  end


  specify 'A user can view an upload with an approved record' do
    document = FactoryGirl.create(:document, :with_approved_record)
    visit medium_path(id: document.id)
    expect(page).to have_content(document.records.first.title)
  end

  specify "A user can't see an upload without an approved record" do
    document = FactoryGirl.create(:document, :with_record)
    visit medium_path(id: document.id)
    expect(page).not_to have_content(document.records.first.title)
  end

end
