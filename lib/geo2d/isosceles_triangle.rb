# frozen_string_literal: true

require_relative 'triangle'
require_relative 'angle'

module Geo2d
  # Represents an isosceles triangle (triangle with at least two equal sides)
  class IsoscelesTriangle < Triangle
    # Creates an isosceles triangle from three points
    #
    # @param a [Point] first vertex
    # @param b [Point] second vertex
    # @param c [Point] third vertex
    # @raise [ArgumentError] if points are collinear, duplicate, or do not form an isosceles triangle
    def initialize(a, b, c)
      super(a, b, c)
      validate_isosceles
    end

    # Returns true for valid triangle (always true if initialized)
    #
    # @return [Boolean]
    def valid?
      true
    end

    # Returns the two equal sides
    #
    # @return [Array<Float>] array of two equal side lengths
    def equal_sides
      sides = side_lengths
      if (sides[0] - sides[1]).abs < EPSILON
        [sides[0], sides[1]]
      elsif (sides[1] - sides[2]).abs < EPSILON
        [sides[1], sides[2]]
      else
        [sides[0], sides[2]]
      end
    end

    # Returns the base side (the side that is not equal)
    #
    # @return [Float] base side length
    def base
      sides = side_lengths
      if (sides[0] - sides[1]).abs < EPSILON
        sides[2]
      elsif (sides[1] - sides[2]).abs < EPSILON
        sides[0]
      else
        sides[1]
      end
    end

    # Returns the two base angles (angles at the base)
    #
    # @return [Array<Angle>] array of two equal base angles
    def base_angles
      sides = side_lengths
      if (sides[0] - sides[1]).abs < EPSILON
        # equal sides are a and b, base is c
        angle_at = angle_at_vertex(vertices[2])
        [angle_at, angle_at]
      elsif (sides[1] - sides[2]).abs < EPSILON
        angle_at = angle_at_vertex(vertices[0])
        [angle_at, angle_at]
      else
        angle_at = angle_at_vertex(vertices[1])
        [angle_at, angle_at]
      end
    end

    # Returns the vertex angle (angle between equal sides)
    #
    # @return [Angle] vertex angle
    def vertex_angle
      sides = side_lengths
      if (sides[0] - sides[1]).abs < EPSILON
        angle_at_vertex(vertices[0])
      elsif (sides[1] - sides[2]).abs < EPSILON
        angle_at_vertex(vertices[1])
      else
        angle_at_vertex(vertices[2])
      end
    end

    private

    def validate_isosceles
      raise ArgumentError, 'not isosceles' unless isosceles?
    end

    def angle_at_vertex(vertex)
      idx = vertices.index(vertex)
      prev_vertex = vertices[(idx - 1) % 3]
      next_vertex = vertices[(idx + 1) % 3]

      v1 = Vector.new(prev_vertex.x - vertex.x, prev_vertex.y - vertex.y)
      v2 = Vector.new(next_vertex.x - vertex.x, next_vertex.y - vertex.y)

      Angle.new(v1.angle_to(v2))
    end
  end
end