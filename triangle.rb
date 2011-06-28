# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
    # if any of the sides are 0, raise TriangleError

    # if(a <= 0) or (b <= 0) or (c <= 0)
    #     raise TriangleError, "Sides must be greater than 0."
    # end

    # REFACTOR
    raise TriangleError unless [a,b,c].each { |x|
        x > 0
    }

    # if the sum of the two shortest sides do not add up to the length of the longest,
    # raise TriangleError

    sides = [a, b, c].sort
    if(sides[0] + sides[1] <= sides[2])
       raise TriangleError, "Sides do not add up."
    end

    # if(a ==b) and (a == c)
    #     :equilateral
    # elsif (a != b) and (b != c) and (a != c)
    #     :scalene
    # else
    #     :isosceles
    # end

    # REFACTOR

    # How this works:
    # Since this is the last line of the triangle function, it's the return value.
    # We return "Array of Triangle Values[location]"
    # aka, what you see below.
    # sides.uniq returns an array of independently unique values.
    # If any numbers are duplicated, then all but one are removed.
    # Applied to the triangle values, if all 3 are the same, then there's 1 value.
    # 1 - 1 = 0; triangleValue[0] == :equilateral.
    # Lather, Rinse, Repeat

    [:equilateral, :isosceles, :scalene][sides.uniq.size - 1]
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
