# frozen_string_literal: true

require_relative '../lib/geo2d/isosceles_triangle'

RSpec.describe Geo2d::IsoscelesTriangle do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(4, 0) }
  let(:p3) { Geo2d::Point.new(2, 3) }      # равнобедренный
  let(:p4) { Geo2d::Point.new(1, 1) }      # разносторонний

  # 1. CONSTRUCTORS
  describe '#initialize' do
    it 'creates an isosceles triangle from three points' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      expect(triangle.vertices_count).to eq(3)
    end

    it 'raises error when triangle is not isosceles' do
      expect { Geo2d::IsoscelesTriangle.new(p1, p2, p4) }
        .to raise_error(ArgumentError, /not isosceles/)
    end

    it 'raises error for collinear points' do
      collinear1 = Geo2d::Point.new(0, 0)
      collinear2 = Geo2d::Point.new(1, 1)
      collinear3 = Geo2d::Point.new(2, 2)
      expect { Geo2d::IsoscelesTriangle.new(collinear1, collinear2, collinear3) }
        .to raise_error(ArgumentError, /collinear/)
    end

    it 'raises error for duplicate points' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::IsoscelesTriangle.new(same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end

  # 2. PROPERTIES
  describe '#isosceles?' do
    it 'returns true for isosceles triangle' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      expect(triangle.isosceles?).to be(true)
    end
  end

  describe '#equal_sides' do
    it 'returns the two equal sides' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      equal_sides = triangle.equal_sides
      expect(equal_sides.size).to eq(2)
      expect(equal_sides[0]).to be_within(1e-10).of(equal_sides[1])
    end
  end

  describe '#base' do
    it 'returns the base side length' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      expect(triangle.base).to be_within(1e-10).of(4.0)
    end
  end

  describe '#base_angles' do
    it 'returns the two equal base angles' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      angles = triangle.base_angles
      expect(angles.size).to eq(2)
      expect(angles[0]).to eq(angles[1])
    end
  end

  describe '#vertex_angle' do
    it 'returns the vertex angle between equal sides' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      vertex = triangle.vertex_angle
      expect(vertex).to be_a(Angle)
    end
  end

  # 3. PREDICATES
  describe '#valid?' do
    it 'returns true for valid isosceles triangle' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      expect(triangle.valid?).to be(true)
    end
  end

  describe '#equilateral?' do
    it 'returns false for non-equilateral isosceles triangle' do
      triangle = Geo2d::IsoscelesTriangle.new(p1, p2, p3)
      expect(triangle.equilateral?).to be(false)
    end
  end

  # 4. EDGE CASES
  describe 'degenerate isosceles triangle' do
    it 'raises error when base is zero' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(0, 0)
      c = Geo2d::Point.new(2, 3)
      expect { Geo2d::IsoscelesTriangle.new(a, b, c) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end
end
