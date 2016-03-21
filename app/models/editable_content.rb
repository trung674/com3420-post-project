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

class EditableContent < ActiveRecord::Base
end
