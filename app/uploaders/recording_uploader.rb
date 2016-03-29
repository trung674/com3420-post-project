class RecordingUploader < MediumUploader
  include CarrierWave::FFMPEG

  after :store, :process_audio

  def process_audio(new_file)
    # Queue the transcription
    TranscriberUploaderJob.delay.perform(new_file, self.model)
  end
end