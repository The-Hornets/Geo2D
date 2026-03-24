# frozen_string_literal: true

module Geo2d
  class Vector
    attr_reader :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(other)
      x == other.x && y == other.y
    end

    def +(other)
      Vector.new(x + other.x, y + other.y)
    end

    def *(other)
      Vector.new(x * other, y * other)
    end

    def -(other)
      Vector.new(x - other.x, y - other.y)
    end

    def magnitude
      Math.sqrt((x**2) + (y**2))
    end

    def dot(other)
      (x * other.x) + (y * other.y)
    end

    def cross(other)
      (x * other.y) - (y * other.x)
    end

    def to_s
      "(#{x}, #{y})"
    end
  end
end
