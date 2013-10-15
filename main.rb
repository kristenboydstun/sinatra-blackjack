require 'rubygems'
require 'sinatra'

set :sessions, true

get '/' do
  if session[:player_name]
    # do something else
    redirect '/game'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:player_name]=params[:player_name]
  redirect '/game'
end

get '/game' do
  # set up initial vars
  suits = ["hearts","spades","diamonds","clubs"]
  types = ["ace", "two", "three", "four", "five", "six", "seven",
              "eight", "nine", "ten", "jack", "queen", "king"]

  session[:deck] = types.product(suits).shuffle!
  session[:dealer_hand]=[]
  session[:player_hand]=[]
  session[:dealer_hand]<<session[:deck].pop
  session[:dealer_hand]<<session[:deck].pop
  session[:player_hand]<<session[:deck].pop
  session[:player_hand]<<session[:deck].pop

  erb :game
end
