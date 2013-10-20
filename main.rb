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

  def determineWinner
    player_score = countCards(session[:player_hand])
    dealer_score = countCards(session[:dealer_hand])
    if player_score > 21 && dealer_score > 21
      @error = "Tie. Game over."
    elsif player_score > 21
      @error = "Dealer won. Game over."
    elsif dealer_score > 21
      @success = "You won! Game over."
    elsif player_score == dealer_score
      @error = "Tie. Game over. Bets returned."
    else
      player_score > dealer_score ? (@success = "You won!") : (@error = "You lost..")
    end
    erb :game
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
  session[:bet] = 500
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Please enter a name"
    halt erb(:new_player)
  end
  session[:player_name]=params[:player_name]
  erb :bet
  #redirect '/initialize'
end

post '/bet' do
  session[:bet] -= params[:player_bet].to_f
  puts session[:bet]
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

  @display_hit_or_stay = true
  erb :game
end

get '/game' do
  erb :game
end

post '/hit' do
  session[:player_hand]<<session[:deck].pop

  if countCards(session[:player_hand]) == 21
    @success = "Blackjack!"
    @display_hit_dealer = true if countCards(session[:dealer_hand]) < 16
  elsif countCards(session[:player_hand]) < 21
    @display_hit_or_stay = true
  else
    # dealer's turn if under 17
    @display_hit_dealer = true if countCards(session[:dealer_hand]) < 16
  end

  erb :game
end

post '/stay' do
  session[:player_turn] = false
  redirect '/game/over' if countCards(session[:dealer_hand]) > 16
  @display_hit_dealer = true
  erb :game
end

post '/hit_dealer' do
  session[:dealer_hand]<<session[:deck].pop
  redirect '/game/over' if countCards(session[:dealer_hand]) > 16
  @display_hit_dealer = true
  erb :game
end

get '/game/over' do
  determineWinner
  erb :game
end





