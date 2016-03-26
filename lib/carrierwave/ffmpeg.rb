require 'streamio-ffmpeg'

# This is the audio conversion file for the transcripts
# Converts a .wav file into a 16kHz, single channel, 16 bit precision .wav file
# Using the ffmpeg libary (installed separately) to be sent to webASR

module CarrierWave
  module FFMPEG
    module ClassMethods
      def resample
        process :resample
      end
    end

    def resample
      directory = File.dirname(current_path)
      tmpfile = File.join(directory, "tmp")

      File.move(current_path, tmpfile)

      file = ::FFMPEG::Movie.new(tmpfile)
      file.transcode(current_path, {:audio_bitrate => 16, audio_channels: 1, custom: '-sample_fmt s16'})

      File.delete(tmpfile)
    end
  end
end