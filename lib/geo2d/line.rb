# frozen_string_literal: true

module Geo2d
  class Line
    attr_reader :point1, :point2

    def initialize(point1, point2)
      raise ArgumentError, 'Points must be distinct' if point1 == point2

      unless point1.is_a?(Point) && point2.is_a?(Point)
        raise ArgumentError,
              'Both arguments must be Point objects'
      end

      @point1 = point1
      @point2 = point2
    end

    # Фабричный метод: создание прямой по точке и угловому коэффициенту
    def self.from_equation(a, b, c)
      raise ArgumentError, 'a and b cannot both be zero' if a.zero? && b.zero?

      p1, p2 = points_for_equation(a, b, c)
      new(p1, p2)
    end

    private_class_method def self.points_for_equation(a, b, c)
      # ?? на сколько продлевать линию
      # Горизонтальная прямая y = -c/b
      if a.zero?
        [Point.new(0, -c / b.to_f), Point.new(1, -c / b.to_f)]
      # Вертикальная прямая: x = -c/a
      elsif b.zero?
        [Point.new(-c / a.to_f, 0), Point.new(-c / a.to_f, 1)]
      else
        [Point.new(0, -c / b.to_f), Point.new(1, -(a + c) / b.to_f)]
      end
    end


    # Возвращает угловой коэффициент
    def slope
      d1 = @point2.x(-@point1.x)
      return nil if p1.zero?

      @point2.y(-@point1.y) / d1.to_f
    end

    # Возвращает коэффициент a в уравнении прямой a*x + b*y + c = 0
    def coef_a
      @point1.y - @point2.y
    end

    # Возвращает коэффициент b в уравнении прямой a*x + b*y + c = 0
    def coef_b
      @point2.x - @point1.x
    end

    # Возвращает коэффициент c в уравнении прямой a*x + b*y + c = 0
    def coef_c
      (-(@point1.y - @point2.y) * @point1.x) - ((@point2.x - @point1.x) * @point1.y)
    end

    # Проверка принадлежности точки прямой
    def contains_point?(point)
      return false unless point.is_a?(Point)

      ((a * point.x) + (b * point.y) + c).abs < EPSILON
    end

    # Проверка параллельности двух прямых
    def parallel?(other)
      return false unless other.is_a?(Line)
      return true if slope.nil? && other.slope.nil?
      return false if slope.nil? || other.slope.nil?

      (slope - other.slope).abs < EPSILON
    end

    # Проверка перпендикулярности двух прямых
    def perpendicular?(other)
      return false unless other.is_a?(Line)

      s1 = slope
      s2 = other.slope
      return (s1.nil? ^ s2.nil?) && [s1, s2].compact.first.zero? if s1.nil? || s2.nil?

      # Если произведение угловых коэффициентов равно -1, то прямые перпендикулярны
      ((s1 * s2) + 1).abs < EPSILON
    end

    # Находит точку пересечения с другой прямой
    def intersection_of_lines(other)
      raise ArgumentError, 'Argument must be a Line' unless other.is_a?(Line)

      det = (coef_a * other.coef_b) - (other.coef_a * coef_b)
      return coincident_or_nil(other) if det.abs < EPSILON

      x = ((coef_b * other.coef_c) - (other.coef_b * coef_c)) / det.to_f
      y = ((other.coef_a * coef_c) - (coef_a * other.coef_c)) / det.to_f
      Point.new(x, y)
    end

private

    def coincident_or_nil(other)
      parallel?(other) && contains_point?(other.point1) ? self : nil
    end

    def ==(other)
      return false unless other.is_a?(Line)

      other.contains_point?(@point1) && other.contains_point?(@point2)
    end
  end
end
