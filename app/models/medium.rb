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
#

class Medium < ActiveRecord::Base
  has_many :records, dependent: :destroy
  attr_accessor :type
  validates :copyright, :acceptance => true

  accepts_nested_attributes_for :records
  mount_uploader :upload, MediumUploader
end

class Recording < Medium

end

class Image < Medium

end

class Document < Medium

end

class Text < Medium

end