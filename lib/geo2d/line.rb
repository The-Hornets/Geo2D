# frozen_string_literal: true

module Geo2d
  class Line
    EPSILON = 1e-10
    attr_reader :point1, :point2

    def initialize(point1, point2)
      raise ArgumentError, 'Points must be distinct' if point1 == point2
      raise ArgumentError, 'Both arguments must be Point objects' unless point1.is_a?(Point) && point2.is_a?(Point)

      @point1 = point1
      @point2 = point2
    end

    def self.from_points(point1, point2)
      new(point1, point2)
    end

    def self.from_sides(a, b, c)
      from_equation(a, b, c)
    end

    def self.from_equation(a, b, c)
      raise ArgumentError, 'a and b cannot both be zero' if a.zero? && b.zero?

      if a.zero?
        horizontal_points(b, c)
      elsif b.zero?
        vertical_points(a, c)
      else
        general_points(a, b, c)
      end
    end

    private_class_method def self.horizontal_points(b, c)
      y = -c / b.to_f
      new(Point.new(0, y), Point.new(1, y))
    end

    private_class_method def self.vertical_points(a, c)
      x = -c / a.to_f
      new(Point.new(x, 0), Point.new(x, 1))
    end

    private_class_method def self.general_points(a, b, c)
      new(Point.new(0, -c / b.to_f), Point.new(1, -(a + c) / b.to_f))
    end

    def slope
      dx = @point2.x - @point1.x
      return nil if dx.zero?

      (@point2.y - @point1.y) / dx.to_f
    end

    def coef_a
      @point1.y - @point2.y
    end

    def coef_b
      @point2.x - @point1.x
    end

    def coef_c
      (-(@point1.y - @point2.y) * @point1.x) - ((@point2.x - @point1.x) * @point1.y)
    end

    def contains_point?(point)
      return false unless point.is_a?(Point)

      ((coef_a * point.x) + (coef_b * point.y) + coef_c).abs < EPSILON
    end

    def parallel?(other)
      return false unless other.is_a?(Line)
      return true if slope.nil? && other.slope.nil?
      return false if slope.nil? || other.slope.nil?

      (slope - other.slope).abs < EPSILON
    end

    def perpendicular?(other)
      return false unless other.is_a?(Line)

      s1 = slope
      s2 = other.slope
      return (s1.nil? ^ s2.nil?) && [s1, s2].compact.first.zero? if s1.nil? || s2.nil?

      ((s1 * s2) + 1).abs < EPSILON
    end

    def ==(other)
      return false unless other.is_a?(Line)

      other.contains_point?(@point1) && other.contains_point?(@point2)
    end

    def intersection_of_lines(other)
      raise ArgumentError, 'Argument must be a Line' unless other.is_a?(Line)

      det = (coef_a * other.coef_b) - (other.coef_a * coef_b)
      return coincident_or_nil(other) if det.abs < EPSILON

      intersection_point(other, det)
    end

    def valid?
      point1.is_a?(Point) && point2.is_a?(Point) && point1 != point2
    end

    def to_s
      "Line(point1: #{point1}, point2: #{point2})"
    end

    private

    def intersection_point(other, det)
      x = ((coef_b * other.coef_c) - (other.coef_b * coef_c)) / det.to_f
      y = ((other.coef_a * coef_c) - (coef_a * other.coef_c)) / det.to_f
      Point.new(x, y)
    end

    def coincident_or_nil(other)
      parallel?(other) && contains_point?(other.point1) ? self : nil
    end
  end
end
