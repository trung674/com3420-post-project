# == Schema Information
#
# Table name: media
#
#  id          :integer          not null, primary key
#  title       :string           not null
#  description :text             not null
#  location    :string
#  upload      :string
#  transcript  :string
#  orig_date   :date
#  approved    :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Medium, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
