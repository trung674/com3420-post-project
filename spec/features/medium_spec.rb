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
    fill_in 'Location', with: record.location


    # These are hidden fields on the page, not sure how we would click on the map to test this
    first('input#latitude-input', visible: false).set(record.latitude)
    first('input#longitude-input', visible: false).set(record.longitude)

    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'A user can upload a medium with contact information' do
    document = FactoryGirl.build(:document, :with_record)
    record = document.records.first
    visit new_document_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(document.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Name', with: document.contributor.name
    fill_in 'Email', with: document.contributor.email
    fill_in 'Phone Number', with: document.contributor.phone
    check 'medium_copyright'
    submit_form

    expect(page).to have_content 'Upload successful'
  end

  specify 'A user can view an upload with an approved record' do
    document = FactoryGirl.create(:document, :with_approved_record)
    visit medium_path(id: document.id)
    expect(page).to have_content(document.records.first.title)
  end

  specify "A user can't see an upload with no approved records" do
    document = FactoryGirl.create(:document, :with_record)
    visit medium_path(id: document.id)
    expect(page).not_to have_content(document.records.first.title)
  end

  specify 'A moderator can see an upload with no approved records' do
    document = FactoryGirl.create(:document, :with_record)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: document.id)
    expect(page).to have_content(document.records.first.title)
  end

  specify 'A user can see the edit history of approved records for a medium' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record2 = FactoryGirl.create(:record, medium: document, approved: true)
    record3 = FactoryGirl.create(:record, medium: document)
    visit medium_path(id: document.id)
    expect(page).to have_select('record_id', :options => [document.records.first.to_s, record2.to_s])
  end

  specify 'A user can not see the edit history of unapproved records for a medium' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record2 = FactoryGirl.create(:record, medium: document, approved: true)
    record3 = FactoryGirl.create(:record, medium: document)
    visit medium_path(id: document.id)
    expect(page).not_to have_select('record_id', :options => [document.records.first.to_s, record2.to_s ,record3.to_s])
  end

  specify 'A moderator can see the edit history of all records for a medium' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record2 = FactoryGirl.create(:record, medium: document, approved: true)
    record3 = FactoryGirl.create(:record, medium: document)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: document.id)
    expect(page).to have_select('record_id', :options => [document.records.first.to_s_mod, record2.to_s_mod ,record3.to_s_mod])
  end

  specify 'A user can view a different edit for a medium' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record1 = document.records.first
    record2 = FactoryGirl.create(:record, title: 'Different', medium: document, approved: true)
    visit medium_path(id: document.id)

    expect(page).to have_content(record2.title)
    expect(page).to have_select('record_id', :options => [record1.to_s, record2.to_s])
    select(record1.to_s, from: 'record_id')
    click_button 'View'

    expect(page).to have_content(record1.title)
    expect(page).not_to have_content(record2.title)
  end



end
