module CarrierWave
  module FFMPEG
    module ClassMethods
      def convert_audio
        process convert_audio
      end
    end

    def convert_audio
      directory = File.dirname(current_path)
      tmpfile = File.join(directory, "tmp")
      File.rename(current_path, tmpfile)

      new_name = File.basename(current_path, '.*') + '.wav'
      encoded_file = File.join(directory, new_name)
      # adding some options
      options = {:audio_bitrate => 16, audio_channels: 1, custom: '-sample_fmt s16'}

      # add ActiveJob job
      ConverterJob.perform_later(tmpfile, encoded_file, self.model, options)
    end
  end
end