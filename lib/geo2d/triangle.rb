# frozen_string_literal: true

require_relative 'polygon'

module Geo2d
  class Triangle < Polygon
    def initialize(a, b, c)
      super([a, b, c])
    end

    def area
      p1, p2, p3 = vertices
      (((p2.x - p1.x) * (p3.y - p1.y)) - ((p2.y - p1.y) * (p3.x - p1.x))).abs / 2.0
    end

    def centroid
      p1, p2, p3 = vertices
      x = (p1.x + p2.x + p3.x) / 3.0
      y = (p1.y + p2.y + p3.y) / 3.0
      Point.new(x, y)
    end

    def equilateral?
      sides = side_lengths
      (sides[0] - sides[1]).abs < EPSILON && (sides[1] - sides[2]).abs < EPSILON
    end

    def isosceles?
      sides = side_lengths
      (sides[0] - sides[1]).abs < EPSILON ||
        (sides[1] - sides[2]).abs < EPSILON ||
        (sides[0] - sides[2]).abs < EPSILON
    end

    def right?
      sides = side_lengths.sort
      ((sides[0]**2) + (sides[1]**2) - (sides[2]**2)).abs < EPSILON
    end

    private

    def side_lengths
      p1, p2, p3 = vertices
      [
        p1.distance_to(p2),
        p2.distance_to(p3),
        p3.distance_to(p1)
      ]
    end

    def validate_vertices(vertices)
      raise ArgumentError, 'Triangle requires exactly 3 vertices' if vertices.size != 3

      super
    end
  end
end
