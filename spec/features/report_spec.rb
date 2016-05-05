require 'rails_helper'

describe 'Report' do
  specify 'A user sees a recaptcha on the report page', recaptcha: true do
    document = FactoryGirl.create(:document, :with_approved_record)
    visit new_report_path(medium_id: document.id, record_title: document.records.first.title)
    expect(page).to have_css('.g-recaptcha')
  end
end