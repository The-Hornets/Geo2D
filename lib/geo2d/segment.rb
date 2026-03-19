# frozen_string_literal: true

module Geo2d
  class Segment
    attr_reader :start_point, :end_point

    # Создаёт новый отрезок по двум точкам
    def initialize(start_point, end_point)
      unless start_point.is_a?(Point) && end_point.is_a?(Point)
        raise ArgumentError,
              'Both arguments must be Point objects'
      end

      @start_point = start_point
      @end_point = end_point
    end

    # Создание отрезка
    def self.from_coords(x1, y1, x2, y2)
      new(Point.new(x1, y1), Point.new(x2, y2))
    end

    # Возвращает длину отрезка
    def length
      @start_point.distance_to(@end_point)
    end

    # Возвращает точку, являющуюся серединой отрезка
    def midpoint
      x = (@start_point.x + @end_point.x) / 2.0
      y = (@start_point.y + @end_point.y) / 2
      Point.new(x, y)
    end

    # Вектор от начала к концу
    def direction
      Point.new(@end_point.x - @start_point.x, @end_point.y - @start_point.y)
    end

    # Проверка принадлежности точки отрезку
    def contains_point?(point)
      return false unless point.is_a?(Point)
      return false unless collinear?(point)

      within_bounding_box?(point)
    end

    def ==(other)
      return false unless other.is_a?(Segment)

      (start_point == other.start_point && end_point == other.end_point) ||
        (start_point == other.end_point && end_point == other.start_point)
    end

    # Является ли отрезок точкой
    def degenerate?
      @start_point == @end_point
    end

    private

    # Проверка коллинеарности точки с отрезком через векторное произведение
    def collinear?(point)
      cross = ((point.y - @start_point.y) * (@end_point.x - @start_point.x)) -
              ((point.x - @start_point.x) * (@end_point.y - @start_point.y))
      cross.abs < EPSILON
    end

    # Проверка: находится ли точка внутри прямоугольника, ограничивающего отрезок
    def within_bounding_box?(point)
      min_x, max_x = [@start_point.x, @end_point.x].minmax
      min_y, max_y = [@start_point.y, @end_point.y].minmax
      point.x.between?(min_x - EPSILON, max_x + EPSILON) &&
        point.y.between?(min_y - EPSILON, max_y + EPSILON)
    end
  end
end
