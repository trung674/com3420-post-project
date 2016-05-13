namespace :tmp_uploads do
  desc "Delete tmp files"
  task :clean => :environment do
    CarrierWave.clean_cached_files!
  end
end