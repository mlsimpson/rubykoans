# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.
#
# Consider adding a "help" where the probability of a scoring roll is displayed
# for each roll
#
# Abstract out the "press something to return" handler, make it more robust
#
# TODO:
# - Handle gets calls
# - Change "exit" to function that goes back to menu screen, and prints the final score

def rules
  text = <<iCUT
Each player takes a turn consisting of one or more rolls of the dice.
On the first roll of the game, a player rolls all five dice which are
scored according to the following:

  Three 1's => 1000 points
  Three 6's =>  600 points
  Three 5's =>  500 points
  Three 4's =>  400 points
  Three 3's =>  300 points
  Three 2's =>  200 points
  One   1   =>  100 points
  One   5   =>   50 points

A single die can only be counted once in each roll.  For example,
a "5" can only count as part of a triplet (contributing to the 500
points) or as a single 50 points, but not both in the same roll.

Example Scoring

   Throw       Score
   ---------   ------------------
   5 1 3 4 1   50 + 2 * 100 = 250
   1 1 1 3 1   1000 + 100 = 1100
   2 4 4 5 4   400 + 50 = 450

The dice not contributing to the score are called the non-scoring
dice.  "3" and "4" are non-scoring dice in the first example.  "3" is
a non-scoring die in the second, and "2" is a non-score die in the
final example.

After a player rolls and the score is calculated, the scoring dice are
removed and the player has the option of rolling again using only the
non-scoring dice. If all of the thrown dice are scoring, then the
player may roll all 5 dice in the next roll.

The player may continue to roll as long as each roll scores points. If
a roll has zero points, then the player loses not only their turn, but
also accumulated score for that turn. If a player decides to stop
rolling before rolling a zero-point roll, then the accumulated points
for the turn is added to his total score.
iCUT

  text2 = <<iCUT2
Before a player is allowed to accumulate points, they must get at
least 300 points in a single turn. Once they have achieved 300 points
in a single turn, the points earned in that turn and each following
turn will be counted toward their total score.
iCUT2

text3 = <<iCUT3
Once a player reaches 3000 (or more) points, the game enters the final
round where each of the other players gets one more turn. The winner
is the player with the highest score after the final round.
iCUT3

    system("clear")
    puts "Playing Greed\n".console_dark_blue
    puts text
    print "\nPress Return to continue reading...".console_red
    continue = gets.to_s
    system("clear")
    puts "Getting \"In The Game\"\n".console_dark_blue
    puts text2
    puts "\nEnd Game\n".console_dark_blue
    puts text3
    print "\nPress Return to return to the menu screen.".console_red
    continue = gets.to_s
end

def menu_screen
  while true
    system("clear")

    game = Game.new

    puts "Greed is a dice game played among 2 or more players,".console_blue
    puts "using 5 six-sided dice.\n".console_blue

    puts "Menu:".console_yellow
    puts "1.".console_purple + "  Rules\n"
    puts "2.".console_purple + "  Start Game\n"
    puts "3.".console_purple + "  Exit Game\n\n"

    print "Select option:  "

    menuselect = gets.to_i

    if menuselect == 1
      rules
    elsif menuselect == 2
      game.addplayers
      # while game.active
      # TODO:  While no player is over 3000
        # 2:  Display Header
        game.printheader
        # Player rolls.
        game.playerarray[1].playerroll(5)
        game.playerarray[1].printscore
        # Player is asked to roll again.
        # - unless the roll is zero score
        # 3:  Player rolls first with 5 dice
        # 4:  Display current roll score
        #   - Display Header and Roll score.  Header is in Game, Roll Score is in Player.
        # 5:  If zero, next player
        # 6:  Ask to roll again with new dice
        #   - If all dice score, roll with 5 dice.
        # 7:  Display current roll score
        # 8:  Check if player > 3000
        
        # for each roll, display the header and the current roll score.
        # game.play

      # end
    elsif menuselect == 3
      # Final Tally:
      # - if @playerarray is empty, simply display the line below
      game.gameover
    else
      puts "Invalid option.  Please choose 1 - 3.\n"
      sleep(1)
    end
  end
end

# NOTE:  This is marginally superfluous; one can use Color.colorname(stuff to print out)
class String
  def console_red;          colorize(self, "\e[1m\e[31m");  end
  def console_dark_red;     colorize(self, "\e[31m");       end
  def console_green;        colorize(self, "\e[1m\e[32m");  end
  def console_dark_green;   colorize(self, "\e[32m");       end
  def console_yellow;       colorize(self, "\e[1m\e[33m");  end
  def console_dark_yellow;  colorize(self, "\e[33m");       end
  def console_blue;         colorize(self, "\e[1m\e[34m");  end
  def console_dark_blue;    colorize(self, "\e[34m");       end
  def console_dark_blue_underline;    colorize(self, "\e[4;34m");       end
  def console_purple;       colorize(self, "\e[1m\e[35m");  end

  def console_def;          colorize(self, "\e[1m");  end
  def console_bold;         colorize(self, "\e[1m");  end
  def console_blink;        colorize(self, "\e[5m");  end

  def colorize(text, color_code)  "#{color_code}#{text}\e[0m" end
end

class DiceSet
  attr_reader :values

  def roll(x)
    @values = (1..x).map{ rand(6) + 1 }
  end

  def currentscore(dice)
    setpoints=[0,1000,200,300,400,500,600]
    piecepoints=[0,100,0,0,0,50,0]
    (1..6).map{|i|
      num=dice.select{|n| n==i}.size
      num/3*setpoints[i]+num%3*piecepoints[i]
    }.inject(0){|a,b| a+b}
  end

end

class Player
  attr_accessor :score
  attr_accessor :name
  attr_accessor :keeprolling

  def initialize(name)
    @score = 0
    @name = name
  end

  def playerroll(numdice)
    dice = DiceSet.new
    dice.roll(numdice)
    dice.values
  end

  def over3000?
      if @score >= 3000
        return true
      else
        return false
      end
  end

  def currentscore(dice)
    setpoints=[0,1000,200,300,400,500,600]
    piecepoints=[0,100,0,0,0,50,0]
    (1..6).map{|i|
      num=dice.select{|n| n==i}.size
      num/3*setpoints[i]+num%3*piecepoints[i]
    }.inject(0){|a,b| a+b}
  end

  def rollagain # If Return is pressed alone, returns "Y" as the default
    defaultArray = ["Y"]
    print "\nKeep rolling? [yn] or Q to quit.  (Default = y)  ".console_red.chomp
    defaultArray << gets.to_s.chomp.upcase
    defaultArray[1].empty? ? defaultArray[0] : defaultArray[1] # Otherwise, return entered value.
  end

  def printscore(p, r, u, score, accumulatedscore)
    puts "#{p.name}'s turn.".console_dark_blue_underline + "\n\n" # Print player name
    print "Dice values:  [#{r.join("] [")}]\n" # Print dice values
    print "Roll Score:  #{score}\n" # Print current roll score
    puts "Unscored dice:  " + "[#{u.join("] [")}]" # Print unscored dice
    puts "\n#{p.name}'s score so far:  #{accumulatedscore}\n" # Print player's score so far
    x = gets
  end

  def play
    # Set initial values per round
    #
    # For final round, do this for all but the last player, then
    # exit & print scores.
    numdice = 5
    accumulatedscore = 0
    @keeprolling = "Y"
    while @keeprolling == "Y"
      if @final == true
        if @playerarray[-1].name == @name
          puts @name
          # exit
          # gameover
        end
      end
      roll = playerroll(numdice)

      rollscore = currentscore(roll)
      accumulatedscore += rollscore

      unscored = roll.dup

      unscored = unscored.each{|n|
        3.times{unscored.delete_at(unscored.index(n))} if unscored.count(n) >= 3
      }.reject{|n|
        n == 1 || n == 5
      }

      printscore(self, roll, unscored, rollscore, accumulatedscore)

      newroll = (unscored.empty? ? true : false)

      if newroll
        print "\n#{@name} gets a new 5 dice roll!\n".console_purple
      end

      if rollscore == 0 # A dice score of 0 means the player gets 0 points, and this round is over for that player
        puts "\n#{@name} gets no points this round!\n"
        @score += 0
        @keeprolling = "N"
        # nextplayer(player)
      else
        ask_to_roll = true
        while ask_to_roll
          @keeprolling = rollagain
          if @keeprolling == "Q"
            ask_to_roll = false
            gameover
            # TODO:
            # - Show final score
            # - Return to menu screen
          elsif @keeprolling == "Y"
            numdice = (newroll ? 5 : unscored.size)
            ask_to_roll = false
          elsif @keeprolling == "N"
            if (@score + accumulatedscore) >= 300 # More compact to test this way
              # @score = 3000
              if over3000? and @final == false
                @final = true
                # finalround(player)
              else
                print "\n#{@name}'s total score for this round is:  " + accumulatedscore.to_s + "\n"
                @score += accumulatedscore
              end
            else # If the player has not yet reached 300, they get NOTHING!
              print "\n#{@name} has not yet reached 300.  Score is 0.\n"
            end
            ask_to_roll = false
            # nextplayer(player)
          else
            print "Invalid entry.  Choose one:  y/n/q\n"
            sleep(0.65)
            printscore(self, roll, unscored, rollscore, accumulatedscore)
          end
        end
      end
    end
  end
end

class Game

  attr_reader :active
  attr_accessor :playerarray
  attr_accessor :numplayers

  def initialize
    @numplayers = 0
    @roundnumber = 1
    @playerarray = Array.new
    @final = false
    @active = true
  end

  def askforplayers
    system("clear")
    print "How many players (2 - 10)?  "
    @numplayers = gets.to_i
    puts "\n"
  end

  def addplayers
    invalid_number = true
    while invalid_number
      askforplayers
      if @numplayers < 2 or @numplayers > 10
        puts "Invalid number of players.  Please select 2 - 10.\n"
        sleep(0.65)
      else
        i = 0
        while i < @numplayers
          print "Player #{i + 1} name:  "
          playername = gets.chomp
          if playername.empty?
            print "Don't enter a blank player name!\n\n"
          elsif @playerarray.any? {|p|
            p.name == playername
            }
            print "\nEnter a unique player name!\n\n"
          else
            @playerarray << Player.new(playername)
            i += 1
          end
        end
        invalid_number = false
      end
    end
  end

  def currentscore(dice)
    setpoints=[0,1000,200,300,400,500,600]
    piecepoints=[0,100,0,0,0,50,0]
    (1..6).map{|i|
      num=dice.select{|n| n==i}.size
      num/3*setpoints[i]+num%3*piecepoints[i]
    }.inject(0){|a,b| a+b}
  end

#   def rollagain # If Return is pressed alone, returns "Y" as the default
#     defaultArray = ["Y"]
#     print "\nKeep rolling? [yn] or Q to quit.  (Default = y)  ".console_red.chomp
#     defaultArray << gets.to_s.chomp.upcase
#     defaultArray[1].empty? ? defaultArray[0] : defaultArray[1] # Otherwise, return entered value.
#   end

#   def printscore(p, r, u, score, accumulatedscore)
  def printheader
    system("clear")
    if @final
      print "FINAL ROUND!  FIGHT!\n".console_dark_green
    else
      print "Round #{@roundnumber}.  FIGHT!\n".console_dark_green
    end
    barwidth = 5 + @playerarray[-1].name.size + 17
    print ('_'*barwidth).console_dark_blue + "\n\n"
    @playerarray.each { |player|
      print "#{player.name}'s total score:  #{player.score}\n"
    }
    print ('_'*barwidth).console_dark_blue + "\n"
    puts "\n"

#     puts "#{p.name}'s turn.".console_dark_blue_underline + "\n\n" # Print player name
#     print "Dice values:  [#{r.join("] [")}]\n" # Print dice values
#     print "Roll Score:  #{score}\n" # Print current roll score
#     puts "Unscored dice:  " + "[#{u.join("] [")}]" # Print unscored dice
#     puts "\n#{p.name}'s score so far:  #{accumulatedscore}\n" # Print player's score so far
  end

  def nextplayer(player)
    unless @playerarray[-1].name == player.name
      print "\nPress Return for next player, or Q to quit.  ".console_yellow
      go = gets.chomp
      if go.upcase == "Q"
        gameover
      end
    end
  end

  def finalround(player)
    system("clear")
    text2 = <<CUT2
___________.__              .__    __________                         .___
\\_   _____/|__| ____ _____  |  |   \\______   \\ ____  __ __  ____    __| _/
 |    __)  |  |/    \\\\__  \\ |  |    |       _//  _ \\|  |  \\/    \\  / __ |
 |     \\   |  |   |  \\/ __ \\|  |__  |    |   (  <_> )  |  /   |  \\/ /_/ |
 \\___  /   |__|___|  (____  /____/  |____|_  /\\____/|____/|___|  /\\____ |
     \\/            \\/     \\/               \\/                  \\/      \\/
__________________________________________________________________________


CUT2

    print text2.console_blue

    # This preserves the play order, making the over3000 player last
    @playerarray.delete(player)
    @playerarray.push(player)

    print "#{player.name} has eclipsed 3000 points!\n\n".console_yellow
    print "Each of the other players gets one more turn.\n"
    print "The winner is the player with the highest score after the final round.\n"
    print "\nPress Return to continue.  ".console_red
    go = gets.chomp
    play
  end

  def gameover
    @active = false
  end

  def play
    @playerarray.each{|player|
      printheader
      player.printscore
    }
  end

#     @playerarray.each { |player|
#       # Set initial values per round
#       #
#       # For final round, do this for all but the last player, then
#       # exit & print scores.
#       numdice = 5
#       accumulatedscore = 0
#       player.keeprolling = "Y"
#       while player.keeprolling == "Y"
#         if @final == true
#           if @playerarray[-1].name == player.name
#             # exit
#             gameover
#           end
#         end
#         roll = player.playerroll(numdice)
#
#         rollscore = currentscore(roll)
#         accumulatedscore += rollscore
#
#         unscored = roll.dup
#
#         unscored = unscored.each{|n|
#           3.times{unscored.delete_at(unscored.index(n))} if unscored.count(n) >= 3
#         }.reject{|n|
#           n == 1 || n == 5
#         }
#
#         printscore(player, roll, unscored, rollscore, accumulatedscore)
#
#         newroll = (unscored.empty? ? true : false)
#
#         if newroll
#           print "\n#{player.name} gets a new 5 dice roll!\n".console_purple
#         end
#
#         if rollscore == 0 # A dice score of 0 means the player gets 0 points, and this round is over for that player
#           puts "\n#{player.name} gets no points this round!\n"
#           player.score += 0
#           player.keeprolling = "N"
#           nextplayer(player)
#         else
#           ask_to_roll = true
#           while ask_to_roll
#             player.keeprolling = rollagain
#             if player.keeprolling == "Q"
#               ask_to_roll = false
#               gameover
#               # TODO:
#               # - Show final score
#               # - Return to menu screen
#             elsif player.keeprolling == "Y"
#               numdice = (newroll ? 5 : unscored.size)
#               ask_to_roll = false
#             elsif player.keeprolling == "N"
#               if (player.score + accumulatedscore) >= 300 # More compact to test this way
#                 player.score = 3000
#                 if player.over3000? and @final == false
#                   @final = true
#                   finalround(player)
#                 else
#                   print "\n#{player.name}'s total score for this round is:  " + accumulatedscore.to_s + "\n"
#                   player.score += accumulatedscore
#                 end
#               else # If the player has not yet reached 300, they get NOTHING!
#                 print "\n#{player.name} has not yet reached 300.  Score is 0.\n"
#               end
#               ask_to_roll = false
#               nextplayer(player)
#             else
#               print "Invalid entry.  Choose one:  y/n/q\n"
#               sleep(0.65)
#               printscore(player, roll, unscored, rollscore, accumulatedscore)
#             end
#           end
#         end
#       end
#     }
#
#     @roundnumber += 1
#     print "\nPress Return for next round, or Q for quit.  ".console_purple
#     nextround = gets.to_s.chomp.upcase
#
#     if nextround == "Q"
#       gameover
#     end
#   end

#   def gameover
#     system("clear")
#     print "Thanks for playing Greed!  Now go do something useful!\n"
#     exit
#   end

end

menu_screen

# Display Menu screen
# If option is 2, start a new game.
# When game is finished, display menu screen again.
