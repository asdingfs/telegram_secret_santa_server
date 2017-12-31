require 'sinatra'
require 'sinatra/contrib'
require 'telegram/bot'

configure :development, :test do
  require 'byebug'
  require 'dotenv'
end

# initialize
require_relative 'config/init'

# require after loading environment variables
require 'sinatra/activerecord'
