# frozen_string_literal: true

require_relative 'quadrilateral'
require_relative 'segment'

module Geo2d
  class Trapezoid < Quadrilateral
    attr_reader :base1, :base2, :height, :offset, :vertices

    def initialize(p1, p2, p3, p4)
      super
      @vertices = [p1, p2, p3, p4]
      calculate_properties
    end

    def self.from_bases_and_height(base1, base2, height, offset = 0)
      raise ArgumentError, 'Bases must be positive' unless base1.positive? && base2.positive?
      raise ArgumentError, 'Height must be positive' unless height.positive?

      new(
        Point.new(0, 0),
        Point.new(base1, 0),
        Point.new(base2 + offset, height),
        Point.new(offset, height)
      )
    end

    def edges
      @edges ||= [
        Segment.new(vertices[0], vertices[1]),
        Segment.new(vertices[1], vertices[2]),
        Segment.new(vertices[2], vertices[3]),
        Segment.new(vertices[3], vertices[0])
      ]
    end

    def bases
      @bases ||= [edges[0], edges[2]]
    end

    def legs
      @legs ||= [edges[1], edges[3]]
    end

    def trapezoid?
      true
    end

    def isosceles?
      return false if parallelogram?

      offset.zero?
    end

    def parallelogram?
      base1 == base2 && offset.zero?
    end

    def rectangle?
      parallelogram? && height == base1
    end

    def square?
      rectangle? && base1 == height
    end

    def area
      ((base1 + base2) / 2.0) * height
    end

    def perimeter
      edges.sum(&:length)
    end

    def midline
      (base1 + base2) / 2.0
    end

    def valid?
      area.positive?
    end

    def ==(other)
      return false unless other.is_a?(Trapezoid)

      vertices == other.vertices
    end

    private

    def calculate_properties
      @base1 = (vertices[1].x - vertices[0].x).abs
      @base2 = (vertices[2].x - vertices[3].x).abs
      @height = (vertices[3].y - vertices[0].y).abs
      @offset = (vertices[3].x - vertices[0].x).abs
    end
  end
end
