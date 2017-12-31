require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'telegram/bot'

configure :development, :test do
  require 'byebug'
  require 'dotenv'
end

# require init files
require_relative 'config/init'
