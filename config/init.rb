configure :development do
  Dotenv.load
  require 'sinatra/reloader'
  register Sinatra::Reloader
  # logging
  set :logger, Logger.new(File.join(settings.root, 'log/bot.log'))
  file = File.new(File.join(settings.root, 'log/application.log'), 'a+')
  file.sync = true
  use Rack::CommonLogger, file
end

configure do # settings vars
  set :db_uri, URI.parse(ENV['DATABASE_URL'])
  # bot vars
  set :telegram_bot_token, ENV["TELEGRAM_BOT_TOKEN"]
  set :telegram_bot_uri_path, ENV["TELEGRAM_BOT_URI_PATH"]
  set :telegram_bot_server, "https://telegram-gift-exchange-bot.herokuapp.com"
  set :bot, Telegram::Bot::Client.new(settings.telegram_bot_token)
end

configure :production do
  $stdout.sync = true
  # set webhook, enable this if using webhook
  set :webhook_url, "#{settings.telegram_bot_server}/api/#{settings.telegram_bot_token}#{settings.telegram_bot_uri_path}"
  settings.bot.api.set_webhook(url: settings.webhook_url)
end
