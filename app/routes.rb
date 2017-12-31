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
      Update.old.destroy_all # will clean old registered updates, since they are also removed by telegram
      handler = Updates::Handler.handle(request)
      puts "Successfully handled Update object: #{handler.update.inspect}"
    rescue JSON::ParserError
      status 400
      body render_error_body(400, "Update object is invalid")
    rescue ActiveRecord::RecordInvalid => e
      status 422
      body render_error_body(422, "Error saving objects, due to: #{e.inspect}")
    end
  end
end
