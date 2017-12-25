require 'sinatra'

configure :development, :test do
  require 'byebug'
  require 'dotenv'
  Dotenv.load
end

# require init files
require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
