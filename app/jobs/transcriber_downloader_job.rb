require 'rest-client'
require 'tempfile'
require 'zip'

class TranscriberDownloaderJob < Struct.new(:src, :ses, :model)

  def perform
    response = RestClient.post('http://www.webasr.org/getstatus',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                               :src => src, :ses => ses)

    transcribe_status = response.to_str.partition('is: ').last.strip.downcase

    if transcribe_status.include? 'processing'
      raise 'Still processing'
    elsif transcribe_status.include? 'completed'
      # Download the .zip file
      response = RestClient.post('http://www.webasr.org/getfile',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                                 :src => src, :ses => ses)

      zip_file = Tempfile.new('downloaded')
      zip_file.binmode
      zip_file.write(response.to_s)

      dir = File.dirname(model.upload.path)

      Zip::File.open(zip_file.path) do |file|
        file.each do |content|
          data = file.read(content)
          ext_name = File.extname(content.to_s)

          if ext_name == '.pdf' or ext_name == '.ttml'
            File.open(File.join(dir, 'transcript') + ext_name, 'wb') {|f| f.write(data) }
          elsif ext_name == '.xml'
            File.open(File.join(dir, 'transcript.xml'), 'w') {|f| f.write(data) }
          else
            puts content.to_s
          end
        end
      end

      # Upload the transcript file using carrier wave, currently will be the .pdf file
      model.transcript = File.join(dir, 'transcript.pdf')

      raise model.errors unless model.save!
    else
      # remove job?
      raise transcribe_status + 'Status unknown'
    end
  end

  def reschedule_at(current_time, attempts)
    # TODO: decrease with more attempts as it's more likely the processing has finished
    current_time + 1.hour
  end
end