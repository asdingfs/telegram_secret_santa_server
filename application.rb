require 'sinatra'

require 'telegram/bot'
configure :development, :test do
  require 'byebug'
  require 'dotenv'
end

# require init files
require_relative 'configure'
require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
