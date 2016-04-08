# == Schema Information
#
# Table name: media
#
#  id             :integer          not null, primary key
#  upload         :string
#  transcript     :string
#  public_ref     :boolean
#  education_use  :boolean
#  public_archive :boolean
#  publication    :boolean
#  broadcasting   :boolean
#  editing        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#  contributor_id :integer
#
# Indexes
#
#  index_media_on_contributor_id  (contributor_id)
#

class Medium < ActiveRecord::Base
  belongs_to :contributor
  has_many :records, dependent: :destroy
  attr_accessor :type, :text

  validates :upload, presence: true
  validates :contributor, presence: true
  validates :copyright, :acceptance => true

  validates_associated :records
  validates_associated :contributor

  accepts_nested_attributes_for :records
  accepts_nested_attributes_for :contributor
  mount_uploader :upload, MediumUploader
end
