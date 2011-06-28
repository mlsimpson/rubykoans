require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutIteration < EdgeCase::Koan

  def test_each_is_a_method_on_arrays
    [].methods.include?("each")
  end

  def test_iterating_with_each
    array = [1, 2, 3]
    sum = 0
    array.each do |item|
      sum += item
    end
    assert_equal 6, sum
  end

  def test_each_can_use_curly_brace_blocks_too
    array = [1, 2, 3]
    sum = 0
    array.each { |item|
      sum += item
    }
    assert_equal 6, sum
  end

  def test_break_works_with_each_style_iterations
    array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    sum = 0
    array.each { |item|
      break if item > 3
      sum += item
    }
    assert_equal 6, sum
  end

  def test_collect_transforms_elements_of_an_array
    array = [1, 2, 3]
    new_array = array.collect { |item| item + 10 }
    assert_equal [11, 12, 13], new_array

    # NOTE: 'map' is another name for the 'collect' operation
    another_array = array.map { |item| item + 10 }
    assert_equal [11, 12, 13], another_array
  end

  def test_select_selects_certain_items_from_an_array
    array = [1, 2, 3, 4, 5, 6]

    even_numbers = array.select { |item| (item % 2) == 0 }
    assert_equal [2, 4, 6], even_numbers

    # NOTE: 'find_all' is another name for the 'select' operation
    more_even_numbers = array.find_all { |item| (item % 2) == 0 }
    assert_equal [2, 4, 6], more_even_numbers
  end

  def test_find_locates_the_first_element_matching_a_criteria
    array = ["Jim", "Bill", "Clarence", "Doug", "Eli"]

    assert_equal "Clarence", array.find { |item| item.size > 4 }
  end

  def test_inject_will_blow_your_mind
    result = [2, 3, 4].inject(0) { |sum, item| sum + item }
    assert_equal 9, result
    # Initial:  sum = 0, aka the inject(arg)
    # 0 + 2 = 2
    # 2 + 3 = 5
    # 5 + 4 = 9

    result2 = [2, 3, 4].inject(1) { |sum, item| sum * item }
    assert_equal 24, result2
    # Initial:  sum = 1, aka the inject(arg)
    # 1 * 2 = 2
    # 2 * 3 = 6
    # 6 * 4 = 24

    # Extra Credit:
    # Describe in your own words what inject does.
    #
    # Answer:
    # inject iterates over the members of an array.  While doing so, it performs the block function
    # on each subsequent value within the array.  The argument is the initial value on which the
    # block function is performed.
    #
    # array.inject(arg) { |x, y| <block> }
    # => x is set to arg initially.
    # => y is the first value in the array.
    # => <block> is performed on x & y
    # => upon next iteration, the return value of the block becomes x
    #
    # In short, inject is an accumulator of sorts.
  end

  def test_all_iteration_methods_work_on_any_collection_not_just_arrays
    # Ranges act like a collection
    result = (1..3).map { |item| item + 10 }
    assert_equal [11, 12, 13], result

    # Files act like a collection of lines
    File.open("example_file.txt") do |file|
      upcase_lines = file.map { |line| line.strip.upcase }
      # String.strip returns a copy of str with leading and trailing whitespace removed
      assert_equal ["THIS", "IS", "A", "TEST"], upcase_lines
    end

    # NOTE: You can create your own collections that work with each,
    # map, select, etc.
  end

  # Bonus Question:  In the previous koan, we saw the construct:
  #
  #   File.open(filename) do |file|
  #     # code to read 'file'
  #   end
  #
  # Why did we do it that way instead of the following?
  #
  #   file = File.open(filename)
  #   # code to read 'file'
  #
  # Answer:  the scope of the open file is limited to that block, and it is closed when the
  # block completes.  The file handler is passed to the block argument rather than the main
  # program.
  #
  # When you get to the "AboutSandwichCode" koan, recheck your answer.
  #
  # Updated answer:  "File.open(filename) do |file| {} handles the "sandwich code"
  # of the file.  That is, it handles exceptions without explicit code within the function.

end
