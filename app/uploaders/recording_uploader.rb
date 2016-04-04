class RecordingUploader < MediumUploader
  after :store, :process_audio

  def process_audio(new_file)
    # Queue the transcription
    Delayed::Job.enqueue TranscriberUploaderJob.new(self.model.upload.path, self.model)
  end
end