require 'rubygems'
require 'sinatra'

set :sessions, true

helpers do
  def countCards cards
    valueDictionary = {"ace" => 11, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8, "9" => 9, "10" => 10, "jack" => 10, "queen" => 10, "king" => 10}
    total = 0
    aces = 0
    
    names = cards.map { |name, suit| name }

    names.each do |name| 
      puts name
      total += valueDictionary["#{name}"]
      aces = aces + 1 if name == "ace"
    end
    while total > 21 && aces > 0
      total = total - 10
      aces = aces - 1
    end
    total
  end

  def getImage card
    "<img src='/images/cards/#{card[1]}_#{card[0]}.jpg'>"
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
  types = ["ace", "2", "3", "4", "5", "6", "7",
              "8", "9", "10", "jack", "queen", "king"]

  session[:deck] = types.product(suits).shuffle!
  session[:dealer_hand]=[]
  session[:player_hand]=[]
  session[:dealer_hand]<<session[:deck].pop
  session[:dealer_hand]<<session[:deck].pop
  session[:player_hand]<<session[:deck].pop
  session[:player_hand]<<session[:deck].pop

  getImage(session[:deck].pop)

  session[:game_over] = false
  session[:player_turn] = true
  redirect '/game'
end

get '/game' do
  erb :game
end

post '/hit' do
  session[:player_hand]<<session[:deck].pop
  session[:player_turn] = false unless countCards(session[:player_hand]) < 21
  redirect('/game')
end

post '/stay' do
  # deal cards for dealer
  session[:player_turn] = false
  redirect '/game'
end

post '/hit_dealer' do
  session[:dealer_hand]<<session[:deck].pop
  session[:game_over] = true unless countCards(session[:dealer_hand]) < 17
  redirect '/game'
end