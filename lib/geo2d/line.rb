# frozen_string_literal: true

module Geo2d
  class Line
    attr_reader :point_1, :point_2

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
    def self.from_point_slope(point, slope)
      # ?? на сколько продлевать линию
      point2 = slope.nil? ? Point.new(point.x, point.y + 1) : Point.new(point.x + 1, point.y + slope)
      new(point, point2)
    end

    # Фабричный метод: создание прямой по коэффициентам уравнения a*x + b*y + c = 0
    def self.from_equation(a, b, c)
      raise ArgumentError, 'a and b cannot both be zero' if a.zero? && b.zero?

      # ?? на сколько продлевать линию
      # Горизонтальная прямая y = -c/b
      if a.zero?
        p1 = Point.new(0, -c / b.to_f)
        p2 = Point.new(1, -c / b.to_f)
      # Вертикальная прямая: x = -c/a
      elsif b.zero?
        p1 = Point.new(-c / a.to_f, 0)
        p2 = Point.new(-c / a.to_f, 1)
      else
        p1 = Point.new(0, -c / b.to_f)
        p2 = Point.new(1, -(a + c) / b.to_f)
      end
      new(p1, p2)
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

      coef_l1 = slope
      coef_l2 = other.slope
      return true if (coef_l1.nil? && coef_l2.zero?) || (coef_l2.nil? && coef_l1.zero?)
      return false if coef_l1.nil? || coef_l2.nil?

      # Если произведение угловых коэффициентов равно -1, то прямые перпендикулярны
      ((coef_l1 * coef_l2) + 1).abs < EPSILON
    end

    # Находит точку пересечения с другой прямой
    def intersection_of_lines(other)
      raise ArgumentError, 'Argument must be a Line' unless other.is_a?(Line)

      det = (a * other.b) - (other.a * b)
      if det.abs < EPSILON
        return self if parallel?(other) && contains_point?(other.point1)

        return nil
      end
      x = ((b * other.c) - (other.b * c)) / det.to_f
      y = ((other.a * c) - (a * other.c)) / det.to_f
      Point.new(x, y)
    end

    def ==(other)
      return false unless other.is_a?(Line)

      other.contains_point?(@point1) && other.contains_point?(@point2)
    end
  end
end
