# frozen_string_literal: true

require_relative 'quadrilateral'
require_relative 'vector'

module Geo2d
  # Represents a rhombus (equilateral quadrilateral)
  class Rhombus < Quadrilateral
    attr_reader :side, :angle

    # Creates a rhombus from four points
    #
    # @param p1 [Point] first vertex
    # @param p2 [Point] second vertex
    # @param p3 [Point] third vertex
    # @param p4 [Point] fourth vertex
    # @raise [ArgumentError] if points do not form a rhombus
    def self.from_points(p1, p2, p3, p4, *rest)
      points = [p1, p2, p3, p4, *rest].compact
      raise ArgumentError, 'Rhombus requires exactly 4 vertices' if points.size != 4

      new(p1, p2, p3, p4)
    end

    # Creates a rhombus from side length and angle
    #
    # @param side [Float] length of each side
    # @param angle [Float] angle between sides (in radians, 0 < angle < PI)
    # @return [Rhombus] new rhombus instance
    # @raise [ArgumentError] if side <= 0 or angle out of range
    def self.from_side_and_angle(side, angle)
      raise ArgumentError, 'Side length must be positive' if side <= 0
      raise ArgumentError, 'Angle must be in range (0, PI)' if angle <= 0 || angle >= Math::PI

      # Создаём вершины ромба
      p1 = Point.new(0, 0)
      p2 = Point.new(side, 0)
      p3 = Point.new(side + (side * Math.cos(angle)), side * Math.sin(angle))
      p4 = Point.new(side * Math.cos(angle), side * Math.sin(angle))

      new(p1, p2, p3, p4, angle)
    end

    def initialize(p1, p2, p3, p4, angle = nil)
      super(p1, p2, p3, p4)
      @side = p1.distance_to(p2)
      @angle = angle || calculate_angle(p1, p2, p4)
    end

    # Returns the common side length
    #
    # @return [Float] side length
    def side_length
      @side
    end

    # Returns the area of the rhombus
    #
    # @return [Float] area
    def area
      @side * @side * Math.sin(@angle)
    end

    # Returns the perimeter of the rhombus
    #
    # @return [Float] perimeter
    def perimeter
      4 * @side
    end

    # Returns the four angles
    #
    # @return [Array<Float>] angles in radians
    def angles
      [@angle, Math::PI - @angle, @angle, Math::PI - @angle]
    end

    # Returns the lengths of both diagonals
    #
    # @return [Array<Float>] [diagonal1, diagonal2]
    def diagonals
      d1 = @side * Math.sqrt(2 + (2 * Math.cos(@angle)))
      d2 = @side * Math.sqrt(2 - (2 * Math.cos(@angle)))
      [d1, d2]
    end

    # Returns the angle between sides
    #
    # @return [Float] angle in radians
    def angle_between_sides
      @angle
    end

    # Returns true if rhombus is a square
    #
    # @return [Boolean]
    def square?
      (@angle - (Math::PI / 2)).abs < EPSILON
    end

    # Returns true if shape is a rhombus
    #
    # @return [Boolean]
    def rhombus?
      sides = [
        vertices[0].distance_to(vertices[1]),
        vertices[1].distance_to(vertices[2]),
        vertices[2].distance_to(vertices[3]),
        vertices[3].distance_to(vertices[0])
      ]
      (sides[0] - sides[1]).abs < EPSILON &&
        (sides[1] - sides[2]).abs < EPSILON &&
        (sides[2] - sides[3]).abs < EPSILON
    end

    def valid?
      super && rhombus?
    end

    private

    def calculate_angle(p1, p2, p4)
      v1 = Vector.new(p2.x - p1.x, p2.y - p1.y)
      v2 = Vector.new(p4.x - p1.x, p4.y - p1.y)
      v1.angle_to(v2)
    end

    def validate_vertices(vertices)
      raise ArgumentError, 'Rhombus requires exactly 4 vertices' if vertices.size != 4

      validate_no_duplicate_vertices(vertices)
      validate_rhombus(vertices)
      validate_area(vertices)
    end

    def validate_rhombus(vertices)
      raise ArgumentError, 'Points do not form a rhombus' unless rhombus_for_validation?(vertices)
    end

    def rhombus_for_validation?(pts)
      sides = [
        pts[0].distance_to(pts[1]),
        pts[1].distance_to(pts[2]),
        pts[2].distance_to(pts[3]),
        pts[3].distance_to(pts[0])
      ]
      (sides[0] - sides[1]).abs < EPSILON &&
        (sides[1] - sides[2]).abs < EPSILON &&
        (sides[2] - sides[3]).abs < EPSILON
    end
  end
end
