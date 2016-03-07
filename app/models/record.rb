# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  title       :string
#  description :string
#  location    :string
#  ref_date    :date
#  approved    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  medium_id   :integer
#
# Indexes
#
#  index_records_on_medium_id  (medium_id)
#

class Record < ActiveRecord::Base
  belongs_to :medium
end
