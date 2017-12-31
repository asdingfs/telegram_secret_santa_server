# pre-env for development and tests
configure :development, :test do
  Dotenv.load
  require 'sinatra/reloader'
  register Sinatra::Reloader
  # logging
  set :logger, Logger.new(File.join(settings.root, 'log/bot.log'))
  file = File.new(File.join(settings.root, 'log/application.log'), 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

# pre-env for production
configure :production do
  $stdout.sync = true
end

# pre-env GLOBAL variables
configure do
  set :telegram_bot_token, ENV["TELEGRAM_BOT_TOKEN"]
  set :telegram_bot_server, "https://telegram-gift-exchange-bot.herokuapp.com"
  set :bot, Telegram::Bot::Client.new(settings.telegram_bot_token)
  set :root, File.expand_path(File.dirname(__FILE__))
end

# post-env for production
configure :production do
  # set webhook, enable this if using webhook
  set :webhook_url, "#{settings.telegram_bot_server}/api/#{settings.telegram_bot_token}/updates"
  settings.bot.api.set_webhook(url: settings.webhook_url)
end

# require everything
['db', 'models', 'helpers', 'routes'].each do |app|
  Dir[File.join(settings.root, app, '**', '*.rb')].each { |file| require file }
end



