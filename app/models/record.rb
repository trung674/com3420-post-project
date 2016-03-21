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
#  latitude    :float
#  longitude   :float
#
# Indexes
#
#  index_records_on_medium_id  (medium_id)
#

class Record < ActiveRecord::Base
  belongs_to :medium

  auto_strip_attributes :title, :description, :location, :squish => true

  # Should descriptions be required?
  validates :title, presence: true
  validates :description, presence: true, if: :should_require_description?

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  private

    def should_require_description?
      # Thorough testing for this!
      medium.respond_to?(:text)
    end
end
