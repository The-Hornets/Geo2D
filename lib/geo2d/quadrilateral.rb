# frozen_string_literal: true

require_relative 'polygon'
require_relative 'vector'

module Geo2d
  class Quadrilateral < Polygon
    def self.from_points(*points)
      raise ArgumentError, 'Quadrilateral requires exactly 4 vertices' if points.size != 4

      new(*points)
    end

    def initialize(p1, p2, p3, p4)
      super([p1, p2, p3, p4])
    end

    def area
      return @area if defined?(@area)

      p1, p2, p3, p4 = vertices
      # Формула Гаусса (шнуровки) для четырёхугольника
      sum = ((p1.x * p2.y) - (p2.x * p1.y)) +
            ((p2.x * p3.y) - (p3.x * p2.y)) +
            ((p3.x * p4.y) - (p4.x * p3.y)) +
            ((p4.x * p1.y) - (p1.x * p4.y))
      @area = (0.5 * sum).abs
    end

    def angles
      p1, p2, p3, p4 = vertices
      [
        angle_at(p4, p1, p2),
        angle_at(p1, p2, p3),
        angle_at(p2, p3, p4),
        angle_at(p3, p4, p1)
      ]
    end

    def contains_point?(point)
      p1, p2, p3, p4 = vertices
      signs = [
        cross_product_sign(p1, p2, point),
        cross_product_sign(p2, p3, point),
        cross_product_sign(p3, p4, point),
        cross_product_sign(p4, p1, point)
      ]
      signs.all? { |s| s >= -EPSILON } || signs.all? { |s| s <= EPSILON }
    end

    def valid?
      convex? && area > EPSILON
    end

    private

    def validate_vertices(vertices)
      raise ArgumentError, 'Quadrilateral requires exactly 4 vertices' if vertices.size != 4

      validate_no_duplicate_vertices(vertices)
      validate_convex(vertices)
      validate_area(vertices)
    end

    def validate_convex(vertices)
      raise ArgumentError, 'Quadrilateral must be convex' unless convex?(vertices)
    end

    def validate_area(vertices)
      p1, p2, p3, p4 = vertices
      sum = ((p1.x * p2.y) - (p2.x * p1.y)) +
            ((p2.x * p3.y) - (p3.x * p2.y)) +
            ((p3.x * p4.y) - (p4.x * p3.y)) +
            ((p4.x * p1.y) - (p1.x * p4.y))
      area_val = (0.5 * sum).abs
      raise ArgumentError, 'Quadrilateral area must be greater than 0' if area_val < EPSILON
    end

    def convex?(pts = vertices)
      signs = []
      n = pts.size
      n.times do |i|
        p1 = pts[i]
        p2 = pts[(i + 1) % n]
        p3 = pts[(i + 2) % n]
        signs << cross_product_sign(p1, p2, p3)
      end
      signs.all? { |s| s >= -EPSILON } || signs.all? { |s| s <= EPSILON }
    end

    def cross_product_sign(p1, p2, p3)
      ((p2.x - p1.x) * (p3.y - p1.y)) - ((p2.y - p1.y) * (p3.x - p1.x))
    end

    def angle_at(p_prev, p_vertex, p_next)
      v1 = Geo2d::Vector.new(p_vertex.x - p_prev.x, p_vertex.y - p_prev.y)
      v2 = Geo2d::Vector.new(p_next.x - p_vertex.x, p_next.y - p_vertex.y)
      v1.angle_to(v2)
    end
  end
end
