# twentyone_revision.rb

require 'pry'

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  cards_list = %w(2 3 4 5 6 7 8 9 10 A K Q J)
  cards_type = %w(H S D C)

  cards_type.product(cards_list).shuffle
end

def inital_deal_cards!(crd, card_arr)
  counter = 1
  loop do
    break if counter > 2
    card_arr << crd.pop
    counter += 1
  end

  card_arr
end

def deal!(crd, card_arr)
  card_arr << crd.pop
end

def sum?(card_arr)
  sum = 0

  card_arr.each do |card|
    result = if card[1] == "A"
               11
             elsif card[1] != "A" && card[1].to_i == 0
               10
             else
               card[1].to_i
             end

    sum += result

    sum -= 10 if sum > 21 && card[1] == 'A'
  end

  sum
end

def busted?(card_arr)
  sum?(card_arr) > 21
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

# game loop
player_score = 0
dealer_score = 0
cards = []
loop do
  cards = initialize_deck
  system("clear")

  # give player/dealer two cards
  player_cards = []
  dealer_cards = []
  inital_deal_cards!(cards, player_cards)
  inital_deal_cards!(cards, dealer_cards)

  # show player and dealer cards
  puts "Player: #{player_cards}"
  puts "Dealer: #{dealer_cards}"

  # player turn
  player_sum = 0
  loop do
    prompt "Do you want to 'Stay' or 'Hit'?"
    answer = gets.chomp.downcase

    deal!(cards, player_cards) if answer.start_with?('h')
    player_sum = sum?(player_cards)
    puts "Player: #{player_cards}. Total: #{player_sum}"
    break if busted?(player_cards) || answer.start_with?('s')
  end

  if busted?(player_cards)
    puts "Player Busted! Dealer Wins!"
    dealer_score += 1
    puts "Player score: #{player_score}, Dealer score: #{dealer_score}"
    play_again? ? next : break
  else
    puts "You chose to stay!"
  end

  dealer_sum = 0
  loop do
    dealer_sum = sum?(dealer_cards)
    puts "Dealer: #{dealer_cards}. Total: #{dealer_sum}"
    break if busted?(dealer_cards) || dealer_sum >= 17
    deal!(cards, dealer_cards)
  end

  if busted?(dealer_cards)
    puts "Dealer Busted! Player Wins!"
    player_score += 1
  else
    puts "Dealer stays!"
  end

  if player_sum > dealer_sum && player_sum <= 21
    puts "Player won!"
    player_score += 1
  elsif dealer_sum > player_sum && dealer_sum <= 21
    puts "Dealer won!"
    dealer_score += 1
  elsif player_sum == dealer_sum
    puts "Its a tie!"
  end

  puts "Player score: #{player_score}, Dealer score: #{dealer_score}"
  if player_score == 5
    puts "Player won the best of 5."
    break
  elsif dealer_score == 5
    puts "Dealer won the best of 5"
    break
  end

  break unless play_again?
end

prompt "Thank you for playing the Twenty One game. Good Bye!"
