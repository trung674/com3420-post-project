module CarrierWave
  module FFMPEG
    module ClassMethods
      def convert_audio
        process convert_audio
      end
    end

    def convert_audio
      # adding some options
      directory = File.dirname(current_path)
      puts File.join(directory, current_path)

      # add ActiveJob job
      ConverterJob.perform_later(current_path, self.model)
    end
  end
end