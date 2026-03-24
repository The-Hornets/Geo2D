# frozen_string_literal: true

require_relative 'triangle'

module Geo2d
  class RightTriangle < Triangle
    def initialize(a, b, c)
      super
      validate_right_triangle
    end

    def hypotenuse
      side_lengths.max
    end

    def legs
      sides = side_lengths.sort
      [sides[0], sides[1]]
    end

    def right?
      true
    end

    def equilateral?
      false
    end

    private

    def validate_right_triangle
      raise ArgumentError, 'Not a right triangle' unless right_triangle?
    end

    def right_triangle?
      sides = side_lengths.sort
      (((sides[0]**2) + (sides[1]**2)) - (sides[2]**2)).abs < EPSILON
    end
  end
end
