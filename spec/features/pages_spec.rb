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

  specify 'A user sees contact info  on the contact page' do
    content = FactoryGirl.create(:editable_content)
    visit contacts_path
    expect(page).to have_content('23 Edward Street, Sheffield, UK, S3 7SF')
  end

end
