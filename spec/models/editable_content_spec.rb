# == Schema Information
#
# Table name: editable_contents
#
#  id         :integer          not null, primary key
#  name       :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe EditableContent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
