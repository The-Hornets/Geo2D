# frozen_string_literal: true

# Represents an angle with normalization to [0, 2π)
class Angle
  attr_reader :radians

  # Creates an angle in radians, normalized to [0, 2π)
  #
  # @param radians [Float] angle in radians
  # @return [Angle] new Angle instance
  def initialize(radians)
    @radians = radians % (2 * Math::PI)
  end

  # Creates an angle from degrees
  #
  # @param degrees [Float] angle in degrees
  # @return [Angle] new Angle instance
  def self.from_degrees(degrees)
    new(degrees * Math::PI / 180.0)
  end

  # Returns the angle in degrees
  #
  # @return [Float] angle in degrees
  def degrees
    radians * 180.0 / Math::PI
  end

  # Returns true if the angle is acute (< 90°)
  #
  # @return [Boolean]
  def acute?
    radians.positive? && radians < Math::PI / 2
  end

  # Returns true if the angle is right (90°)
  #
  # @return [Boolean]
  def right?
    (radians - (Math::PI / 2)).abs < 1e-10
  end

  # Returns true if the angle is obtuse (> 90° and < 180°)
  #
  # @return [Boolean]
  def obtuse?
    radians > Math::PI / 2 && radians < Math::PI
  end

  # Returns true if the angle is straight (180°)
  #
  # @return [Boolean]
  def straight?
    (radians - Math::PI).abs < 1e-10
  end

  # Returns true if the angle is reflex (> 180°)
  #
  # @return [Boolean]
  def reflex?
    radians > Math::PI
  end

  # Compares two angles with epsilon precision
  #
  # @param other [Angle] other angle to compare
  # @return [Boolean]
  def ==(other)
    return false unless other.is_a?(Angle)

    (radians - other.radians).abs < 1e-10
  end
end
