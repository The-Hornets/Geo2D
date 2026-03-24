# frozen_string_literal: true

module Geo2d
  class Disk
    EPSILON = 1e-10
    attr_reader :center, :radius

    def initialize(center, radius)
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)
      raise ArgumentError, 'Радиус должен быть положительным числом' unless radius.is_a?(Numeric) && radius.positive?

      @center = center
      @radius = radius.to_f
    end

    def self.from_diameter(point1, point2)
      unless point1.is_a?(Point) && point2.is_a?(Point)
        raise ArgumentError, 'Обе точки диаметра должны быть точками (Geo2d::Point)'
      end
      raise ArgumentError, 'Точки диаметра не должны совпадать' if point1 == point2

      center_x = (point1.x + point2.x) / 2.0
      center_y = (point1.y + point2.y) / 2.0
      center = Point.new(center_x, center_y)
      radius = point1.distance_to(point2) / 2.0

      new(center, radius)
    end

    def diameter
      2 * @radius
    end

    def area
      Math::PI * (@radius**2)
    end

    def circumference
      2 * Math::PI * @radius
    end

    alias perimeter circumference

    def boundary
      Circle.new(@center, @radius)
    end

    def contains_point?(point)
      raise ArgumentError, 'Аргумент должен быть точкой (Geo2d::Point)' unless point.is_a?(Point)

      center.distance_to(point) <= (@radius + EPSILON)
    end

    def contains_circle?(circle)
      raise ArgumentError, 'Аргумент должен быть окружностью (Geo2d::Circle)' unless circle.is_a?(Circle)

      distance = center.distance_to(circle.center)
      (distance + circle.radius) <= (@radius + EPSILON)
    end

    def contains_disk?(other)
      raise ArgumentError, 'Аргумент должен быть Disk' unless other.is_a?(Disk)

      distance = center.distance_to(other.center)
      (distance + other.radius) <= (@radius + EPSILON)
    end

    def intersects_disk?(other)
      raise ArgumentError, 'Аргумент должен быть Disk' unless other.is_a?(Disk)

      distance = center.distance_to(other.center)
      distance <= (@radius + other.radius + EPSILON)
    end

    def valid?
      center.is_a?(Point) && @radius.positive?
    end

    def ==(other)
      return false unless other.is_a?(Disk)

      centers_equal = (center.x - other.center.x).abs < EPSILON &&
                      (center.y - other.center.y).abs < EPSILON
      radii_equal = (@radius - other.radius).abs < EPSILON

      centers_equal && radii_equal
    end

    def to_s
      "Disk(center: #{center}, radius: #{@radius})"
    end
  end
end
