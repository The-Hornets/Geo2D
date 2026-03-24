# frozen_string_literal: true

require_relative '../lib/geo2d/trapezoid'

RSpec.describe Geo2d::Trapezoid do
  # 1. CONSTRUCTORS
  describe '.from_points' do
    it 'creates a trapezoid from four points' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(4, 0)
      p3 = Geo2d::Point.new(3, 2)
      p4 = Geo2d::Point.new(1, 2)
      trapezoid = Geo2d::Trapezoid.from_points(p1, p2, p3, p4)
      expect(trapezoid.vertices_count).to eq(4)
    end

    it 'raises error when not a trapezoid' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(4, 3)
      d = Geo2d::Point.new(0, 3)
      expect { Geo2d::Trapezoid.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /trapezoid/)
    end

    it 'raises error for collinear points' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 1)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(3, 3)
      expect { Geo2d::Trapezoid.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /collinear|convex|trapezoid/)
    end

    it 'raises error for duplicate points' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Trapezoid.from_points(same_point, same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end

  describe '.from_bases_and_height' do
    it 'creates a trapezoid from bases and height' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid).to be_a(Geo2d::Trapezoid)
    end

    it 'creates a parallelogram when bases are equal' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(5, 5, 4)
      expect(trapezoid.valid?).to be(true)
    end

    it 'raises error when base1 <= 0' do
      expect { Geo2d::Trapezoid.from_bases_and_height(0, 4, 3) }
        .to raise_error(ArgumentError, /positive/)
      expect { Geo2d::Trapezoid.from_bases_and_height(-1, 4, 3) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'raises error when base2 <= 0' do
      expect { Geo2d::Trapezoid.from_bases_and_height(6, 0, 3) }
        .to raise_error(ArgumentError, /positive/)
      expect { Geo2d::Trapezoid.from_bases_and_height(6, -2, 3) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'raises error when height <= 0' do
      expect { Geo2d::Trapezoid.from_bases_and_height(6, 4, 0) }
        .to raise_error(ArgumentError, /positive/)
      expect { Geo2d::Trapezoid.from_bases_and_height(6, 4, -3) }
        .to raise_error(ArgumentError, /positive/)
    end
  end

  # 2. PROPERTIES
  describe '#area' do
    it 'calculates area as (a + b) * h / 2' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.area).to be_within(0.01).of(15.0)
    end
  end

  describe '#perimeter' do
    it 'returns sum of all sides' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.perimeter).to be > 0
    end
  end

  describe '#angles' do
    it 'returns four angles' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      angles = trapezoid.angles
      expect(angles.size).to eq(4)
      expect(angles.sum).to be_within(0.01).of(2 * Math::PI)
    end
  end

  describe '#bases' do
    it 'returns the two parallel sides' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      bases = trapezoid.bases
      expect(bases.size).to eq(2)
      expect(bases.sort.reverse).to eq([6.0, 4.0])
    end
  end

  describe '#height' do
    it 'returns the height' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.height).to be_within(0.01).of(3.0)
    end
  end

  describe '#legs' do
    it 'returns the non-parallel sides' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      legs = trapezoid.legs
      expect(legs.size).to eq(2)
    end
  end

  # 3. PREDICATES
  describe '#trapezoid?' do
    it 'returns true for trapezoid' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.trapezoid?).to be(true)
    end
  end

  describe '#isosceles?' do
    it 'returns false for non-isosceles trapezoid' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.isosceles?).to be(false)
    end
  end

  describe '#right?' do
    it 'returns false for non-right trapezoid' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.right?).to be(false)
    end
  end

  describe '#valid?' do
    it 'returns true for valid trapezoid' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(6, 4, 3)
      expect(trapezoid.valid?).to be(true)
    end
  end

  # 4. EDGE CASES
  describe 'degenerate trapezoid' do
    it 'raises error when height is zero' do
      expect { Geo2d::Trapezoid.from_bases_and_height(6, 4, 0) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'raises error when base1 equals base2 and no parallel check' do
      trapezoid = Geo2d::Trapezoid.from_bases_and_height(5, 5, 4)
      expect(trapezoid.valid?).to be(true)
    end
  end
end