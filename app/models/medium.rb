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
  # Mediums have a contributor and one or more records
  belongs_to :contributor, autosave: true
  has_many :records, dependent: :destroy, autosave: true

  # Links between media
  has_many :links, class_name: 'Link', foreign_key: 'med_one'

  attr_accessor :type, :text

  # Accepted nesting means we can just have a single form for uploads
  # instead of three seperate
  accepts_nested_attributes_for :records
  accepts_nested_attributes_for :contributor

  # Carrierwave uploader
  mount_uploader :upload, MediumUploader

  validates :upload, presence: true
  validates :copyright, :acceptance => true
  validates_presence_of :upload
  validates_presence_of :contributor
  validates_presence_of :records

  # Validates associated bubbling makes associated error messages more readable
  validates_associated_bubbling :records
  validates_associated_bubbling :contributor

  def all_records
    self.records.order('created_at')
  end

  def unapproved_records
    self.records.where(approved: false).order('created_at')
  end

  def approved_records
    self.records.where(approved: true).order('created_at')
  end

  def latest_record
    self.records.order('created_at').last
  end

  def latest_approved_record
    self.records.where(approved: true).order('created_at').last
  end

  def get_relevant_media
    # Get the ids of the linked media, filter out images
    media = Medium.where(id: self.links.collect{|item| item.med_two}).where.not(type: 'Image')

    # Currently filter out media with no approved records, but this might better somewhere else
    media.select{|medium| not medium.latest_approved_record.nil?}
  end

  def get_relevant_images
    # Get the ids of the linked media, filter out non-images
    media = Medium.where(id: self.links.collect{|item| item.med_two}, type: 'Image')
    media.select{|medium| not medium.latest_approved_record.nil?}
  end

  def get_addable_links
    # Addable links are media that aren't images, not already linked and also have an approved record
    Medium.where.not(id: [self.id, self.get_relevant_media].flatten, type: 'Image').select{|item| not item.latest_approved_record.nil?}
  end

  def get_addable_images
    # Addable image are those not already linked and also have an approved record
    Medium.where.not(id: [self.id, self.get_relevant_images].flatten).where(type: 'Image').select{|item| not item.latest_approved_record.nil?}
  end

  # These are the accepted mime types for each of the subclasses
  # This is just for the form, as we validate in the uploader
  def accepted_mimes
    case self.type
      when'Recording'
        '.wav,.mp3'
      when 'Document'
        '.pdf'
      when 'Image'
        '.jpeg,.jpg,.gif,.bmp,.png'
      else
        ''
    end
  end

end
