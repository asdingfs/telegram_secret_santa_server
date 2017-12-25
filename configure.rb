# configurations for development and tests
configure :development, :test do
  Dotenv.load
  require 'sinatra/reloader'
  register Sinatra::Reloader
end

# GLOBAL variables
configure do
  set :telegram_bot_token, ENV["TELEGRAM_BOT_TOKEN"]
  set :telegram_bot_server, "https://telegram-gift-exchange-bot.herokuapp.com"
  set :bot, Telegram::Bot::Client.new(settings.telegram_bot_token)
  set :logger, Logger.new(File.join(settings.root, 'log/bot.log'))
  set :root, File.dirname(__FILE__)
end

# application-wide configurations
configure do
  # logging
  file = File.new(File.join(settings.root, 'log/application.log'), 'a+')
  file.sync = true
  use Rack::CommonLogger, file
  # setup webhook
  settings.bot.api.set_webhook(url: "#{settings.telegram_bot_server}/api/#{settings.telegram_bot_token}/updates")
end

