class MediumUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage :file
  after :remove, :delete_empty_dirs

  # Override the directory where uploaded files will be stored.
  def store_dir
    "#{Rails.root}/uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Cleanup, remove empty folders
  def delete_empty_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path)

    path = ::File.expand_path(base_store_dir, root)
    Dir.delete(path)
  rescue
    true
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
