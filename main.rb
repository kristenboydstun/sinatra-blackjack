require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  erb :whatsyourname
end


