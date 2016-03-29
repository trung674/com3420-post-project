class RecordingUploader < MediumUploader
  after :store, :process_audio

  def process_audio(new_file)
    # Queue the transcription
    Delayed::Job.enqueue TranscriberUploaderJob.new(new_file, self.model)
  end
end