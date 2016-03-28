class ConverterJob < ActiveJob::Base
  queue_as :default

  def perform(file_path, model)
    dir = File.dirname(file_path)
    new_file = File.join(dir,'dog.wav')

    # Convert the audio file to wav with 16k bitrate, 1 channel, and 16 bits precision
    # Requires ffmpeg is installed and added to path
    system "ffmpeg -i \"#{file_path}\" -b:a 16k -ac 1 -sample_fmt s16 \"#{new_file}\""
  end

end