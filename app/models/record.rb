# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  media_id    :integer
#  title       :string
#  description :string
#  location    :string
#  ref_date    :date
#  approved    :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_records_on_media_id  (media_id)
#

class Record < ActiveRecord::Base
  belongs_to :medium
end
