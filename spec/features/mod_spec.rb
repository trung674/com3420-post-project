require 'rails_helper'
require 'spec_helper'
require 'database_cleaner'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Mod' do

  specify 'I can log in' do
    #TODO
  end

  specify 'I can view moderators' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/modlist'
    expect(page).to have_content 'List of all current Moderators'
    within(:css, 'table.table.table-bordered') { expect(page).to have_content 'testuser@villagememories.com' }
  end

  specify 'I can activate moderator account' do
    mod = FactoryGirl.create(:mod)
    inactive = FactoryGirl.create(:inactiveMod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: inactive.email
    click_button 'Update'
    expect(page).to have_content 'Moderator successfully activated'
    visit '/modlist'
    find('tr', text: 'inactivemod@villagememories.com').should have_content('Yes')
  end

  specify 'I can deactivate moderator account' do
    mod = FactoryGirl.create(:mod)
    active = FactoryGirl.create(:activeMod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: active.email
    click_button 'Update'
    expect(page).to have_content 'Moderator successfully deactivated'
    visit '/modlist'
    find('tr', text: 'activemod@villagememories.com').should have_no_content('Yes')
  end

  specify 'I cannot deactivate an admin' do
    mod = FactoryGirl.create(:mod)
    active = FactoryGirl.create(:activeMod)
    login_as(active, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: mod.email
    click_button 'Update'
    expect(page).to have_content 'Site administrators cannot be deactivated.'
    visit '/modlist'
    find('tr', text: 'testuser@villagememories.com').should have_no_content('No')
  end

  specify 'I cannot enter a non-existent moderator' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: 'nonexistentuser@gmail.com'
    click_button 'Update'
    expect(page).to have_content 'That moderator does not exist.'
  end

  specify 'I can approve edits' do
    #Since approving records is not dependent on the media, I'm uploading a text file
    text = FactoryGirl.create(:text, :with_record)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: text.id)
    expect(page).to have_content 'Unapproved'
    click_button "Approve Edit"
    expect(page).to have_no_content 'Unapproved'
  end

  specify 'I can reject edits' do
    text = FactoryGirl.create(:text, :with_record)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: text.id)
    expect(page).to have_content 'Unapproved'
    click_button "Remove Edit"
    expect(page).to have_no_content 'Approved'
  end

  specify 'I can view the contact information of a contributor for a medium' do
    #TODO
  end

  specify 'I can upload new wallpaper' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    fill_in 'wallpaper_description', with: 'Test wallpaper'
    attach_file('wallpaper_image', File.absolute_path('./spec/fixtures/uploads/Wallpaper.jpg'))
    click_button 'Create Wallpaper'
    expect(page).to have_content 'Wallpaper was successfully created'
    expect(page).to have_content 'Test wallpaper'
  end


  specify 'I can see how many unique views an event has' do
   testevent = FactoryGirl.create(:event)
   mod = FactoryGirl.create(:mod)
   visit '/events'
   click_link 'Test Event'
   expect(page).to have_no_content 'unique views' #First view, hidden from user
   login_as(mod, :scope => :mod)
   visit '/events'
   click_link 'Test Event'
   expect(page).to have_content '2 unique views of this event' #Mod view
  end
end
