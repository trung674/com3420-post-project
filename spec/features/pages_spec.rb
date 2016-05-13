require 'rails_helper'

describe 'Search' do
  specify 'there is a table of results' do
    visit search_path
    expect(page).to have_css('.table-bordered')
  end

  specify 'can see all results' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit search_path
    expect(page).to have_text(record.title)
  end

  specify 'empty params shows search string is empty' do
    visit search_path
    expect(page).to have_text('Showing Documents, Recordings, Images, Texts for: "".')
  end

  specify 'partial title match returns a result' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit root_path
    find('.form-control').set((record.title)[2,3])
    click_button 'Search'
    expect(page).to have_text(record.title)
  end

  specify 'cannot see unapproved records' do
    document = FactoryGirl.create(:document, :with_record)
    record = document.records.first
    visit search_path
    expect(page).to_not have_text(record.title)
  end

  specify 'searching for a document returns a document' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit root_path
    find("#items_[value='Document']").set(true)
    click_button 'Search'
    expect(page).to have_text(record.title)
  end

  # this obviously applies for each type etc
  specify 'search for image doesnt return document' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit root_path
    find("#items_[value='Image']").set(true)
    click_button 'Search'
    expect(page).to_not have_text(record.title)
  end

  specify 'pages says what you searched' do
    visit root_path
    find("#items_[value='Image']").set(true)
    find('.form-control').set('test string')
    click_button 'Search'
    expect(page).to have_text('Showing Images for: "test string".')
  end

  specify 'record isnt returned if the search string doesnt match' do
    document = FactoryGirl.create(:document, :with_approved_record)
    record = document.records.first
    visit root_path
    find('.form-control').set('aehafkrl;hda;ehjkajfshd;kjha;fjhaouwhao')
    click_button 'Search'
    expect(page).to_not have_text(record.title)
  end

  specify 'search only returns the most recently approved record' do
    document = FactoryGirl.create(:document, :with_approved_record)
    FactoryGirl.create(:record, medium: document, title: 'new title', approved: true)
    visit search_path
    expect(page).to have_text('new title')
    expect(page).to_not have_text(document.records.first.title)
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

describe 'Home' do

  specify 'homepage has a picture displayed' do
    FactoryGirl.create(:wallpaper)
    visit root_path
    expect(page).to have_css('.carousel-inner')
  end

  specify 'homepage has welcome message displayed' do
    visit root_path
    expect(page).to have_text('Welcome To Village Memories Group Website')
  end

  specify 'homepage displays recently approved uploads' do
    upload = FactoryGirl.create(:image, :with_approved_record)
    visit root_path
    expect(page).to have_text(upload.records.first.title)
  end

  specify 'homepage displays upcoming events' do
    event = FactoryGirl.create(:event)
    visit root_path
    expect(page).to have_text(event.title)
  end

end

describe 'About' do
  specify 'about message is present' do
    visit about_path
    expect(page).to have_css('.mercury-region#about_content')
    expect(page).to have_text('About Us')
  end
end
