# frozen_string_literal: true

require_relative 'point'
require_relative 'angle'

# Represents a ray (half-line) defined by an origin point and direction angle
class Ray
  attr_reader :origin, :direction_angle

  # Creates a ray from an origin point and direction angle
  #
  # @param origin [Geo2d::Point] the starting point of the ray
  # @param direction_angle [Angle] the direction of the ray
  # @raise [ArgumentError] if origin is not a Point or direction_angle is not an Angle
  def initialize(origin, direction_angle)
    raise ArgumentError, 'Origin must be a Point' unless origin.is_a?(Geo2d::Point)
    raise ArgumentError, 'Direction angle must be an Angle' unless direction_angle.is_a?(Angle)

    @origin = origin
    @direction_angle = direction_angle
  end

  # Creates a ray from two points
  #
  # @param point1 [Geo2d::Point] the origin point
  # @param point2 [Geo2d::Point] any point on the ray (different from origin)
  # @return [Ray] a new ray pointing from point1 through point2
  # @raise [ArgumentError] if points are not distinct or not Point objects
  def self.from_points(point1, point2)
    raise ArgumentError, 'Both arguments must be Point' unless point1.is_a?(Geo2d::Point) && point2.is_a?(Geo2d::Point)
    raise ArgumentError, 'Points must be distinct' if point1 == point2

    dx = point2.x - point1.x
    dy = point2.y - point1.y
    radians = Math.atan2(dy, dx)
    angle = Angle.new(radians)

    new(point1, angle)
  end

  # Returns the unit direction vector of the ray
  #
  # @return [Geo2d::Point] unit vector representing direction
  def direction_vector
    x = Math.cos(direction_angle.radians)
    y = Math.sin(direction_angle.radians)
    Geo2d::Point.new(x, y)
  end

  # Returns a point on the ray at the given distance from origin
  #
  # @param distance [Float] non-negative distance from origin
  # @return [Geo2d::Point] point at the specified distance
  # @raise [ArgumentError] if distance is negative
  def point_at(distance)
    raise ArgumentError, 'Distance must be non-negative' if distance.negative?

    vector = direction_vector
    x = origin.x + (vector.x * distance)
    y = origin.y + (vector.y * distance)
    Geo2d::Point.new(x, y)
  end

  # rubocop:disable Metrics/AbcSize
  # Checks if a point lies on the ray
  #
  # @param point [Geo2d::Point] the point to check
  # @return [Boolean] true if point is on the ray
  def contains_point?(point)
    return false unless point.is_a?(Geo2d::Point)

    dx = point.x - origin.x
    dy = point.y - origin.y

    return true if dx.abs < 1e-10 && dy.abs < 1e-10

    point_angle = Math.atan2(dy, dx)
    point_angle += 2 * Math::PI if point_angle.negative?

    ray_angle = direction_angle.radians

    angle_diff = (point_angle - ray_angle).abs
    angle_diff = (2 * Math::PI) - angle_diff if angle_diff > Math::PI

    return false unless angle_diff < 1e-10

    dir_vector = direction_vector
    dot_product = (dx * dir_vector.x) + (dy * dir_vector.y)

    dot_product > -1e-10
  end
  # rubocop:enable Metrics/AbcSize

  # Checks if two rays are parallel
  #
  # @param other [Ray] the other ray to compare
  # @return [Boolean] true if rays are parallel
  def parallel?(other)
    return false unless other.is_a?(Ray)

    angle1 = direction_angle.radians
    angle2 = other.direction_angle.radians

    diff = (angle1 - angle2).abs
    diff = (2 * Math::PI) - diff if diff > Math::PI

    diff < 1e-10 || (diff - Math::PI).abs < 1e-10
  end

  # Checks if two rays are perpendicular
  #
  # @param other [Ray] the other ray to compare
  # @return [Boolean] true if rays are perpendicular
  def perpendicular?(other)
    return false unless other.is_a?(Ray)

    angle1 = direction_angle.radians
    angle2 = other.direction_angle.radians

    diff = (angle1 - angle2).abs
    diff = (2 * Math::PI) - diff if diff > Math::PI

    (diff - (Math::PI / 2)).abs < 1e-10
  end

  # Compares two rays for equality
  #
  # @param other [Ray] the other ray to compare
  # @return [Boolean] true if rays have same origin and direction
  def ==(other)
    return false unless other.is_a?(Ray)

    origin == other.origin && direction_angle == other.direction_angle
  end
end
