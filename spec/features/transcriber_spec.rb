require 'rails_helper'

describe 'Transcriber' do

  specify 'The transcriber upload job should be queued when a recording is uploaded', delayed_job: true do
      expect(Delayed::Job.count).to eq(0)
      FactoryGirl.create(:recording, :with_record)
      expect(Delayed::Job.count).to eq(1)
  end

  specify 'Transcription job downloads the transcription file and attaches it to the model' do
    stub_request(:any, 'http://www.webasr.org/newupload').to_return(status: 200, body: "ses=\"1\" src=\"1\"")
    stub_request(:any, 'http://www.webasr.org/getstatus').to_return(status: 200, body: 'is: completed')
    stub_request(:any, 'http://www.webasr.org/getfile').to_return(body: IO.binread(File.join(Rails.root, '/spec/fixtures/transcription.zip')), status: 200)
    recording = FactoryGirl.create(:recording, :with_record)
    expect(recording.transcript).to_not be(nil?)
  end

  specify 'Transcription job raises an error for an unfinished transcription' do
    stub_request(:any, 'http://www.webasr.org/newupload').to_return(status: 200, body: "ses=\"1\" src=\"1\"")
    stub_request(:any, 'http://www.webasr.org/getstatus').to_return(status: 200, body: 'is: processing')
    expect{FactoryGirl.create(:recording, :with_record)}.to raise_error(RuntimeError, 'Still processing')
  end

end