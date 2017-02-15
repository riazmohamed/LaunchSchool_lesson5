# twenty_one_bonus_feature.rb

=begin
  ex1
    Key to watch out for when using a local variable to cache expensive calculations?

    Answer
    a. To check the scope of the local variable.
    b. the local variables that are assigned outside of a method can be accessed from within a method and not vice versa.

  ex2
    Why is the last call to play_again? A little different to the previous two?

    Answer
    this is because in the first two instance we take the return value of the play_again? method and if it returns "true" then we skip the next step.
    Thereby restarting the main loop again and plaing the game.
    Where as in the last instance we are setting a condition where the main loop will break if the return value of the method is true else will carry on looping unless the value of true is returned.
    In both instances the main loop will break and will exit the main loop if the return value of the play_again? method returns false.
=end
