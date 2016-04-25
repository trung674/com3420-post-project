# == Schema Information
#
# Table name: mods
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  isActive               :boolean
#  isAdmin                :boolean
#
# Indexes
#
#  index_mods_on_email                 (email) UNIQUE
#  index_mods_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :mod do
    email 'testuser@villagememories.com'
    password 'villagemems'
    password_confirmation 'villagemems'
    isActive true
    isAdmin false
  end
end
