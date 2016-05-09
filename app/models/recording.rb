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

# Subclass of medium for recordings
class Recording < Medium
  # For a recording, we need to use a different uploader as it has to be transcribed
  # The returned transcript gets uploaded as well using the normal uploader
  mount_uploader :upload, RecordingUploader
  mount_uploader :transcript, MediumUploader
end
