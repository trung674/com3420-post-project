# == Schema Information
#
# Table name: links
#
#  id         :integer          not null, primary key
#  med_one    :integer
#  med_two    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Link, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
