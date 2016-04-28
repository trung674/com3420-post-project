require 'rails_helper'
require 'spec_helper'
require 'database_cleaner'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Mod' do
  
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

  specify 'I can approve record' do
    
    #Since approving records is not dependent on the media, I'm uploading a text file
    text = FactoryGirl.build(:text, :with_record)
    mod = FactoryGirl.create(:mod)
    
    #Upload the record
    record = text.records.first
    visit new_text_path
    fill_in 'Title', with: record.title
    fill_in 'Text', with: File.read(File.absolute_path(text.upload.path))
    fill_in 'Email', with: text.contributor.email
    check 'medium_copyright'
    submit_form
    
    #The test itself
    login_as(mod, :scope => :mod)
    visit '/media/1?record_id=1'

    #expect(page).to have_no_content 'Approved'
    #click_button('approve')
    #expect(page).to have_content 'A piece of history'
  end

  specify 'I can reject record' do
  end

  specify 'I can upload new wallpaper' do
  end

  specify 'I cannot login with an inactive account' do
  end

end
