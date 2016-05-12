require 'rails_helper'
require 'spec_helper'
require 'carrierwave/test/matchers'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Event' do
  include CarrierWave::Test::Matchers

  specify 'User can see list of all events in database' do
    event1 = FactoryGirl.create(:event)
    event2 = FactoryGirl.create(:event)
    visit events_path
    expect(page).to satisfy {|page| page.has_content?(event1.title) and page.has_content?(event2.title)}
  end

  specify 'If there is no event in database, show user a warning' do
    visit events_path
    expect(page).to have_content 'There are no upcoming events at the moment'
  end

  specify 'User can see detail information of an event' do
    event = FactoryGirl.create(:event)
    visit '/events/1'
    expect(page).to satisfy {|page| page.has_content?(event.title) and page.has_content?(event.description)}
  end

  specify 'Mod can create a new event' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/events/new'
    fill_in 'Title', with: 'Event 1'
    fill_in 'Location', with: 'test location '
    fill_in 'Time', with: '11pm - 4am'
    select '6', :from => 'event_date_3i'
    select 'June', :from => 'event_date_2i'
    select '2016', :from => 'event_date_1i'
    fill_in 'Description', with: 'test event'
    attach_file('Image', File.join(Rails.root, '/spec/support/test.jpg'))
    submit_form
    expect(page).to have_content 'Event was successfully created.'
  end

  specify 'Mod can edit information of an event' do
    event = FactoryGirl.create(:event)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/events/1/edit'
    fill_in 'Title', with: 'Event 1'
    submit_form
    expect(page).to have_content 'Event 1'
  end

  specify 'Mod can delete an event' do
    event = FactoryGirl.create(:event)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/events/1'
    click_on 'Delete'
    expect(page).to have_content 'Event was successfully destroyed.'
  end

  specify 'Non-mod user can not create new event' do
    visit '/events/new'
    expect(page).to have_content 'Log in'
  end

  specify 'Non-mod user can not edit an event' do
    event1 = FactoryGirl.create(:event)
    visit '/events/1/edit'
    expect(page).to have_content 'Log in'
  end


end
