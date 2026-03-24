# frozen_string_literal: true

module Geo2d
  class Polygon
    def initialize(vertices)
      raise NotImplementedError, 'Cannot create Polygon instance directly' if instance_of?(Polygon)

      validate_vertices(vertices)
      @vertices = vertices
    end

    def vertices_count
      @vertices.size
    end

    def perimeter
      return 0.0 if @vertices.size < 2

      total = 0.0
      @vertices.each_with_index do |vertex, i|
        next_vertex = @vertices[(i + 1) % @vertices.size]
        total += vertex.distance_to(next_vertex)
      end
      total
    end

    protected

    attr_reader :vertices

    private

    def validate_vertices(vertices)
      raise ArgumentError, 'Vertices array cannot be empty' if vertices.nil? || vertices.empty?
      raise ArgumentError, 'Polygon must have at least 3 vertices' if vertices.size < 3

      # Проверка на совпадающие точки
      vertices.size.times do |i|
        ((i + 1)...vertices.size).each do |j|
          raise ArgumentError, "Duplicate vertices are not allowed: #{vertices[i]}" if vertices[i] == vertices[j]
        end
      end

      # Проверка на коллинеарность всех точек
      raise ArgumentError, 'Vertices cannot be collinear' if collinear?(vertices)
    end

    def collinear?(points)
      return false if points.size < 3

      # Берём первые три различные точки для проверки
      p1 = points[0]
      p2 = points[1]
      p3 = points[2]

      # Векторное произведение векторов (p1->p2) и (p1->p3)
      # Если равно 0, то точки коллинеарны
      cross_product = ((p2.x - p1.x) * (p3.y - p1.y)) - ((p2.y - p1.y) * (p3.x - p1.x))
      cross_product.abs < Geo2d::EPSILON
    end
  end
end
