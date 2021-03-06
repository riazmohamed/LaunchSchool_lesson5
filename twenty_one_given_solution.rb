# twenty_one_given_solution.rb

SUITS = ['H', 'D', 'S', 'C']
VALUES = %w(2 3 4 5 6 7 8 9 10 J Q K A)
BREAK_POINT = 21
HIT_POINT = 17

def prompt(msg)
  puts "=> #{msg}"
end

def clear_screen
  system('clear') || system('cls')
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += 1 if value == "A" && sum + 11 > BREAK_POINT
    sum += 11 if value == "A" && sum + 11 < BREAK_POINT
    sum += 10 if value.to_i == 0 # J, Q, K
    sum += value.to_i
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > BREAK_POINT
  end

  sum
end

def busted?(cards)
  total(cards) > BREAK_POINT
end

# :tie, :dealer, :player, :dealer_busted, :player_busted
def detect_result(dealer_cards, player_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > BREAK_POINT
    :player_busted
  elsif dealer_total > BREAK_POINT
    :dealer_busted
  elsif dealer_total < player_total
    :player
  elsif dealer_total > player_total
    :dealer
  else
    :tie
  end
end

def display_result(dealer_cards, player_cards)
  result = detect_result(dealer_cards, player_cards)

  case result
  when :player_busted
    prompt "You busted!, Dealer wins!"
  when :dealer_busted
    prompt "Dealer busted! You win!"
  when :player
    prompt "You win!"
  when :dealer
    prompt "Dealer wins!"
  when :tie
    prompt "It's a tie!"
  end
end

def play_again?
  puts "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

def display_hands(dealer_cards, player_cards)
  puts "==============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{total(dealer_cards)}"
  prompt "Player has #{player_cards}, for a total of: #{total(player_cards)}"
  puts "==============="
end

player_score = 0
dealer_score = 0
loop do
  clear_screen
  prompt "Welcome to Twenty-One!"

  # initialize vars
  deck = initialize_deck
  player_cards = []
  dealer_cards = []

  # initial deal
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  card_a = player_cards[0]
  card_b = player_cards[1]
  total_cards = total(player_cards)
  prompt "Dealer has #{dealer_cards[0]} and ?"
  prompt "You have: #{card_a} and #{card_b}, for a #{total_cards}."

  # player_turn
  loop do
    player_turn = nil
    loop do
      prompt "Would you like to (h)it or (s)tay?"
      player_turn = gets.chomp.downcase
      break if ['h', 's'].include?(player_turn)
      prompt "Sorry, must enter 'h' or 's'."
    end

    if player_turn == 'h'
      player_cards << deck.pop
      clear_screen
      prompt "You chose to hit!"
      prompt "Your cards are now: #{player_cards}"
      prompt "Your total is now: #{total(player_cards)}"
    end

    break if player_turn == 's' || busted?(player_cards)
  end

  if busted?(player_cards)
    display_hands(dealer_cards, player_cards)
    display_result(dealer_cards, player_cards)
    result = detect_result(dealer_cards, player_cards)
    if result == :player_busted || result == :dealer
      dealer_score += 1
    end

    prompt "Your score: #{player_score}, Dealer score: #{dealer_score}"
    break if dealer_score >= 5
    play_again? ? next : break
  else
    clear_screen
    prompt "You stayed at #{total(player_cards)}"
  end

  # dealer_turn
  prompt "Dealer turn..."

  loop do
    break if busted?(dealer_cards) || total(dealer_cards) >= HIT_POINT

    prompt "Dealer hits!"
    dealer_cards << deck.pop
    prompt "Dealer's card are now: #{dealer_cards}"
  end

  if busted?(dealer_cards)
    display_hands(dealer_cards, player_cards)
    display_result(dealer_cards, player_cards)

    result = detect_result(dealer_cards, player_cards)
    if result == :dealer_busted || result == :player
      player_score += 1
    end

    prompt "Your score: #{player_score}, Dealer score: #{dealer_score}"
    break if player_score >= 5
    play_again? ? next : break
  else
    prompt "Dealer stays at #{total(dealer_cards)}"
  end

  # both player and dealer stays - compare cards!
  display_hands(dealer_cards, player_cards)

  display_result(dealer_cards, player_cards)

  result = detect_result(dealer_cards, player_cards)
  if result == :player_busted || result == :dealer
    dealer_score += 1
  elsif result == :dealer_busted || result == :player
    player_score += 1
  end
  prompt "Your score: #{player_score}, Dealer score: #{dealer_score}"
  break if player_score >= 5 || dealer_score >= 5
  break unless play_again?
end

prompt "Player won the best of 5!" if player_score >= 5
prompt "Dealer won the best of 5!" if dealer_score >= 5
prompt "Thank you for playing Twenty One! Good Bye!"
