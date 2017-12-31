require 'sinatra'
require 'sinatra/contrib'
require 'telegram/bot'

configure :development, :test do
  require 'byebug'
  require 'dotenv'
end

# initialize
set :root, File.expand_path(File.dirname(__FILE__))
require_relative 'config/init'

# require after loading environment variables
require 'sinatra/activerecord'

# require everything else
['app', 'config/routes'].each do |app|
  Dir[File.join(settings.root, app, '**', '*.rb')].each { |file| require file }
end
