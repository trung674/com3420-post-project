require 'http'

class TranscriberUploaderJob < Struct.new(:file_path, :model)

  def perform
    puts file_path
    dir = File.dirname(file_path)
    new_file = File.join(dir, File.basename(file_path, File.extname(file_path))) + '_convert.wav'

    puts new_file

    # Convert the audio file to wav with 16k sample rate, 1 channel and 16 bits precision using ffmpeg via command line
    if system "ffmpeg -i \"#{file_path}\" -b:a 16k -ar 16000 -ac 1 -sample_fmt s16 \"#{new_file}\""

      # Login to the webASR service, orig.cookies holds the session id
      # orig = HTTP.post('http://mini-vm21.dcs.shef.ac.uk/controller', :params => {:event => 'APICheckLogin', :client => ASR_ID})
      #
      # if orig.status != 200
      #   raise 'Error connecting to webASR'
      # end
      #
      # # Send the xml data file to webASR
      # r = HTTP.cookies(orig.cookies).headers(:accept => 'text/xml').
      #     post('http://mini-vm21.dcs.shef.ac.uk/controller', :params => {:event => 'APIReceiveFileDataXML'}, :body => xml(new_file))
      #
      # if r.status != 200
      #   raise 'Error sending xml file'
      # end
      #
      # # send the audio file to webASR
      # r = HTTP.cookies(orig.cookies).headers(:accept => 'application/octet-stream').
      #     post('http://mini-vm21.dcs.shef.ac.uk/controller', :params => {:event => 'APIReceiveFile'}, :body => File.read(new_file))
      #
      # if r.status != 200
      #   raise 'Error sending audio file'
      # end

      # upload_id = r.headers['UploadID']y

      r = HTTP.post('http://www.webasr.org/newupload',
        :params => {:email => ASR_EMAIL, :password => ASR_PASSWORD, :language => 'English', :enviroment => 'media',
                    :systems => 'General media transcription',
                    :file1 => File.read(new_file).force_encoding('ISO-8859-1').encode('utf-8', replace: nil)})

      puts "123 #{r.headers['src']}"

      # Schedule the downloader job to run 2 hours from now, uses the given upload id from webASR
      Delayed::Job.enqueue(TranscriberDownloaderJob.new(upload_id, model), :run_at => 2.hours.from_now)
    else
      raise 'Error converting audio file'
    end
  end


  def reschedule_at(current_time, attempts)
    current_time + 30.minutes
  end

  private
    def xml(file_path)
      # Create xml markup necessary for webASR

      xml_string = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      xml_string += "<java version=\"1.6.0_10-rc2\" class=\"java.beans.XMLDecoder\">\n"
      xml_string += " <object class=\"java.util.Vector\">\n"
      xml_string += "  <void method=\"add\">\n"
      xml_string += "   <object class=\"uk.ac.shef.dcs.webasr.upload.FileData\">\n"
      xml_string += "    <void property=\"clientFilename\">\n"
      xml_string += '     <string>'+File.basename(file_path, File.extname(file_path))+"</string>\n"
      xml_string += "    </void>\n"
      xml_string += "        <void property=\"clientPath\">\n"
      xml_string += "     <string>#{file_path}</string>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"bytes\">\n"
      xml_string += '     <long>'+File.size(file_path).to_s+"</long>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"missingBytes\">\n"
      xml_string += '     <long>'+File.size(file_path).to_s+"</long>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"bits\">\n"
      xml_string += "     <int>16</int>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"samplingRate\">\n"
      xml_string += "     <double>16000</double>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"channels\">\n"
      xml_string += "     <int>1</int>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"fileType\">\n"
      xml_string += "     <string>PCM_SIGNED</string>\n"
      xml_string += "    </void>\n"
      xml_string += "    <void property=\"md5\">\n"
      xml_string += '     <long>'+Digest::MD5.hexdigest(file_path)+"</long>\n"
      xml_string += "    </void>\n"
      xml_string += "   </object>\n"
      xml_string += "  </void>\n"
      xml_string += " </object>\n"
      xml_string += "</java>\n"
    end

end