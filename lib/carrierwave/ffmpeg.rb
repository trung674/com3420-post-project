module CarrierWave
  module FFMPEG
    module ClassMethods
      def convert_audio
        process convert_audio
      end
    end

    def convert_audio
      # Queue the conversion
      Delayed::Job.enqueue TranscriberJob.new(current_path, self.model)
    end
  end
end