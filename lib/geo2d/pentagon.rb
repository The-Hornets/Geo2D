# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

module Geo2d
  class Pentagon < RegularPolygon
    EPSILON = 1e-10

    def initialize(side, center = Point.new(0, 0))
      raise ArgumentError, 'Сторона должна быть положительной' unless side.is_a?(Numeric) && side.positive?
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)

      @side = side.to_f
      radius = @side / (2 * Math.sin(Math::PI / 5))
      super(5, center, radius)
    end

    def self.from_radius(radius, center = Point.new(0, 0))
      raise ArgumentError, 'Радиус должен быть положительным' unless radius.is_a?(Numeric) && radius.positive?
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)

      side = 2 * radius * Math.sin(Math::PI / 5)
      new(side, center)
    end

    def self.from_point_and_side(point, side)
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless point.is_a?(Point)
      raise ArgumentError, 'Сторона должна быть положительной' unless side.is_a?(Numeric) && side.positive?

      new(side, point)
    end

    def self.from_points(*vertices)
      raise ArgumentError, 'Должно быть ровно 5 вершин' unless vertices.size == 5
      raise ArgumentError, 'Все вершины должны быть точками (Geo2d::Point)' unless vertices.all?(Point)

      validate_equal_sides(vertices)
      validate_equal_angles(vertices)

      center_x = vertices.sum(&:x) / 5.0
      center_y = vertices.sum(&:y) / 5.0
      center = Point.new(center_x, center_y)

      side = vertices[0].distance_to(vertices[1])
      new(side, center)
    end

    attr_reader :side
    alias side_length side

    def area
      (5 * (@radius**2) * Math.sin(2 * Math::PI / 5)) / 2
    end

    def perimeter
      5 * @side
    end

    def interior_angle
      3 * Math::PI / 5
    end

    def exterior_angle
      2 * Math::PI / 5
    end

    def apothem
      @radius * Math.cos(Math::PI / 5)
    end

    def pentagon?
      true
    end

    def regular?
      true
    end

    def convex?
      true
    end

    def ==(other)
      return false unless other.is_a?(Pentagon)

      sides_equal = (@side - other.side).abs < EPSILON
      centers_equal = (center.x - other.center.x).abs < EPSILON &&
                      (center.y - other.center.y).abs < EPSILON

      sides_equal && centers_equal
    end

    def to_s
      "Pentagon(side: #{@side}, center: #{center})"
    end

    class << self
      private

      def validate_equal_sides(vertices)
        sides = calculate_sides(vertices)
        avg_side = sides.sum / sides.size

        sides.each do |side|
          next if (side - avg_side).abs < EPSILON

          raise ArgumentError, 'Все стороны должны быть равны'
        end
      end

      def calculate_sides(vertices)
        sides = []
        5.times do |i|
          p1 = vertices[i]
          p2 = vertices[(i + 1) % 5]
          sides << p1.distance_to(p2)
        end
        sides
      end

      def validate_equal_angles(vertices)
        angles = calculate_angles(vertices)
        avg_angle = angles.sum / angles.size

        angles.each do |angle|
          next if (angle - avg_angle).abs < EPSILON

          raise ArgumentError, 'Все углы должны быть равны'
        end
      end

      def calculate_angles(vertices)
        angles = []
        5.times do |i|
          p1 = vertices[i]
          p2 = vertices[(i + 1) % 5]
          p3 = vertices[(i + 2) % 5]
          angles << angle_between(p1, p2, p3)
        end
        angles
      end

      def angle_between(p1, p2, p3)
        v1x = p1.x - p2.x
        v1y = p1.y - p2.y
        v2x = p3.x - p2.x
        v2y = p3.y - p2.y

        dot = (v1x * v2x) + (v1y * v2y)
        mag1 = Math.sqrt((v1x**2) + (v1y**2))
        mag2 = Math.sqrt((v2x**2) + (v2y**2))

        return 0 if mag1.zero? || mag2.zero?

        cos_angle = dot / (mag1 * mag2)
        Math.acos(cos_angle.clamp(-1, 1))
      end

      def centroid(vertices)
        center_x = vertices.sum(&:x) / 5.0
        center_y = vertices.sum(&:y) / 5.0
        Point.new(center_x, center_y)
      end
    end
  end
end

# rubocop:enable Metrics/ClassLength
