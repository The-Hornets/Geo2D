# frozen_string_literal: true

require_relative '../lib/geo2d/rhombus'

RSpec.describe Geo2d::Rhombus do
  # 1. CONSTRUCTORS
  describe '.from_points' do
    it 'creates a rhombus from four points' do
      # Ромб со стороной 2 и углом 60 градусов
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(2, 0)
      p3 = Geo2d::Point.new(3, 1.7320508075688772)
      p4 = Geo2d::Point.new(1, 1.7320508075688772)
      rhombus = Geo2d::Rhombus.from_points(p1, p2, p3, p4)
      expect(rhombus.vertices_count).to eq(4)
    end

    it 'raises error when not a rhombus' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(4, 3)
      d = Geo2d::Point.new(0, 3)
      expect { Geo2d::Rhombus.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rhombus/)
    end

    it 'raises error for collinear points' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 1)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(3, 3)
      expect { Geo2d::Rhombus.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /collinear|convex|rhombus/)
    end

    it 'raises error for duplicate points' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Rhombus.from_points(same_point, same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end

  describe '.from_side_and_angle' do
    it 'creates a rhombus from side length and angle' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus).to be_a(Geo2d::Rhombus)
    end

    it 'creates a square when angle is PI/2' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(4, Math::PI / 2)
      expect(rhombus.valid?).to be(true)
    end

    it 'raises error when side length <= 0' do
      expect { Geo2d::Rhombus.from_side_and_angle(0, Math::PI / 3) }
        .to raise_error(ArgumentError, /positive/)
      expect { Geo2d::Rhombus.from_side_and_angle(-1, Math::PI / 3) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'raises error when angle is out of range (0, PI)' do
      expect { Geo2d::Rhombus.from_side_and_angle(5, 0) }
        .to raise_error(ArgumentError, /range/)
      expect { Geo2d::Rhombus.from_side_and_angle(5, Math::PI) }
        .to raise_error(ArgumentError, /range/)
      expect { Geo2d::Rhombus.from_side_and_angle(5, -Math::PI / 2) }
        .to raise_error(ArgumentError, /range/)
    end
  end

  # 2. PROPERTIES
  describe '#side_length' do
    it 'returns the common side length' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus.side_length).to be_within(1e-10).of(5.0)
    end
  end

  describe '#area' do
    it 'calculates area as side^2 * sin(angle)' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 6)
      expected_area = 5 * 5 * Math.sin(Math::PI / 6)
      expect(rhombus.area).to be_within(0.01).of(expected_area)
    end

    it 'calculates area for square' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(4, Math::PI / 2)
      expect(rhombus.area).to be_within(0.01).of(16.0)
    end
  end

  describe '#perimeter' do
    it 'returns 4 * side_length' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus.perimeter).to be_within(0.01).of(20.0)
    end
  end

  describe '#angles' do
    it 'returns [angle, PI-angle, angle, PI-angle]' do
      angle = Math::PI / 4
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, angle)
      angles = rhombus.angles
      expect(angles.size).to eq(4)
      expect(angles[0]).to be_within(1e-10).of(angle)
      expect(angles[1]).to be_within(1e-10).of(Math::PI - angle)
      expect(angles[2]).to be_within(1e-10).of(angle)
      expect(angles[3]).to be_within(1e-10).of(Math::PI - angle)
    end

    it 'returns [PI/2, PI/2, PI/2, PI/2] for square' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(4, Math::PI / 2)
      angles = rhombus.angles
      angles.each do |angle|
        expect(angle).to be_within(1e-10).of(Math::PI / 2)
      end
    end
  end

  describe '#diagonals' do
    it 'returns lengths of both diagonals' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      d1, d2 = rhombus.diagonals
      a = 5
      angle = Math::PI / 3
      expected_d1 = a * Math.sqrt(2 + (2 * Math.cos(angle)))
      expected_d2 = a * Math.sqrt(2 - (2 * Math.cos(angle)))
      expect(d1).to be_within(0.01).of(expected_d1)
      expect(d2).to be_within(0.01).of(expected_d2)
    end
  end

  # 3. PREDICATES
  describe '#rhombus?' do
    it 'returns true for rhombus' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus.rhombus?).to be(true)
    end
  end

  describe '#square?' do
    it 'returns true for square' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(4, Math::PI / 2)
      expect(rhombus.square?).to be(true)
    end

    it 'returns false for non-square rhombus' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus.square?).to be(false)
    end
  end

  describe '#valid?' do
    it 'returns true for valid rhombus' do
      rhombus = Geo2d::Rhombus.from_side_and_angle(5, Math::PI / 3)
      expect(rhombus.valid?).to be(true)
    end
  end

  # 4. EDGE CASES
  describe 'degenerate rhombus' do
    it 'raises error for zero side length' do
      expect { Geo2d::Rhombus.from_side_and_angle(0, Math::PI / 3) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'raises error for angle 0' do
      expect { Geo2d::Rhombus.from_side_and_angle(5, 0) }
        .to raise_error(ArgumentError, /range/)
    end

    it 'raises error for angle PI' do
      expect { Geo2d::Rhombus.from_side_and_angle(5, Math::PI) }
        .to raise_error(ArgumentError, /range/)
    end
  end
end
