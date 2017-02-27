# tic_tac_toe_revised.rb

require 'pry'

=begin

pseudo code
1. Display the board
2. as the user to mark a square
3. ask the computer to makrk the board
4. Display the updated board.
5. if winner , Display winner
6. if board full, display tie
7. if neither winner nor board full go to # 2
8. Ask if play again
9. if yes go to # 1
10. goodbye
=end

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagonals

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system("clear")
  puts "You are a #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}"
  puts "     |     |"
  puts "-----+-----+-----"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}"
  puts "     |     |"
  puts ""
end
# rubocop:enable Metrics/AbcSize

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def joinor(brd, delimiter=', ', word='or')
  arr = empty_squares(brd)
  arr.first if arr.size == 1
   "#{arr[0..-2].join("#{delimiter}")}, #{word} #{arr.last}"
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(brd)})"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice!"
  end

  brd[square] = PLAYER_MARKER
end

def find_winning_line(brd, marker)
  WINNING_LINES.select do |line|
    brd.values_at(*line).include?(INITIAL_MARKER) && brd.values_at(*line).count(marker) == 2
  end
end

def check_winning?(brd, marker)
  result = find_winning_line(brd, marker)
  result.any? { |arr| WINNING_LINES.include?(arr) }
end

def defence!(brd, marker)
  result = ''
  find_winning_line(brd, marker).each do |arr|
    arr.each do |element|
      if brd.values_at(element) &&
         brd.values_at(element).include?(INITIAL_MARKER)
        result = element
      end
    end
  end

  result
end

def computer_places_piece!(brd)
  square = ''
  if check_winning?(brd, COMPUTER_MARKER)
    square = defence!(brd, COMPUTER_MARKER)
  elsif check_winning?(brd, PLAYER_MARKER)
    square = defence!(brd, PLAYER_MARKER)
  else
    square = empty_squares(brd).sample
  end

  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd) # TO TURN THE OUTPUT TO TRUE OR FALSE
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    # if brd[line[0]] == PLAYER_MARKER &&
    #    brd[line[1]] == PLAYER_MARKER &&
    #    brd[line[2]] == PLAYER_MARKER
    #   return "Player"
    # elsif brd[line[0]] == COMPUTER_MARKER &&
    #       brd[line[1]] == COMPUTER_MARKER &&
    #       brd[line[2]] == COMPUTER_MARKER
    #   return "Computer"
    # end

    return "Player" if brd.values_at(*line).count(PLAYER_MARKER) == 3
    return "Computer" if brd.values_at(*line).count(COMPUTER_MARKER) == 3
  end

  nil
end

def place_piece!(brd, crnt_player)
  player_places_piece!(brd) if crnt_player == "Player"
  computer_places_piece!(brd) if crnt_player == "Computer"
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

player = 0
computer = 0
current_player = ''
loop do
  board = initialize_board
  system("clear")
  prompt "Who should go first? 'P' for 'Player', 'C' for 'Computer'."
  answer = gets.chomp.downcase
  if answer.start_with?("p")
    current_player = "Player"
  elsif answer.start_with?("c")
    current_player = "Computer"
  else
    prompt "Invalid entry! Please chose 'P' or 'C'."
  end

  loop do
    display_board(board)
    place_piece!(board, current_player)
    current_player = alternate_player(current_player)
    break if someone_won?(board) || board_full?(board)
  end

  display_board(board)

  if someone_won?(board)
    prompt "#{detect_winner(board)} won!"
  else
    prompt "It's a tie!"
  end

  if detect_winner(board) == "Player"
    player += 1
  elsif detect_winner(board) == "Computer"
    computer += 1
  end

  prompt "Player score: #{player}, Computer score: #{computer}"

  if player == 5
    prompt "Player won the best of 5!"
    break
  elsif computer == 5
    prompt "Computer won the best of 5!"
    break
  end

  prompt "Do you want to play again?"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for playing tic tac toe. Good bye!"
