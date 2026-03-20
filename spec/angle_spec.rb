# frozen_string_literal: true

require_relative '../lib/geo2d/angle'

describe Angle do
  # 1. CONSTRUCTORS
  describe '#initialize' do
    it 'creates an angle with radians' do
      angle = Angle.new(Math::PI)
      expect(angle.radians).to eq(Math::PI)
    end

    it 'normalizes angle to [0, 2π)' do
      angle1 = Angle.new(3 * Math::PI)
      angle2 = Angle.new(-Math::PI / 2)
      expect(angle1.radians).to be_within(1e-10).of(Math::PI)
      expect(angle2.radians).to be_within(1e-10).of(3 * Math::PI / 2)
    end
  end

  describe '.from_degrees' do
    it 'creates an angle from degrees' do
      angle = Angle.from_degrees(180)
      expect(angle.radians).to be_within(1e-10).of(Math::PI)
    end

    it 'normalizes degrees greater than 360' do
      angle = Angle.from_degrees(540)
      expect(angle.radians).to be_within(1e-10).of(Math::PI)
    end

    it 'normalizes negative degrees' do
      angle = Angle.from_degrees(-90)
      expect(angle.radians).to be_within(1e-10).of(3 * Math::PI / 2)
    end
  end

  # 2. PROPERTIES
  describe '#degrees' do
    it 'returns angle in degrees' do
      angle = Angle.new(Math::PI / 2)
      expect(angle.degrees).to be_within(1e-10).of(90)
    end

    it 'returns normalized value for angles greater than 360 degrees' do
      angle = Angle.from_degrees(450)
      expect(angle.degrees).to be_within(1e-10).of(90)
    end
  end

  # 3. PREDICATES
  describe '#acute?' do
    it 'returns true for acute angle less than 90 degrees' do
      expect(Angle.new(Math::PI / 4)).to be_acute
    end

    it 'returns false for right angle' do
      expect(Angle.new(Math::PI / 2)).not_to be_acute
    end

    it 'returns false for obtuse angle' do
      expect(Angle.new(3 * Math::PI / 4)).not_to be_acute
    end
  end

  describe '#right?' do
    it 'returns true for right angle of 90 degrees' do
      expect(Angle.new(Math::PI / 2)).to be_right
    end

    it 'returns false for acute angle' do
      expect(Angle.new(Math::PI / 4)).not_to be_right
    end

    it 'returns false for obtuse angle' do
      expect(Angle.new(3 * Math::PI / 4)).not_to be_right
    end
  end

  describe '#obtuse?' do
    it 'returns true for obtuse angle between 90 and 180 degrees' do
      expect(Angle.new(3 * Math::PI / 4)).to be_obtuse
    end

    it 'returns false for acute angle' do
      expect(Angle.new(Math::PI / 4)).not_to be_obtuse
    end

    it 'returns false for right angle' do
      expect(Angle.new(Math::PI / 2)).not_to be_obtuse
    end
  end

  describe '#straight?' do
    it 'returns true for straight angle of 180 degrees' do
      expect(Angle.new(Math::PI)).to be_straight
    end

    it 'returns false for other angles' do
      expect(Angle.new(Math::PI / 2)).not_to be_straight
    end
  end

  describe '#reflex?' do
    it 'returns true for reflex angle greater than 180 degrees' do
      expect(Angle.new(5 * Math::PI / 4)).to be_reflex
    end

    it 'returns false for angle less than or equal to 180 degrees' do
      expect(Angle.new(Math::PI)).not_to be_reflex
    end
  end

  # 4. EDGE CASES
  describe 'angle comparison' do
    it 'considers angles equal within epsilon tolerance' do
      angle1 = Angle.new(Math::PI / 2)
      angle2 = Angle.new((Math::PI / 2) + 1e-11)
      expect(angle1).to eq(angle2)
    end

    it 'considers different angles unequal' do
      angle1 = Angle.new(Math::PI / 4)
      angle2 = Angle.new(Math::PI / 2)
      expect(angle1).not_to eq(angle2)
    end
  end

  describe 'normalization of large angles' do
    it 'normalizes 720 degrees to 0 degrees' do
      angle = Angle.from_degrees(720)
      expect(angle.degrees).to be_within(1e-10).of(0)
    end

    it 'normalizes -360 degrees to 0 degrees' do
      angle = Angle.from_degrees(-360)
      expect(angle.degrees).to be_within(1e-10).of(0)
    end
  end
end
