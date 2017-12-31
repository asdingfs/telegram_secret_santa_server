require 'sinatra'
require 'sinatra/contrib'
require 'sinatra/sequel'
require 'telegram/bot'

configure :development, :test do
  require 'byebug'
  require 'dotenv'
end

# require init files
require_relative 'configure'
