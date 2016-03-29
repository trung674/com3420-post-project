require 'http'
require 'tempfile'

class TranscriberDownloaderJob < Struct.new(:upload_id, :model)

  def perform
    # Login to the webASR service, orig.cookies holds the session id
    orig = HTTP.post('http://mini-vm21.dcs.shef.ac.uk/controller', :params => {:event => 'APICheckLogin', :client => ASR_ID})

    if orig.status != 200
      raise 'Error connecting to webASR'
    end

    # Get the status of the transcription
    r = HTTP.cookies(orig.cookies).post('http://mini-vm21.dcs.shef.ac.uk/controller',
                                        :params => {:event => 'APIGetStatus', :uploadID => upload_id})

    if r.status != 200
      raise 'Error getting status'
    end

    transcribe_status = r.headers['status']

    case transcribe_status
    when 'queued'
      raise 'Still processing'
    when 'failed'
      # TODO: remove job as it will never complete!
    when 'killed'
    when 'completed'
      # Download the xml file containing the transcription
      r = HTTP.cookies(orig.cookies).post('http://mini-vm21.dcs.shef.ac.uk/controller',
                                          :params => {:event => 'APIGetDocument', :type => 'transcript',
                                                      :format => 'xml', :uploadID => upload_id})
      # Upload the transcript file using carrier wave
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