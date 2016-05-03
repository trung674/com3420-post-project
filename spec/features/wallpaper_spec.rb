require 'rails_helper'

describe 'Wallpaper' do

  Specify 'Mod can access wallpaper management page' do
    visit '/wallpapers'
    expect(page).to have_content 'Log in'
  end

  specify 'Non-mod user can not access wallpaper management page' do
    mod = FactoryGirl.create(:mod)
    login_as(mod, :scope => :mod)
    visit '/wallpapers'
    expect(page).to have_content 'Upload New Wallpaper'
  end



end
