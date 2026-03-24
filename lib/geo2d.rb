# frozen_string_literal: true

require_relative 'geo2d/version'
require_relative 'geo2d/point'
require_relative 'geo2d/segment'
require_relative 'geo2d/polygon'
require_relative 'geo2d/triangle'
require_relative 'geo2d/right_triangle'
require_relative 'geo2d/quadrilateral'
require_relative 'geo2d/parallelogram'

module Geo2d
  EPSILON = 1e-10
  class Error < StandardError; end
  # Your code goes here...
end
