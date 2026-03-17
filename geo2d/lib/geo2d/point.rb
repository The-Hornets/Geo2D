# frozen_string_literal: true

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    @x == other.x and @y == other.y
  end

  def distance_to(other)
    Math.sqrt(((x - other.x)**2) + ((y - other.y)**2))
  end

  def to_s
    "(#{x}, #{y})"
  end
end
