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

      # Проверка коллинеарности точки с отрезком через векторное произведение
      cross_segment = ((point.y - @start_point.y) * (@end_point.x - @start_point.x)) - ((point.x - @start_point.x) * (@end_point.y - @start_point.y))
      return false unless cross_segment.abs < EPSILON

      # Проверка: находится ли точка внутри прямоугольника, ограничивающего отрезок
      min_x = [@start_point.x, @end_point.x].min
      min_y = [@start_point.y, @end_point.y].min
      max_x = [@start_point.x, @end_point.x].max
      max_y = [@start_point.y, @end_point.y].max

      (point.x >= min_x - EPSILON) && (point.y >= min_y - EPSILON) && (point.x <= max_x + EPSILON) && (point.y <= max_y + EPSILON)
    end

    def ==(other)
      return false unless other.is_a?(Segment)

      (start_point == other.start_point && end_point == other.end_point) || (start_point == other.end_point && end_point == other.start_point)
    end

    # Является ли отрезок точкой
    def degenerate?
      @start_point == @end_point
    end
  end
end
