require File.expand_path(File.dirname(__FILE__) + '/edgecase')

class AboutOpenClasses < EdgeCase::Koan
  class Dog
    def bark
      "WOOF"
    end
  end
  # NOTE:  "WOOF" is by itself.  It seems that it's a print statement alone?
  # Or as the below indicates, mayhaps it's simply the return value.
  #
  # Yep, it's the return value; duh.

  def test_as_defined_dogs_do_bark
    fido = Dog.new
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  # Open the existing Dog class and add a new method.
  class Dog
    def wag
      "HAPPY"
    end
  end

  def test_after_reopening_dogs_can_both_wag_and_bark
    fido = Dog.new
    assert_equal "HAPPY", fido.wag
    assert_equal "WOOF", fido.bark
  end

  # ------------------------------------------------------------------

  class ::Integer
    def even?
      (self % 2) == 0
    end
  end

  def test_even_existing_built_in_classes_can_be_reopened
    assert_equal false, 1.even?
    assert_equal true, 2.even?
  end

  # NOTE: To understand why we need the :: before Integer, you need to
  # become enlightened about scope.
end
