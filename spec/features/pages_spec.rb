require 'rails_helper'

describe 'Search' do
  it 'should show records' do

    true.should == true
  end
end

describe 'Contact' do
  specify 'A user sees a recaptcha on the contact page', recaptcha: true do
    visit contacts_path
    expect(page).to have_css('.g-recaptcha')
  end
end
