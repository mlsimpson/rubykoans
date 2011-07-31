require "about_dice_project"

class GreedDiceSet < DiceSet
  attr_reader :unscored_count

  def initialize
    @values = []
    @unscored_count = 0
  end

  def roll(count)
    @unscored_count = 0
    super(count)
    score
  end

  private

  def score
    sum = 0
    accumulator = nil

    @values.sort.each do |item|
      if accumulator.nil?
        accumulator = [item]
      elsif accumulator[-1] == item
        accumulator << item
      else
        sum += sum_accumulator(accumulator)
        accumulator = [item]
      end

      if accumulator.length == 3
        sum += sum_accumulator(accumulator)
        accumulator = nil
      end
    end

    sum += sum_accumulator(accumulator)

    sum
  end

  def sum_accumulator(accumulator)
    if accumulator.nil? || accumulator.empty?
      0
    elsif accumulator.length == 3
      (accumulator[0] == 1) ? 1000 : (accumulator[0] * 100)
    else
      accumulator.inject(0) do |memo, i|
        if i == 1
          memo + 100
        elsif i == 5
          memo + 50
        else
          @unscored_count += 1
          memo
        end
      end
    end
  end
end


class Player
  attr_reader :name
  attr_reader :total_score

  def initialize(name)
    @name = name
    @total_score = 0
  end

  def go(verbose=false)
    dice = GreedDiceSet.new
    dice_count = 5
    turn_score = 0

    while true
      roll_score = dice.roll(dice_count)
      if roll_score == 0
        puts "#{@name} scored no points, their turn is over and no points scored!"    if verbose
        turn_score = 0
        break # turn over
      else
        turn_score += roll_score
      end

      dice_count = (dice.unscored_count == 0) ? 5 : dice.unscored_count

      # if played is over 3k
      if((@total_score + turn_score) >= 3000)
        puts "#{@name} reached at least 3000 points ending their turn."   if verbose
        break
      end

      # if played have over 300 AND they decide to end their turn
      # note: adding the score and checking the result is more compact
      # than checking if the total is 0 and the turn score is at least 300.
      if (@total_score + turn_score >= 300) && (rand(2) == 1)
        puts "#{@name} decided to end their turn." if verbose
        break
      end
    end

    @total_score += turn_score
  end
end

class Greed
  def self.play(players, verbose=false)
    players = players.empty? ? [Player.new("Dummy1"), Player.new("Dummy2")] : players

    while !player_over_3k?(players)
      players.each do |player|
        player.go(verbose)
        if player.total_score >= 3000
          puts "#{player.name} is over 3000 points, entering final round." if verbose
          break
        end
      end
    end

    players.each do |player|
      player.go(verbose)
    end

    puts ""
    puts "Final Scores"
    puts "*****************"
    players.each {|x| puts "#{x.name} scored: #{x.total_score}"}

    winner = players.sort{|a,b| a.total_score <=> b.total_score}.last

    puts ""
    puts "#{winner.name} is the winner!!!"
  end

  private

  def self.player_over_3k?(players)
    players.detect {|player| player.total_score >= 3000}
  end
end

players = [
  Player.new("Michael"),
  Player.new("Dan"),
  Player.new("Bala"),
  Player.new("Tara")
]

puts "Extra Credit Greed Dice Game"
puts "*****************"
Greed.play(players)

