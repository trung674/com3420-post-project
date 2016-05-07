require 'rails_helper'
require 'spec_helper'

describe 'Wallpaper' do

  specify 'Mod can access wallpaper management page' do
    visit '/wallpapers'
    expect(page).to have_content 'Log in'
  end

  specify 'Mod can create a new wallpaper' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    fill_in 'Description', with: 'Wallpaper 1'
    attach_file('Image', File.join(Rails.root, '/spec/support/test-wallpaper.png'))
    submit_form
    expect(page).to have_content 'Wallpaper was successfully created.'
  end

  specify 'Mod can see list of all existing wallpapers' do
    wallpaper = FactoryGirl.create(:wallpaper)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    expect(page).to have_css('div.thumbnail', :minimum => 1)
  end

  specify 'Mod can edit desicription of a wallpaper' do
    wallpaper = FactoryGirl.create(:wallpaper)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    click_on 'Edit'
    fill_in 'Description', with: 'Test Edit description'
    submit_form
    expect(find('.thumbnail')).to have_content('Test Edit description')
  end

  specify 'Mod can delete a wallpaper' do
    wallpaper = FactoryGirl.create(:wallpaper)
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    click_on 'Delete'
    expect(page).to have_content 'Wallpaper was successfully removed.'
  end

  specify 'If there is 0 wallpaper in database, show warning to mod' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    expect(page).to have_content 'There are no wallpapers, please use form above to upload a new wallpaper'
  end

  specify 'Submit form without an attached wallpaper file will return error' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    fill_in 'Description', with: 'Wallpaper 1'
    submit_form
    expect(page).to have_content 'Something was wrong, please try again.'
  end

  specify 'Non-mod user can not access wallpaper management page' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    expect(page).to have_content 'Upload New Wallpaper'
  end


end
