get '/' do
  "Hello World!"
end

namespace "/api/:token", provides: :json do
  before do
    raise Sinatra::NotFound unless
      params[:token] == settings.telegram_bot_token
  end
  get '/' do
    "Hello! I'm GiftExchangeBot!"
  end
  post '/update'  do
    params.each do |key, value|
      puts "Received params key: #{key}, value: #{value}"
    end
    halt 204
  end
end
