Airbrake.configure do |config|
  config.api_key = 'ab841fcc62027bace6eca9606f4714b8'
  config.host = 'errbit.software-hut.org.uk'
  config.port = 443
  config.secure = config.port == 443
end
