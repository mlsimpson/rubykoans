require File.expand_path(File.dirname(__FILE__) + '/edgecase')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

def score(dice)
  # You need to write this method

  result = 0

  # Exit if empty array; or array.size > 5
  if(dice.size < 1 or dice.size > 5)
    return result
  end

  # if three 1's, + 1000
  # else if three of any other #, + (# * 100)
  # each single 1, + 100
  # each single 5, + 50
  #
  # Possible methods:
  # 1)  Hash, where keys are values on a die (1..6)
  #     - For each instance of a value, increment key=>value.
  # ** GOING WITH #1.
  #
  # 2)  Iterate over the array with Array.shift until size is 0

  # This creates a new hash with value set to 0.
  countHash = Hash.new(0)

  # This populates the Hash with the keys.
  # For each number in the 'dice roll', the total number of instances is added.
  # key == die side; value = total instances
  #
  # NOTE:  In a hash, values are mutable.  keys are not.  Operations performed on a "hash location"
  # are applied to the value, *NOT* the key
  dice.each { |d| countHash[d] += 1 }

  # Now, iterate through each key=>value pair.
  # NOTE:  die, count correspond to key, value.
  # This is standard fare for Ruby blocks.
  # That is, the value within | | corresponds to what is passed into the block.
  # In this case, it's a hash, so each "hash location" has a key and a value.
  countHash.each do |die, count|
    if count >= 3
      # NOTE:  Changing the "if" to "while" allows this to scale to >6 dice,
      # accounting for multiple triples.
      if die == 1
        result += 1000
      else
        result += (die * 100)
      end
      # Now count potential "single instances" of each number if there are > 3 instances.
      count -= 3
    end

    result += (die == 1 ? count * 100 : 0)
    result += (die == 5 ? count * 50 : 0)
  end

  result
end

# Copied from Reddit
# def score(dice)
# 	result = 0
# 	dice = dice.sort
# 	while (dice.any?) do
# 			roll = dice.pop
# 			if (dice.find_all { |x| x == roll }.length >= 2)
# 					result += roll == 1 ? 1000 : 100 * roll
# 					dice = dice[2..-1]
# 			else
# 				result += 100 if (roll == 1)
# 				result += 50 if (roll == 5)
# 			end
# 	end
#
# 	result
# end

# Copied from skim.la
#
# def score(dice)
#     setpoints=[0,1000,200,300,400,500,600]
#     piecepoints=[0,100,0,0,0,50,0]
#     (1..6).map{|i|
#         num=dice.select{|n| n==i}.size
#         num/3*setpoints[i]+num%3*piecepoints[i]
#     }.inject(0){|a,b| a+b}
# end
#
# How the above works:
#
# inject() is called on the result of the map function for each value in (1..6)
# The result from inject() is what is returned; aka the Score.
#
# The map function is used to call the corresponding block over (1..6); that is, for each possible die value.
# num is the number of rolled dice of that given value.
#
# If num > 3, "num/3" >= 1.  For each [i], the array position that corresponds to (1..6) is accessed.
# If num < 3, "num/3" = 0; this nullifies the selected value from setpoints[]
#
# The latter part of the arithmetic result of the map uses modulo operator to multiply the score of each piece by its
# multiplier, given in piecepoints[].
#
# An interesting effect of this implementation is the fact that it scales to instances where >6 dice are used.
# That is, it will count multiple triples.

class AboutScoringProject < EdgeCase::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
  end

end
