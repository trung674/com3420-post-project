require 'http'

class TranscriberJob < Struct.new(:file_path, :model)

  def perform
    dir = File.dirname(file_path)
    new_file = File.join(dir, File.basename(file_path, File.extname(file_path))) + '_convert.wav'

    # Convert the audio file to wav with 16k sample rate, 1 channel, and 16 bits precision
    # Requires ffmpeg is installed added to path
    if system "ffmpeg -i \"#{file_path}\" -b:a 16k -ar 16000 -ac 1 -sample_fmt s16 \"#{new_file}\""
      orig = HTTP.post("http://mini-vm21.dcs.shef.ac.uk/controller", :params => {:event => 'APICheckLogin',
                                                                              :client => ASR_ID})

      r = HTTP.cookies(orig.cookies).headers(:accept=> 'text/xml').
          post("http://mini-vm21.dcs.shef.ac.uk/controller", :params => {:event => 'APIReceiveFileDataXML'},
               :body => xml(new_file))

    end
  end

  private
    def xml(file_path)
      # Create xml markup necessary for webASR

      xml_string ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
      xml_string +="<java version=\"1.6.0_10-rc2\" class=\"java.beans.XMLDecoder\">\n"
      xml_string +=" <object class=\"java.util.Vector\">\n"
      xml_string +="  <void method=\"add\">\n"
      xml_string +="   <object class=\"uk.ac.shef.dcs.webasr.upload.FileData\">\n"
      xml_string +="    <void property=\"clientFilename\">\n"
      xml_string +='     <string>'+File.basename(file_path, File.extname(file_path))+"</string>\n"
      xml_string +="    </void>\n"
      xml_string +="        <void property=\"clientPath\">\n"
      xml_string +="     <string>#{file_path}</string>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"bytes\">\n"
      xml_string +='     <long>'+File.size(file_path).to_str+"</long>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"missingBytes\">\n"
      xml_string +='     <long>'+File.size(file_path).to_str+"</long>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"bits\">\n"
      xml_string +="     <int>16</int>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"samplingRate\">\n"
      xml_string +="     <double>16000</double>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"channels\">\n"
      xml_string +="     <int>1</int>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"fileType\">\n"
      xml_string +="     <string>PCM_SIGNED</string>\n"
      xml_string +="    </void>\n"
      xml_string +="    <void property=\"md5\">\n"
      xml_string +='     <long>'+Digest::MD5.hexdigest(file_path)+"</long>\n"
      xml_string +="    </void>\n"
      xml_string +="   </object>\n"
      xml_string +="  </void>\n"
      xml_string +=" </object>\n"
      xml_string +="</java>\n"
      
      xml = xml_string
    end

end