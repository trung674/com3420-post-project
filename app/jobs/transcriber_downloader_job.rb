require 'rest-client'
require 'tempfile'
require 'zip'

class TranscriberDownloaderJob < Struct.new(:src, :ses, :model)

  def perform
    response = RestClient.post('http://www.webasr.org/getstatus',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                               :src => src, :ses => ses)

    transcribe_status = response.to_str.partition('is: ').last.strip.downcase

    case transcribe_status
    when 'processing...'
      raise 'Still processing'
    when 'transcription completed'
      # Download the .zip file

      response = RestClient::Request.execute({:url => 'http://www.webasr.org/getfile', :email => ASR_EMAIL, :password => ASR_PASSWORD,
                                              :src => src, :ses => ses, :method => :get, :content_type => 'application/zip'})
      zipfile = Tempfile.new('downloaded')
      zipfile.binmode
      zipfile.write(response)

      Zip::ZipFile.open(zipfile.path) do |file|
        file.each do |content|
          #data = file.read(content)
          puts content
        end
      end

      # Upload the transcript file using carrier wave
      # TODO: handle the downloaded files
      # f = Tempfile.new(['transcript', '.xml'])
      # f.write(r.to_s)
      # model.transcript = f
      # f.close
      # f.unlink

      raise model.errors unless model.save!
    else
      # remove job?
      raise 'Status unknown'
    end
  end

  def reschedule_at(current_time, attempts)
    # TODO: decrease with more attempts as it's more likely the processing has finished
    current_time + 1.hour
  end
end