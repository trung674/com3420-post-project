class RecordingUploader < MediumUploader
  after :store, :process_audio

  def process_audio(new_file)
    convert_audio
  end
end