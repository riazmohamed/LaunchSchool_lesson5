# twenty_one.rb

=begin
  High level pseudo code
  1. Initialize Deck
  2. Deal cards to Player and Dealer
  3. Player turn: hit or stay
    - repeat untill bust or stay
  4. If Player bust, Dealer wins.
  5. Dealer turn: hit or stay
    - repeat untill total >= 17
  6. If Dealer bust, Player wins.
  7. Compare cards and declare winner.
=end

# data structure for a "deck", "Player" and "Dealer"

# Deck of 52 cards containing 13 hearts, spades, diamond and clubs each.
deck = [['H', '2'], ['H', '3'], ['H', '4'], ['H', '5'], ['H', '6']] +
       [['H', '7'], ['H', '8'], ['H', '9'], ['H', '10'], ['H', 'J']] +
       [['H', 'Q'], ['H', 'K'], ['H', 'A']] +
       [['D', '2'], ['D', '3'], ['D', '4'], ['D', '5'], ['D', '6']] +
       [['D', '7'], ['D', '8'], ['D', '9'], ['D', '10'], ['D', 'J']] +
       [['D', 'Q'], ['D', 'K'], ['D', 'A']] +
       [['C', '2'], ['C', '3'], ['C', '4'], ['C', '5'], ['C', '6']] +
       [['C', '7'], ['C', '8'], ['C', '9'], ['C', '10'], ['C', 'J']] +
       [['C', 'Q'], ['C', 'K'], ['C', 'A']] +
       [['S', '2'], ['S', '3'], ['S', '4'], ['S', '5'], ['S', '6']] +
       [['S', '7'], ['S', '8'], ['S', '9'], ['S', '10'], ['S', 'J']] +
       [['S', 'Q'], ['S', 'K'], ['S', 'A']]

def prompt(msg)
  puts "=> #{msg}"
end

def deal_card(cards, deck)
  cards << deck.sample
end

def total_cards(cards)
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += 11 if value == 'A'
    sum += 10 if value.to_i == 0
    sum += value.to_i
  end

  # correct for Aces
  values.select { |value| value == 'A' }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

def busted?(cards)
  total_cards(cards) > 21
end

def highest_sum(player_cards, dealer_cards)
  player_sum = total_cards(player_cards)
  dealer_sum = total_cards(dealer_cards)
  if player_sum > dealer_sum
    prompt "Player Wins!"
    prompt "Player Total: #{player_sum}."
    prompt "Dealer Total: #{dealer_sum}."
  elsif dealer_sum > player_sum
    prompt "Dealer Wins!"
    prompt "Player Total: #{player_sum}."
    prompt "Dealer Total: #{dealer_sum}."
  else
    prompt "It's a tie!"
    prompt "Player total: #{player_sum}."
    prompt "Dealer total: #{dealer_sum}."
  end
end

loop do
  player_cards = []
  dealer_cards = []
  deal_card(player_cards, deck)
  deal_card(dealer_cards, deck)
  prompt "Player's first card: #{player_cards}"
  prompt "Dealer's first card: #{dealer_cards}"

  answer = nil

  loop do
    deal_card(player_cards, deck)
    deal_card(dealer_cards, deck)
    break if busted?(dealer_cards) || busted?(player_cards)
    prompt "You both have picked up a card each"
    prompt "Player's cards: #{player_cards}"
    prompt "What would you like to do?"
    prompt "hit or stay?"
    answer = gets.chomp
    break if answer == 'stay'
  end

  if busted?(player_cards)
    prompt "Dealer Wins! Player Busted!"
    prompt "Player Total: #{total_cards(player_cards)}."
    prompt "Dealer Total: #{total_cards(dealer_cards)}."
  elsif busted?(dealer_cards)
    prompt "Player Wins! Dealer Busted!"
    prompt "Player Total: #{total_cards(player_cards)}."
    prompt "Dealer Total: #{total_cards(dealer_cards)}."
  else
    prompt "You chose to stay!" # if player didn't bust, must have stayed
    highest_sum(player_cards, dealer_cards)
  end

  prompt "Do you want to play again? (Y / N)"
  user_input = gets.chomp.downcase
  break unless user_input.start_with?('y')
end

prompt "Thank you for playing twenty one!. Goodbye!"
