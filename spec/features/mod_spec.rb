require 'rails_helper'
require 'spec_helper'
require 'database_cleaner'

include Warden::Test::Helpers
Warden.test_mode!

describe 'Mod' do

  specify 'I can view moderators' do
    mod = FactoryGirl.create(:admin)
    login_as(mod, :scope => :mod)
    visit '/modlist'
    within(:css, 'table.table.table-bordered') { expect(page).to have_content mod.email }
  end

  specify 'I can activate moderator account' do
    mod = FactoryGirl.create(:admin)
    inactive = FactoryGirl.create(:inactiveMod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: inactive.email
    click_button 'Update'
    expect(page).to have_content 'Moderator successfully activated'
    visit '/modlist'
    find('tr', text: inactive.email).should have_content('Yes')
  end

  specify 'I can deactivate moderator account' do
    mod = FactoryGirl.create(:admin)
    active = FactoryGirl.create(:activeMod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: active.email
    click_button 'Update'
    expect(page).to have_content 'Moderator successfully deactivated'
    visit '/modlist'
    find('tr', text: active.email).should have_no_content('Yes')
  end

  specify 'I cannot deactivate an admin' do
    mod = FactoryGirl.create(:admin)
    active = FactoryGirl.create(:admin)
    login_as(active, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: mod.email
    click_button 'Update'
    expect(page).to have_content 'Site administrators cannot be deactivated.'
    visit '/modlist'
    find('tr', text: mod.email).should have_no_content('No')
  end

  specify 'I cannot enter a non-existent moderator' do
    mod = FactoryGirl.create(:admin)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'mod_email', with: 'nonexistentuser@gmail.com'
    click_button 'Update'
    expect(page).to have_content 'That moderator does not exist.'
  end

  specify 'I can approve edits' do
    #Since approving records is not dependent on the media, I'm uploading a text file
    text = FactoryGirl.create(:text, :with_record)
    mod = FactoryGirl.create(:activeMod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: text.id)
    expect(page).to have_content 'Unapproved'
    click_button "Approve Edit"
    expect(page).to have_no_content 'Unapproved'
  end

  specify 'I can reject edits' do
    text = FactoryGirl.create(:text, :with_record)
    mod = FactoryGirl.create(:activeMod)
    login_as(mod, :scope => :mod)
    visit medium_path(id: text.id)
    expect(page).to have_content 'Unapproved'
    click_button "Remove Edit"
    expect(page).to have_no_content 'Approved'
  end

  specify 'I can view the contact information of a contributor for a medium' do
    text = FactoryGirl.create(:text, :with_record)
    mod = FactoryGirl.create(:activeMod)
    login_as(mod, scope: :mod)
    visit '/modpanel'
    click_button 'Contact'

    # TODO: this test is javascript based so no clue how were gonna test this
    within('#contact') do
      expect(page).to have_content(text.contributor.email)
    end
  end

  specify 'I can edit the contact details' do
    mod = FactoryGirl.create(:activeMod)
    visit '/contacts'
    expect(page).to have_content '23 Edward Street, Sheffield, UK, S3 7SF'
    expect(page).to have_content '(+44) 111111111111'
    expect(page).to have_content 'Monday - Friday: 9:00 AM to 5:00 PM'
    login_as(mod, :scope => :mod)
    visit '/contacts/edit'
    fill_in 'editable_content_contact_address', with: '742 Evergreen Terrace, Springfield, USA'
    fill_in 'editable_content_contact_phone', with: '555-6832'
    fill_in 'editable_content_contact_hours', with: 'Monday to Friday 18:00 - 18:30'
    click_button 'Submit'
    visit '/contacts'
    expect(page).to have_content '742 Evergreen Terrace, Springfield, USA'
    expect(page).to have_content '555-6832'
    expect(page).to have_content 'Monday to Friday 18:00 - 18:30'
  end

  specify 'I can see how many unique views an event has' do
   mod = FactoryGirl.create(:activeMod)
   login_as(mod, :scope => :mod)
   visit '/modpanel'
   click_link 'Create Event'
   fill_in 'event_title', with: 'Test Event'
   click_button 'Create Event'
   expect(page).to have_content '1 unique views of this event' #Mod already does one view
   logout(:mod)
   visit '/events'
   click_link 'Test Event'
   expect(page).to have_no_content 'unique views' #hidden from user
  end
end
