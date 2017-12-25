# GLOBAL variables
$TOKEN = ENV["TELEGRAM_BOT_TOKEN"]

# configurations for development and tests
configure :development, :test do
  Dotenv.load
end

