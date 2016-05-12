require 'rails_helper'

describe 'Search' do
  specify 'there is a table of results' do
    visit search_path
    expect(page).to have_css('.table-bordered')
  end

  specify 'can see all results if you have no params' do
    document = FactoryGirl.build(:document, :with_approved_record)
    record = document.records.first
    visit new_document_path
    fill_in 'Title', with: record.title
    attach_file('File', File.absolute_path(document.upload.path))
    fill_in 'Description', with: record.description
    fill_in 'Email', with: document.contributor.email
    check 'medium_copyright'
    submit_form
    # record = document.records.first
    visit search_path
    expect(page).to have_text(record.title)
  end

  specify 'empty params shows everything' do
    visit search_path
    expect(page).to have_text('Showing Documents, Recordings, Images, Texts for: "".')
  end

  # specify 'there is a table of results' do
  #   visit search_path
  #   expect(page).to have_css('.table-bordered')
  # end
  #
  # specify 'there is a table of results' do
  #   visit search_path
  #   expect(page).to have_css('.table-bordered')
  # end


end


describe 'Map' do
  specify 'the map is visible' do
    visit map_path
    expect(page).to have_css('#map')
  end
end

describe 'Contact' do
  specify 'A user sees a recaptcha on the contact page', recaptcha: true do
    visit contacts_path
    expect(page).to have_css('.g-recaptcha')
  end
end
