# frozen_string_literal: true

require_relative 'triangle'
require_relative 'angle'

module Geo2d
  # Represents an equilateral triangle (all sides equal)
  class EquilateralTriangle < Triangle
    # Creates an equilateral triangle from three points
    #
    # @param a [Point] first vertex
    # @param b [Point] second vertex
    # @param c [Point] third vertex
    # @raise [ArgumentError] if points are collinear, duplicate, or do not form an equilateral triangle
    def initialize(a, b, c)
      super
      validate_equilateral
    end

    # Returns true for valid triangle (always true if initialized)
    #
    # @return [Boolean]
    def valid?
      true
    end

    # Returns the common side length
    #
    # @return [Float] side length
    def side_length
      side_lengths.first
    end

    # Returns all three angles (each 60 degrees)
    #
    # @return [Array<Angle>] array of three equal angles
    def angles
      angle = Angle.from_degrees(60)
      [angle, angle, angle]
    end

    private

    def validate_equilateral
      raise ArgumentError, 'not equilateral' unless equilateral?
    end
  end
end
