# frozen_string_literal: true

require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/angle'
require_relative '../lib/geo2d/ray'

describe Ray do
  # 1. CONSTRUCTORS
  describe '#initialize' do
    it 'creates a ray from point and angle' do
      origin = Geo2d::Point.new(0, 0)
      angle = Angle.new(Math::PI / 4)
      ray = Ray.new(origin, angle)

      expect(ray.origin).to eq(origin)
      expect(ray.direction_angle).to eq(angle)
    end

    it 'raises error when origin is not a Point' do
      expect { Ray.new([0, 0], Angle.new(0)) }.to raise_error(ArgumentError, /must be a Point/)
    end

    it 'raises error when angle is not an Angle' do
      expect { Ray.new(Geo2d::Point.new(0, 0), 45) }.to raise_error(ArgumentError, /must be an Angle/)
    end
  end

  describe '.from_points' do
    it 'creates a ray from two points' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(3, 3)
      ray = Ray.from_points(point1, point2)

      expect(ray.origin).to eq(point1)
      expect(ray.direction_angle.radians).to be_within(1e-10).of(Math::PI / 4)
    end

    it 'raises error when points are identical' do
      point = Geo2d::Point.new(1, 1)
      expect { Ray.from_points(point, point) }.to raise_error(ArgumentError, /must be distinct/)
    end

    it 'raises error when arguments are not Points' do
      expect { Ray.from_points([0, 0], Geo2d::Point.new(1, 1)) }.to raise_error(ArgumentError, /must be Point/)
    end
  end

  # 2. PROPERTIES
  describe '#point_at' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:angle) { Angle.from_degrees(45) }
    let(:ray) { Ray.new(origin, angle) }

    it 'returns a point at the given distance' do
      point = ray.point_at(Math.sqrt(2))
      expect(point.x).to be_within(1e-10).of(1)
      expect(point.y).to be_within(1e-10).of(1)
    end

    it 'returns the origin point when distance is zero' do
      point = ray.point_at(0)
      expect(point).to eq(origin)
    end

    it 'raises error when distance is negative' do
      expect { ray.point_at(-5) }.to raise_error(ArgumentError, /Distance must be non-negative/)
    end
  end

  describe '#direction_vector' do
    let(:origin) { Geo2d::Point.new(0, 0) }

    it 'returns a unit direction vector' do
      angle = Angle.from_degrees(90)
      ray = Ray.new(origin, angle)
      vector = ray.direction_vector

      expect(vector.x).to be_within(1e-10).of(0)
      expect(vector.y).to be_within(1e-10).of(1)
    end

    it 'returns a vector of length 1' do
      angle = Angle.from_degrees(30)
      ray = Ray.new(origin, angle)
      vector = ray.direction_vector

      length = Math.sqrt((vector.x**2) + (vector.y**2))
      expect(length).to be_within(1e-10).of(1)
    end
  end

  # 3. PREDICATES
  describe '#contains_point?' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:angle) { Angle.from_degrees(45) }
    let(:ray) { Ray.new(origin, angle) }

    it 'returns true for a point on the ray' do
      point = Geo2d::Point.new(2, 2)
      expect(ray.contains_point?(point)).to eq(true)
    end

    it 'returns true for the origin point' do
      expect(ray.contains_point?(origin)).to eq(true)
    end

    it 'returns false for a point not on the ray' do
      point = Geo2d::Point.new(-1, 1)
      expect(ray.contains_point?(point)).to eq(false)
    end

    it 'returns false for a point in the direction but before the origin' do
      point = Geo2d::Point.new(-2, -2)
      expect(ray.contains_point?(point)).to eq(false)
    end

    it 'returns false for a point with correct direction but offset' do
      point = Geo2d::Point.new(2, 3)
      expect(ray.contains_point?(point)).to eq(false)
    end
  end

  describe '#parallel?' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:angle) { Angle.from_degrees(45) }
    let(:ray1) { Ray.new(origin, angle) }

    it 'returns true for rays with same direction' do
      ray2 = Ray.new(Geo2d::Point.new(5, 5), Angle.from_degrees(45))
      expect(ray1.parallel?(ray2)).to eq(true)
    end

    it 'returns true for rays with opposite direction' do
      ray2 = Ray.new(Geo2d::Point.new(5, 5), Angle.from_degrees(225))
      expect(ray1.parallel?(ray2)).to eq(true)
    end

    it 'returns false for rays with different direction' do
      ray2 = Ray.new(Geo2d::Point.new(5, 5), Angle.from_degrees(90))
      expect(ray1.parallel?(ray2)).to eq(false)
    end
  end

  describe '#perpendicular?' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:ray1) { Ray.new(origin, Angle.from_degrees(45)) }

    it 'returns true for perpendicular ray' do
      ray2 = Ray.new(origin, Angle.from_degrees(135))
      expect(ray1.perpendicular?(ray2)).to eq(true)
    end

    it 'returns false for non-perpendicular ray' do
      ray2 = Ray.new(origin, Angle.from_degrees(60))
      expect(ray1.perpendicular?(ray2)).to eq(false)
    end
  end

  # 4. EDGE CASES
  describe 'horizontal ray' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:ray) { Ray.new(origin, Angle.from_degrees(0)) }

    it 'correctly finds points' do
      point = ray.point_at(5)
      expect(point.x).to eq(5)
      expect(point.y).to eq(0)
    end

    it 'correctly checks point membership' do
      expect(ray.contains_point?(Geo2d::Point.new(10, 0))).to eq(true)
      expect(ray.contains_point?(Geo2d::Point.new(10, 1))).to eq(false)
    end
  end

  describe 'vertical ray' do
    let(:origin) { Geo2d::Point.new(0, 0) }
    let(:ray) { Ray.new(origin, Angle.from_degrees(90)) }

    it 'correctly finds points' do
      point = ray.point_at(5)
      expect(point.x).to be_within(1e-10).of(0)
      expect(point.y).to be_within(1e-10).of(5)
    end

    it 'correctly checks point membership' do
      expect(ray.contains_point?(Geo2d::Point.new(0, 10))).to eq(true)
      expect(ray.contains_point?(Geo2d::Point.new(1, 10))).to eq(false)
    end
  end
end
