# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  date        :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  image       :string
#  location    :string
#  time        :string
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
