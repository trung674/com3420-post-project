require 'rest-client'
require 'tempfile'
require 'zip'

# webASR REST API: http://www.webasr.org/apimanual
class TranscriberDownloaderJob < Struct.new(:src, :ses, :model)

  def perform
    # Get the status from webASR using the src and ses values
    response = RestClient.post('http://www.webasr.org/getstatus',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                               :src => src, :ses => ses)

    # Returns a string so get the status section
    transcribe_status = response.to_str.partition('is: ').last.strip.downcase

    if transcribe_status.include? 'processing'
      raise 'Still processing'
    elsif transcribe_status.include? 'completed'
      # Transcription is complete so download the .zip file
      response = RestClient.post('http://www.webasr.org/getfile',:email => ASR_EMAIL, :password => ASR_PASSWORD,
                                 :src => src, :ses => ses)

      # Store the zip file temporarily
      zip_file = Tempfile.new('downloaded')
      zip_file.binmode
      zip_file.write(response.to_s)

      upload_dir = File.dirname(model.upload.path)

      # Extract the transcription files from the zip and store them in the uploads folder
      Zip::File.open(zip_file.path) do |file|
        file.each do |content|
          data = file.read(content)
          ext_name = File.extname(content.to_s)

          # Have to save ascii and binary files differently
          if ext_name == '.pdf' or ext_name == '.ttml'
            File.open(File.join(upload_dir, 'transcript') + ext_name, 'wb') {|f| f.write(data) }
          elsif ext_name == '.xml'
            File.open(File.join(upload_dir, 'transcript.xml'), 'w') {|f| f.write(data) }
          else
            puts content.to_s
          end

        end
      end

      # Upload the transcript file using carrier wave, currently will be the .pdf file. Then save the model
      model.transcript = File.open(File.join(upload_dir, 'transcript.pdf'))

      raise model.errors unless model.save!
    else
      # remove job?
      raise transcribe_status + 'Status unknown'
    end
  end

  def reschedule_at(current_time, attempts)
    current_time + 2.hours
  end
end