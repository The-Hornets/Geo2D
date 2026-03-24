# frozen_string_literal: true

module Geo2d
  class Circle
    EPSILON = 1e-10
    attr_reader :center, :radius

    def initialize(center, radius)
      unless center.is_a?(Point)
        raise ArgumentError, 'Центр должен быть точкой (Geo2d::Point)'
      end

      unless radius.is_a?(Numeric) && radius.positive?
        raise ArgumentError, 'Радиус должен быть положительным числом'
      end

      @center = center
      @radius = radius.to_f
    end

    def self.from_diameter(point1, point2)
      unless point1.is_a?(Point) && point2.is_a?(Point)
        raise ArgumentError, 'Обе точки диаметра должны быть точками (Geo2d::Point)'
      end

      if point1 == point2
        raise ArgumentError, 'Точки диаметра не должны совпадать'
      end

      center_x = (point1.x + point2.x) / 2.0
      center_y = (point1.y + point2.y) / 2.0
      center = Point.new(center_x, center_y)
      radius = point1.distance_to(point2) / 2.0

      new(center, radius)
    end

    def self.from_three_points(p1, p2, p3)
      unless p1.is_a?(Point) && p2.is_a?(Point) && p3.is_a?(Point)
        raise ArgumentError, 'Все три точки должны быть точками (Geo2d::Point)'
      end

      if p1 == p2 || p2 == p3 || p1 == p3
        raise ArgumentError, 'Точки не должны совпадать'
      end

      # Проверка на коллинеарность через площадь треугольника
      area = (p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y)
      if area.abs < EPSILON
        raise ArgumentError, 'Точки не должны быть коллинеарны'
      end

      # Находим центр описанной окружности через формулу с определителями
      d = 2.0 * (p1.x * (p2.y - p3.y) + p2.x * (p3.y - p1.y) + p3.x * (p1.y - p2.y))

      ux = ((p1.x**2 + p1.y**2) * (p2.y - p3.y) +
            (p2.x**2 + p2.y**2) * (p3.y - p1.y) +
            (p3.x**2 + p3.y**2) * (p1.y - p2.y)) / d

      uy = ((p1.x**2 + p1.y**2) * (p3.x - p2.x) +
            (p2.x**2 + p2.y**2) * (p1.x - p3.x) +
            (p3.x**2 + p3.y**2) * (p2.x - p1.x)) / d

      center = Point.new(ux, uy)
      radius = center.distance_to(p1)

      new(center, radius)
    end

    def diameter
      2 * @radius
    end

    def area
      Math::PI * @radius**2
    end

    def circumference
      2 * Math::PI * @radius
    end

    alias perimeter circumference

    def contains_point?(point)
      unless point.is_a?(Point)
        raise ArgumentError, 'Аргумент должен быть точкой (Geo2d::Point)'
      end

      (center.distance_to(point) - @radius).abs < EPSILON
    end

    def intersects_circle?(other)
      unless other.is_a?(Circle)
        raise ArgumentError, 'Аргумент должен быть окружностью (Geo2d::Circle)'
      end

      distance = center.distance_to(other.center)
      sum_radii = @radius + other.radius
      diff_radii = (@radius - other.radius).abs

      # Окружности пересекаются, если расстояние между центрами
      # меньше суммы радиусов и больше разности радиусов
      distance < sum_radii && distance > diff_radii
    end

    def tangent_to_circle?(other)
      unless other.is_a?(Circle)
        raise ArgumentError, 'Аргумент должен быть окружностью (Geo2d::Circle)'
      end

      distance = center.distance_to(other.center)
      sum_radii = @radius + other.radius
      diff_radii = (@radius - other.radius).abs

      # Касание: расстояние равно сумме радиусов (внешнее) или разности (внутреннее)
      (distance - sum_radii).abs < EPSILON || (distance - diff_radii).abs < EPSILON
    end

    def valid?
      center.is_a?(Point) && @radius.positive?
    end

    def ==(other)
      return false unless other.is_a?(Circle)

      centers_equal = (center.x - other.center.x).abs < EPSILON &&
                      (center.y - other.center.y).abs < EPSILON
      radii_equal = (@radius - other.radius).abs < EPSILON

      centers_equal && radii_equal
    end

    def to_s
      "Circle(center: #{center}, radius: #{@radius})"
    end
  end
end
