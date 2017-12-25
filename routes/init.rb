get '/' do
  "Hello World!"
end

namespace "/api/:token" do
  before do
    raise Sinatra::NotFound unless
      params[:token] == settings.telegram_bot_token
  end
  get '/' do
    "Hello! I'm GiftExchangeBot!"
  end
end
