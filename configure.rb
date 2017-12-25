# configurations for development and tests
configure :development, :test do
  Dotenv.load
  require 'sinatra/reloader'
  register Sinatra::Reloader
end

# GLOBAL variables
configure do
  set :telegram_bot_token, ENV["TELEGRAM_BOT_TOKEN"]
  set :root, File.dirname(__FILE__)
end

# application-wide configurations
configure do
  # logging
  file = File.new(File.join(settings.root, 'log/application.log'), 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

