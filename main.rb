require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  if session[:player_name]
    # do something
  else
    redirect '/new_game'
  end
end

get '/new_game' do
  erb :new_game
end


post '/start_game' do
  session[:player_name]=params[:player_name]
  @player_name = session[:player_name]
  erb :start_game
end