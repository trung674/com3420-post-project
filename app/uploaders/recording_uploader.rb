class RecordingUploader < MediumUploader
  after :store, :process_audio
  after :store, :delete_tmp_dir

  def process_audio(new_file)
    # Queue the transcription job
    Delayed::Job.enqueue TranscriberUploaderJob.new(self.model.upload.path, self.model)
  end
end