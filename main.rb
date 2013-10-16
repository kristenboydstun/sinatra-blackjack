require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def countCards cards
    valueDictionary = {"ace" => 11, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "ten" => 10, "jack" => 10, "queen" => 10, "king" => 10}
    total = 0
    aces = 0
    
    names = cards.map { |name, suit| name }

    names.each do |name| 
      total += valueDictionary["#{name}"]
      aces = aces + 1 if name == "ace"
    end
    while total > 21 && aces > 0
      total = total - 10
      aces = aces - 1
    end
    total
  end
end


get '/' do
  if session[:player_name]
    # do something else
    redirect '/initialize'
  else
    redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:player_name]=params[:player_name]
  redirect '/initialize'
end

get '/initialize' do
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

  redirect '/game'
end

get '/game' do
  erb :game
end

post '/hit' do
  session[:player_hand]<<session[:deck].pop
  if countCards(session[:player_hand]) < 21
    redirect '/game'
  else
    redirect '/dealer_turn'
  end
  #session[:player_hand] < 21 ? redirect '/game' : redirect '/stay'
end

post '/stay' do
  # deal cards for dealer
  redirect '/dealer_turn'
end

get '/dealer_turn' do
  redirect '/game_over'
end

get '/game_over' do
  # deal cards for dealer
  "Game over"
end