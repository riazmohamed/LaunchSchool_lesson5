# test.rb

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    sum += 1 if value == "A" && sum + 11 > 21
    sum += 11 if value == "A" && sum + 11 < 21
    sum += 10 if value.to_i == 0 # J, Q, K
    sum += value.to_i
  end


  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > 21
  end

  sum
end

cards = [["H", "2"], ["S", "2"], ["D", "9"], ["H", "3"], ["D", "A"]]

p total(cards)

# values.each do |value|
#   if value == "A" && sum + 11 > 21
#     sum += 1
#   elsif value == "A"
#     sum += 11
#   elsif value.to_i == 0 # J, Q, K
#     sum += 10
#   else
#     sum += value.to_i
#   end
# end
