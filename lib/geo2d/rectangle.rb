# frozen_string_literal: true

require_relative 'parallelogram'

module Geo2d
  class Rectangle < Parallelogram
    def self.from_points(p1, p2, p3, p4, *rest)
      points = [p1, p2, p3, p4, *rest].compact
      raise ArgumentError, 'Rectangle requires exactly 4 vertices' if points.size != 4

      new(p1, p2, p3, p4)
    end

    def self.from_sides(width, height)
      raise ArgumentError, 'Width must be positive' if width <= 0
      raise ArgumentError, 'Height must be positive' if height <= 0

      p1 = Point.new(0, 0)
      p2 = Point.new(width, 0)
      p3 = Point.new(width, height)
      p4 = Point.new(0, height)

      new(p1, p2, p3, p4)
    end

    def self.from_side_and_angle(a, b, angle)
      raise ArgumentError, 'Side lengths must be positive' if a <= 0 || b <= 0
      raise ArgumentError, 'Rectangle requires right angle (PI/2)' unless right_angle?(angle)

      from_sides(a, b)
    end

    def self.right_angle?(angle)
      (angle - (Math::PI / 2)).abs < EPSILON
    end

    def initialize(p1, p2, p3, p4)
      super(p1, p2, p3, p4, Math::PI / 2)
      @width = nil
      @height = nil
    end

    def area
      width * height
    end

    def perimeter
      2 * (width + height)
    end

    def angles
      [Math::PI / 2, Math::PI / 2, Math::PI / 2, Math::PI / 2]
    end

    def width
      @width ||= vertices[0].distance_to(vertices[1])
    end

    def height
      @height ||= vertices[1].distance_to(vertices[2])
    end

    def side_lengths
      [width, height, width, height]
    end

    def angle_between_sides
      Math::PI / 2
    end

    def valid?
      super && rectangle?
    end

    private

    def validate_vertices(vertices)
      raise ArgumentError, 'Rectangle requires exactly 4 vertices' if vertices.size != 4

      validate_no_duplicate_vertices(vertices)
      validate_rectangle(vertices)
      validate_area(vertices)
    end

    def validate_rectangle(vertices)
      raise ArgumentError, 'Points do not form a rectangle' unless rectangle?(vertices)
    end

    def rectangle?(pts = vertices)
      return false unless parallelogram?(pts)

      right_angles?(pts)
    end

    def right_angles?(pts)
      p1, p2, p3, p4 = pts
      angle1 = angle_at(p4, p1, p2)
      angle2 = angle_at(p1, p2, p3)
      angle3 = angle_at(p2, p3, p4)
      angle4 = angle_at(p3, p4, p1)

      [angle1, angle2, angle3, angle4].all? { |a| (a - (Math::PI / 2)).abs < EPSILON }
    end

    def angle_at(p_prev, p_vertex, p_next)
      v1 = Vector.new(p_vertex.x - p_prev.x, p_vertex.y - p_prev.y)
      v2 = Vector.new(p_next.x - p_vertex.x, p_next.y - p_vertex.y)
      v1.angle_to(v2)
    end
  end
end
