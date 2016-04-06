require 'rest-client'
require 'tempfile'

class TranscriberDownloaderJob < Struct.new(:src, :ses, :model)

  def perform
    
    response = RestClient.post('http://www.webasr.org/getstatus',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                               :src => src, :ses => ses)
    case transcribe_status
    when 'queued'
      raise 'Still processing'
    when 'failed'
      # TODO: remove job as it will never complete!
    when 'killed'
    when 'completed'
      # Download the xml file containing the transcription

      # Upload the transcript file using carrier wave
      # TODO: need to handle xml file so its contents are viewable on the show page
      f = Tempfile.new(['transcript', '.xml'])
      f.write(r.to_s)
      model.transcript = f
      f.close
      f.unlink

      raise model.errors unless model.save!
    else
      raise 'Status unknown'
    end
  end

  def reschedule_at(current_time, attempts)
    # TODO: decrease with more attempts as it's more likely the processing has finished
    current_time + 1.hour
  end
end