# frozen_string_literal: true

require_relative 'quadrilateral'

module Geo2d
  class Parallelogram < Quadrilateral
    attr_reader :side_a, :side_b, :angle

    def self.from_points(p1, p2, p3, p4, *rest)
      points = [p1, p2, p3, p4, *rest].compact
      raise ArgumentError, 'Parallelogram requires exactly 4 vertices' if points.size != 4

      new(p1, p2, p3, p4)
    end

    def self.from_side_and_angle(a, b, angle)
      raise ArgumentError, 'Side lengths must be positive' if a <= 0 || b <= 0
      raise ArgumentError, 'Angle must be in range (0, PI)' if angle <= 0 || angle >= Math::PI

      p1 = Point.new(0, 0)
      p2 = Point.new(a, 0)
      p3 = Point.new(a + (b * Math.cos(angle)), b * Math.sin(angle))
      p4 = Point.new(b * Math.cos(angle), b * Math.sin(angle))

      new(p1, p2, p3, p4, angle)
    end

    def initialize(p1, p2, p3, p4, angle = nil)
      super(p1, p2, p3, p4)
      @angle = angle
    end

    def area
      sides = side_lengths
      a = sides[0]
      b = sides[1]
      (a * b * Math.sin(angle_between_sides)).abs
    end

    def perimeter
      sides = side_lengths
      2 * (sides[0] + sides[1])
    end

    def angles
      angle_val = angle_between_sides
      [angle_val, Math::PI - angle_val, angle_val, Math::PI - angle_val]
    end

    def side_lengths
      p1, p2, p3, p4 = vertices
      [
        p1.distance_to(p2),
        p2.distance_to(p3),
        p3.distance_to(p4),
        p4.distance_to(p1)
      ]
    end

    def angle_between_sides
      return @angle if @angle

      p1, p2, p4 = vertices
      v1 = Vector.new(p2.x - p1.x, p2.y - p1.y)
      v2 = Vector.new(p4.x - p1.x, p4.y - p1.y)
      @angle = v1.angle_to(v2)
    end

    def valid?
      super && parallelogram?
    end

    private

    def validate_vertices(vertices)
      raise ArgumentError, 'Parallelogram requires exactly 4 vertices' if vertices.size != 4

      validate_no_duplicate_vertices(vertices)
      validate_parallelogram(vertices)
      validate_area(vertices)
    end

    def validate_parallelogram(vertices)
      raise ArgumentError, 'Points do not form a parallelogram' unless parallelogram?(vertices)
    end

    def parallelogram?(pts = vertices)
      return false unless convex?(pts)

      p1, p2, p3, p4 = pts
      opposite_sides_equal?(p1, p2, p3, p4) && opposite_sides_parallel?(p1, p2, p3, p4)
    end

    def opposite_sides_equal?(p1, p2, p3, p4)
      side1 = p1.distance_to(p2)
      side2 = p2.distance_to(p3)
      side3 = p3.distance_to(p4)
      side4 = p4.distance_to(p1)

      (side1 - side3).abs < EPSILON && (side2 - side4).abs < EPSILON
    end

    def opposite_sides_parallel?(p1, p2, p3, p4)
      v1 = Vector.new(p2.x - p1.x, p2.y - p1.y)
      v3 = Vector.new(p4.x - p3.x, p4.y - p3.y)
      v2 = Vector.new(p3.x - p2.x, p3.y - p2.y)
      v4 = Vector.new(p1.x - p4.x, p1.y - p4.y)

      parallel?(v1, v3) && parallel?(v2, v4)
    end

    def parallel?(v1, v2)
      cross = v1.cross(v2)
      cross.abs < EPSILON
    end
  end
end
