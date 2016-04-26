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
    inactiveMod = FactoryGirl.create(:inactiveMod)
    login_as(mod, :scope => :mod)
    visit '/modedit'
    fill_in 'email', with: inactiveMod.email
    click_button 'Update'
    logout(:mod)
    login_as(inactiveMod, :scope => :inactiveMod)
    visit '/modpanel'
    expect(page).to have_content 'Welcome #{current_mod.email}'
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
