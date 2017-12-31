require_relative 'helpers'

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
    begin
      puts "Received Update object: #{UpdateHandler.handle!(request).inspect}"
    rescue JSON::ParserError
      status 400
      body render_error_body(400, "Update object is invalid")
    end
  end
end
