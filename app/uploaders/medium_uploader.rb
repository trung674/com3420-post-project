class MediumUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file
  before :store, :remember_cache_id
  after :store, :delete_tmp_dir

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # store! nil's the cache_id after it finishes so we need to remember it for deletion
  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end

  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(root, cache_dir, @cache_id_was))
    end
  end

  def extension_white_list
    case model.class.name
      when 'Document'
        %w(pdf)
      when 'Image'
        %w{jpeg jpg gif bmp png}
      when 'Text'
        %w{txt}
      when 'Recording'
        # Recording allows the transcript, audio is handled by recording_uploader.rb
        %w{pdf}
    end
  end

end
