require 'rails_helper'

describe 'Transcriber' do

  specify 'The transcriber upload job should be queued when a recording is uploaded', delayed_job: true do
      expect(Delayed::Job.count).to eq(0)
      FactoryGirl.create(:recording, :with_record)
      expect(Delayed::Job.count).to eq(1)
  end

  specify 'Transcription job downloads the transcription file and attaches it to the model' do
    # First job uploads
    # Second job polls and downloads the file once complete
    recording = FactoryGirl.create(:recording, :with_record)
    expect(recording.transcript).to_not be(nil?)
  end

end