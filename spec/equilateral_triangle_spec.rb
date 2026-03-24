# frozen_string_literal: true

require_relative '../lib/geo2d/equilateral_triangle'

RSpec.describe Geo2d::EquilateralTriangle do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(2, 0) }
  let(:p3) { Geo2d::Point.new(1, Math.sqrt(3)) }  # равносторонний
  let(:p4) { Geo2d::Point.new(2, 3) }             # не равносторонний

  # 1. CONSTRUCTORS
  describe '#initialize' do
    it 'creates an equilateral triangle from three points' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.vertices_count).to eq(3)
    end

    it 'raises error when triangle is not equilateral' do
      expect { Geo2d::EquilateralTriangle.new(p1, p2, p4) }
        .to raise_error(ArgumentError, /not equilateral/)
    end

    it 'raises error for collinear points' do
      collinear1 = Geo2d::Point.new(0, 0)
      collinear2 = Geo2d::Point.new(1, 1)
      collinear3 = Geo2d::Point.new(2, 2)
      expect { Geo2d::EquilateralTriangle.new(collinear1, collinear2, collinear3) }
        .to raise_error(ArgumentError, /collinear/)
    end

    it 'raises error for duplicate points' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::EquilateralTriangle.new(same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end

  # 2. PROPERTIES
  describe '#equilateral?' do
    it 'returns true for equilateral triangle' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.equilateral?).to be(true)
    end
  end

  describe '#isosceles?' do
    it 'returns true (equilateral is also isosceles)' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.isosceles?).to be(true)
    end
  end

  describe '#side_length' do
    it 'returns the common side length' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.side_length).to be_within(1e-10).of(2.0)
    end
  end

  describe '#angles' do
    it 'returns three equal angles of 60 degrees' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      angles = triangle.angles
      expect(angles.size).to eq(3)
      angles.each do |angle|
        expect(angle.degrees).to be_within(1e-10).of(60)
      end
    end
  end

  # 3. PREDICATES
  describe '#valid?' do
    it 'returns true for valid equilateral triangle' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.valid?).to be(true)
    end
  end

  describe '#right?' do
    it 'returns false for equilateral triangle' do
      triangle = Geo2d::EquilateralTriangle.new(p1, p2, p3)
      expect(triangle.right?).to be(false)
    end
  end

  # 4. EDGE CASES
  describe 'degenerate equilateral triangle' do
    it 'raises error when side length is zero' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(0, 0)
      c = Geo2d::Point.new(0, 0)
      expect { Geo2d::EquilateralTriangle.new(a, b, c) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end
end
