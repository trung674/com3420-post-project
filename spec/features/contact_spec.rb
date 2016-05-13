require 'rails_helper'
require 'spec_helper'
require 'carrierwave/test/matchers'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Contact' do

  specify 'User can contact the moderator via the contact form' do
    visit '/contacts'
    fill_in 'contact_name', with: 'Test Name'
    fill_in 'contact_email', with: 'test@email.com'
    fill_in 'contact_message', with: 'Test message'
    click_button 'Send message'
    expect(page).to have_content 'Message sent successfully'
  end

  specify 'User cannot contact moderator providing no information' do
    visit '/contacts'
    click_button 'Send message'
    expect(page).to have_content '2 errors'
    expect(page).to have_content 'Name can\'t be blank'
    expect(page).to have_content 'Email can\'t be blank'
  end

  specify 'User cannot contact moderator without providing email' do
    visit '/contacts'
    fill_in 'contact_name', with: 'Test Name'
    click_button 'Send message'
    expect(page).to have_content '1 error'
    expect(page).to have_content 'Email can\'t be blank'
  end

  specify 'User cannot contact moderator without providing name' do
    visit '/contacts'
    fill_in 'contact_email', with: 'test@email.com'
    click_button 'Send message'
    expect(page).to have_content '1 error'
    expect(page).to have_content 'Name can\'t be blank'
  end

end
