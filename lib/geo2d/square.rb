# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

module Geo2d
  class Square < RegularPolygon
    include Rectangular

    def initialize(side, center = Point.new(0, 0))
      raise ArgumentError, 'Сторона должна быть положительной' unless side.is_a?(Numeric) && side.positive?
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)

      @side = side.to_f
      radius = @side / Math.sqrt(2)
      super(4, center, radius)
    end

    def self.from_diagonal(point1, point2)
      raise ArgumentError, 'Точки не должны совпадать' if point1 == point2

      unless point1.is_a?(Point) && point2.is_a?(Point)
        raise ArgumentError,
              'Обе точки должны быть точками (Geo2d::Point)'
      end

      center_x = (point1.x + point2.x) / 2.0
      center_y = (point1.y + point2.y) / 2.0
      center = Point.new(center_x, center_y)

      diagonal = point1.distance_to(point2)
      side = diagonal / Math.sqrt(2)

      new(side, center)
    end

    def self.from_point_and_side(point, side)
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless point.is_a?(Point)
      raise ArgumentError, 'Сторона должна быть положительной' unless side.is_a?(Numeric) && side.positive?

      new(side, point)
    end

    def self.from_points(p1, p2, p3, p4)
      vertices = [p1, p2, p3, p4]
      raise ArgumentError, 'Должно быть ровно 4 вершины' unless vertices.size == 4
      raise ArgumentError, 'Все вершины должны быть точками (Geo2d::Point)' unless vertices.all?(Point)

      validate_square_sides(vertices)
      validate_right_angles(vertices)

      center_x = vertices.sum(&:x) / 4.0
      center_y = vertices.sum(&:y) / 4.0
      center = Point.new(center_x, center_y)

      side = p1.distance_to(p2)
      new(side, center)
    end

    attr_reader :side
    alias side_length side

    def area
      @side**2
    end

    def perimeter
      4 * @side
    end

    def interior_angle
      Math::PI / 2
    end

    def width
      @side
    end

    def height
      @side
    end

    def square?
      true
    end

    def rhombus?
      true
    end

    def ==(other)
      return false unless other.is_a?(Square)

      sides_equal = (@side - other.side).abs < EPSILON
      centers_equal = (center.x - other.center.x).abs < EPSILON &&
                      (center.y - other.center.y).abs < EPSILON

      sides_equal && centers_equal
    end

    def to_s
      "Square(side: #{@side}, center: #{center})"
    end

    class << self
      private

      def validate_square_sides(vertices)
        sides = []
        4.times do |i|
          p1 = vertices[i]
          p2 = vertices[(i + 1) % 4]
          sides << p1.distance_to(p2)
        end

        avg_side = sides.sum / sides.size
        sides.each do |side|
          next if (side - avg_side).abs < EPSILON

          raise ArgumentError, 'Все стороны должны быть равны'
        end
      end

      def validate_right_angles(vertices)
        4.times do |i|
          p1 = vertices[i]
          p2 = vertices[(i + 1) % 4]
          p3 = vertices[(i + 2) % 4]

          dot_product = dot_product(p1, p2, p3)
          raise ArgumentError, 'Все углы должны быть прямыми' unless dot_product.abs < EPSILON
        end
      end

      def dot_product(p1, p2, p3)
        v1x = p2.x - p1.x
        v1y = p2.y - p1.y
        v2x = p3.x - p2.x
        v2y = p3.y - p2.y

        (v1x * v2x) + (v1y * v2y)
      end
    end
  end
end

# rubocop:enable Metrics/ClassLength
