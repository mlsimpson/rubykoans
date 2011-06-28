require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutExceptions < EdgeCase::Koan

  class MySpecialError < RuntimeError
  end

  def test_exceptions_inherit_from_Exception
    assert_equal RuntimeError, MySpecialError.ancestors[1]
    assert_equal StandardError, MySpecialError.ancestors[2]
    assert_equal Exception, MySpecialError.ancestors[3]
    assert_equal Object, MySpecialError.ancestors[4]
  end
  # What is up with Exceptions?
  # - First error in array of ancestors:  RuntimeError
  # - Second error in array of ancestors:  StandardError
  # - Third error in array of ancestors:  Exception
  # - Fourth error in array of ancestors:  Object
  # WHY?
  # Answer:  Inheritance.  It's the order of precedence.  NOTE this.
  # The highest precedence is, as always, Object.  Object => Exception => StandardError => RuntimeError

  def test_rescue_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result

    assert_equal true, ex.is_a?(StandardError), "Should be a Standard Error"
    assert_equal true, ex.is_a?(RuntimeError),  "Should be a Runtime Error"
    # Gotcha:  Both of these are true.  RuntimeError > StandardError == true

    assert RuntimeError.ancestors.include?(StandardError),
      "RuntimeError is a subclass of StandardError"
    # RuntimeErros inherits StandardError.  IE:  RuntimeError is a child of StandardError

    assert_equal "Oops", ex.message
    # NOTE:  "fail:  "Oops" is the message of the exception.  Since they're children of
    # Exception => StandardError => RuntimeError... the message sent is
    # The message delivered:  "Oops"
  end

  def test_raising_a_particular_error
    result = nil
    begin
      # 'raise' and 'fail' are synonyms
      raise MySpecialError, "My Message"
    rescue MySpecialError => ex
      result = :exception_handled
    end

    assert_equal :exception_handled, result
    assert_equal "My Message", ex.message
    # The message of an exception is exception.message, which in this case is:
    # "My Message" defined above.
  end

  def test_ensure_clause
    result = nil
    begin
      fail "Oops"
    rescue StandardError => ex
      # no code here
    ensure
      result = :always_run
    end

    assert_equal :always_run, result
  end
  # Lesson here:  "'ensure' is what is raised if there is no rescue code.

  # Sometimes, we must know about the unknown
  def test_asserting_an_error_is_raised
    # A do-end is a block, a topic to explore more later
    assert_raise(MySpecialError) do
      raise MySpecialError.new("New instances can be raised directly.")
    end
  end

end
