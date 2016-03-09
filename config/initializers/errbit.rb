Airbrake.configure do |config|
  # our hacky version - gitignore is not working for me :(
  # config.project_id = 'project'
  # config.project_key = 'ab841fcc62027bace6eca9606f4714b8'
  # config.host = 'errbit.software-hut.org.uk'
  # config.post = 443
  # config.secure = config.post == 443


  # proper version
  config.api_key = 'ab841fcc62027bace6eca9606f4714b8'
  config.host = 'errbit.software-hut.org.uk'
  config.port = 443
  config.secure = config.port == 443
end
