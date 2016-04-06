require 'rest-client'

class TranscriberUploaderJob < Struct.new(:file_path, :model)

  def perform
    puts file_path
    dir = File.dirname(file_path)
    new_file = File.join(dir, File.basename(file_path, File.extname(file_path))) + '_convert.wav'

    puts new_file

    # Convert the audio file to wav with 16k sample rate, 1 channel and 16 bits precision using ffmpeg via command line
    if system "ffmpeg -i \"#{file_path}\" -b:a 16k -ar 16000 -ac 1 -sample_fmt s16 \"#{new_file}\""

      response = RestClient.post('http://www.webasr.org/newupload', :file1 => File.new(new_file), :email => ASR_EMAIL,
                                 :password => ASR_PASSWORD, :language => 'English', :enviroment => 'Media',
                                 :systems => 'General media transcription')


      src = response.to_str.match(/src=([^\/.]*)"$/)[1]
      src = src.slice(0..(src.index('"') - 1))
      ses = response.to_str.match(/ses=([^\/.]*)"$/)[1]

      # Schedule the downloader job to run 2 hours from now, uses the given src and ses from webASR
      Delayed::Job.enqueue(TranscriberDownloaderJob.new(src, ses, model), :run_at => 2.hours.from_now)
    else
      raise 'Error converting audio file'
    end
  end


  def reschedule_at(current_time, attempts)
    current_time + 30.minutes
  end

end