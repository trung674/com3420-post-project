require 'rails_helper'

describe 'Search' do
  specify 'there is a table of results' do
    visit search_path
    expect(page).to have_css('.table-bordered')
  end

  specify 'can see a result' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit search_path
    expect(page).to have_text(record.title)
  end

  specify 'empty params shows search string is empty' do
    visit search_path
    expect(page).to have_text('Showing Documents, Recordings, Images, Texts for: "".')
  end

  specify 'with params shows search string' do
    visit URI.parse(URI.encode('search?utf8=✓&search=string&commit=Search'))
    expect(page).to have_text('Showing Documents, Recordings, Images, Texts for: "string".')
  end

  specify 'string match and type match gives a result' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit URI.parse(URI.encode("search?utf8=✓&search=#{record.title}&commit=Search&items%5B%5D=Document"))
    expect(page).to have_text(record.title)
  end

  specify 'cannot see unapproved records' do
    document = FactoryGirl.create(:document, :with_record)
    record = document.records.first
    visit search_path
    expect(page).to have_no_content(record.title)
  end

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
