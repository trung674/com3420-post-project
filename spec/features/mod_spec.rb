require 'rails_helper'
require 'spec_helper'
require 'database_cleaner'

describe 'Mod' do
  
  before :each do
    Capybara.javascript_driver = :webkit
    Capybara.current_driver = Capybara.javascript_driver
  end
  
  let!(:mod) { FactoryGirl.create(:mod) }
  
  specify 'I can log in', javascript: true do
    visit '/mods/sign_in'
    fill_in 'Email', with: mod.email
    fill_in 'Password', with: mod.password
    click_button 'Log in'
    #expect(page).to have_content 'Welcome {#user.email}'
    expect(page).to have_content 'Edits Waiting Approval'
  end
  
  specify 'I can view moderators' do
  end

  specify 'I can activate moderator account' do
  end

  specify 'I can deactivate moderator account' do
  end

  specify 'I cannot deactivate an admin' do
  end

  specify 'I can approve record' do
  end

  specify 'I can reject record' do
  end

  specify 'I can upload new wallpaper' do
  end

  specify 'I can log out' do
  end

  specify 'I can create an inactive account' do
  end

  specify 'I cannot login with an inactive account' do
  end

end
