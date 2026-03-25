# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength, Metrics/CyclomaticComplexity, Metrics/AbcSize

module Geo2d
  class RegularPolygon < Polygon
    EPSILON = 1e-10
    attr_reader :n, :center, :radius

    def initialize(n, center, radius)
      raise ArgumentError, 'Количество сторон должно быть не менее 3' if n < 3
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)
      raise ArgumentError, 'Радиус должен быть положительным числом' unless radius.is_a?(Numeric) && radius.positive?

      @n = n
      @center = center
      @radius = radius.to_f
      @vertices = generate_vertices
      super(@vertices)
    end

    def self.from_side_length(n, side_length)
      raise ArgumentError, 'Количество сторон должно быть не менее 3' if n < 3
      raise ArgumentError, 'Длина стороны должна быть положительной' unless valid_side_length?(side_length)

      radius = side_length / (2 * Math.sin(Math::PI / n))
      center = Point.new(0, 0)
      new(n, center, radius)
    end

    def self.from_points(center, *vertices)
      raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)' unless center.is_a?(Point)
      raise ArgumentError, 'Должно быть не менее 3 вершин' if vertices.size < 3
      raise ArgumentError, 'Все вершины должны быть точками (Geo2d::Point)' unless vertices.all?(Point)

      validate_equal_distances(center, vertices)
      validate_equal_angles(center, vertices)

      n = vertices.size
      radius = center.distance_to(vertices.first)
      new(n, center, radius)
    end

    def side_length
      2 * @radius * Math.sin(Math::PI / @n)
    end

    def area
      (@n * (@radius**2) * Math.sin(2 * Math::PI / @n)) / 2
    end

    def interior_angle
      (@n - 2) * Math::PI / @n
    end

    def exterior_angle
      2 * Math::PI / @n
    end

    def apothem
      @radius * Math.cos(Math::PI / @n)
    end

    def angles
      Array.new(@n, interior_angle)
    end

    def contains_point?(point)
      return false unless point.is_a?(Point)

      ray_casting_algorithm(point)
    end

    def convex?
      true
    end

    def valid?
      @n >= 3 && @center.is_a?(Point) && @radius.positive?
    end

    def ==(other)
      return false unless other.is_a?(RegularPolygon)

      n_equal = @n == other.n
      centers_equal = (@center.x - other.center.x).abs < EPSILON &&
                      (@center.y - other.center.y).abs < EPSILON
      radii_equal = (@radius - other.radius).abs < EPSILON

      n_equal && centers_equal && radii_equal
    end

    def to_s
      "RegularPolygon(n: #{@n}, center: #{@center}, radius: #{@radius})"
    end

    def vertices # rubocop:disable Style/TrivialAccessors
      @vertices
    end

    def vertices_count
      @vertices.size
    end

    class << self
      private

      def valid_side_length?(side_length)
        side_length.is_a?(Numeric) && side_length.positive?
      end

      def validate_equal_distances(center, vertices)
        distances = vertices.map { |v| center.distance_to(v) }
        avg_distance = distances.sum / distances.size
        distances.each do |dist|
          next if (dist - avg_distance).abs < EPSILON

          raise ArgumentError, 'Вершины должны быть на одинаковом расстоянии от центра'
        end
      end

      def validate_equal_angles(center, vertices)
        return if vertices.size == 3

        angles = []
        vertices.each do |vertex|
          angle = Math.atan2(vertex.y - center.y, vertex.x - center.x)
          angle += 2 * Math::PI if angle.negative?
          angles << angle
        end
        angles.sort!

        angle_diffs = []
        angles.each_with_index do |angle, i|
          next_angle = angles[(i + 1) % angles.size]
          diff = next_angle - angle
          diff += 2 * Math::PI if diff.negative?
          angle_diffs << diff
        end

        avg_angle = angle_diffs.sum / angle_diffs.size
        angle_diffs.each do |angle|
          next if (angle - avg_angle).abs < EPSILON * 10

          raise ArgumentError, 'Углы между вершинами должны быть равны'
        end
      end
    end

    private

    def generate_vertices
      vertices = []
      @n.times do |i|
        angle = 2 * Math::PI * i / @n
        x = @center.x + (@radius * Math.cos(angle))
        y = @center.y + (@radius * Math.sin(angle))
        vertices << Point.new(x, y)
      end
      vertices
    end

    def ray_casting_algorithm(point)
      inside = false
      n = @vertices.size

      n.times do |i|
        p1 = @vertices[i]
        p2 = @vertices[(i + 1) % n]

        return true if point_on_segment?(point, p1, p2)
        next unless (p1.y > point.y) != (p2.y > point.y)

        x_intersect = (((point.y - p1.y) * (p2.x - p1.x)) / (p2.y - p1.y)) + p1.x
        inside = !inside if point.x < x_intersect
      end

      inside
    end

    def point_on_segment?(point, p1, p2)
      cross = ((p2.x - p1.x) * (point.y - p1.y)) - ((p2.y - p1.y) * (point.x - p1.x))
      return false unless cross.abs < EPSILON

      dot = ((point.x - p1.x) * (p2.x - p1.x)) + ((point.y - p1.y) * (p2.y - p1.y))
      return false unless dot >= 0

      squared_length = ((p2.x - p1.x)**2) + ((p2.y - p1.y)**2)
      dot <= squared_length
    end
  end
end

# rubocop:enable Metrics/ClassLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
