# tictactoe.rb

require 'pry'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                [[1, 5, 9], [3, 5, 7]]              # diagonals

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize.
def display_board(brd)
  system "clear"
  puts "You're a #{PLAYER_MARKER}, computer is a #{COMPUTER_MARKER}"
  puts " "
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
  puts " "
end
# rubocop:enable Metrics/AbcSize.

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

# improved join (exercise 1)
def joinor(arr, seperator = ', ', last_seperator = 'or')
  result = []
  result = arr.first if arr.length == 1
  if arr.length > 1
    result = arr[0..-2].join(seperator) + " #{last_seperator} #{arr.last}"
  end
  result
end

# choose if computer or player should go first
def first_player(brd)
  display_board(brd)
  prompt "Who do you want to go first?"
  prompt "Choose 'p' for Player"
  prompt "Choose 'c' for Computer"
  choose = ''
  current_player = ''
  loop do
    choose = gets.chomp
    if choose == 'p'
      current_player = "Player"
      break
    elsif choose == 'c'
      current_player = "Computer"
      break
    else
      prompt "Invalid Selection! Please select 'p' or 'c'."
    end
  end
  current_player
end

def places_piece!(current_player, brd)
  if current_player == "Player"
    player_places_piece!(brd)
  else
    computer_places_piece!(brd)
  end
end

def alternate_player(crnt_player)
  answer = case crnt_player
  when "Player"
    "Computer"
  when "Computer"
    "Player"
  end

  answer
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry that is not a valid selection"
  end

  brd[square] = PLAYER_MARKER
end

def find_at_risk_square(line, board, marker)
  if board.values_at(*line).count(marker) == 2
    board.select { |k, v| line.include?(k) && v == INITIAL_MARKER }.keys.first
  else
    nil
  end
end

def computer_offense(brd)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, COMPUTER_MARKER)
    break if square
  end
end

def computer_defense(brd)
  WINNING_LINES.each do |line|
    square = find_at_risk_square(line, brd, PLAYER_MARKER)
    break if square
  end
end

def computer_places_piece!(brd)
  square = nil
  computer_offense(brd) # offense first
  computer_defense(brd) # defense second
  square = 5 if !square && empty_squares(brd).include?(5) # Pick square 5 (the center square)
  square = empty_squares(brd).sample unless square # Just pick a square
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd) # here the !! will turn the output to a boolean
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    return 'Player' if brd.values_at(*line).count(PLAYER_MARKER) == 3
    return 'Computer' if brd.values_at(*line).count(COMPUTER_MARKER) == 3
  end
  nil
end

player_score = 0
computer_score = 0
loop do
  board = initialize_board
  current_player = first_player(board)

  loop do
    display_board(board)
    places_piece!(current_player, board)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)
  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  # keep score
  if detect_winner(board) == "Player"
    player_score += 1
  elsif detect_winner(board) == "Computer"
    computer_score += 1
  end

  puts "Player score = #{player_score}, Computer score: #{computer_score}"

  if player_score == 5 || computer_score == 5
    puts "#{detect_winner(board)} won the league"
    break
  end

  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt "Thanks for playing Tic Tac Toe, Goodbye!"
