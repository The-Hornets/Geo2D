# frozen_string_literal: true

require_relative '../lib/geo2d/polygon'

describe Geo2d::Polygon do
  include Geo2d

  let(:subclass) { Class.new(Geo2d::Polygon) }
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(3, 0) }
  let(:p3) { Geo2d::Point.new(0, 4) }

  describe '#initialize' do
    it 'нельзя создать Polygon напрямую' do
      expect { Geo2d::Polygon.new([p1, p2, p3]) }.to raise_error(NotImplementedError)
    end

    it 'принимает валидный список точек' do
      expect { subclass.new([p1, p2, p3]) }.not_to raise_error
    end

    it 'все точки совпадают' do
      same_point = Geo2d::Point.new(5, 5)
      expect { subclass.new([same_point, same_point, same_point]) }
        .to raise_error(ArgumentError, /Duplicate vertices/)
    end

    it 'две точки совпадают' do
      pt1 = Geo2d::Point.new(0, 0)
      pt2 = Geo2d::Point.new(3, 0)
      expect { subclass.new([pt1, pt2, pt1]) }
        .to raise_error(ArgumentError, /Duplicate vertices/)
    end

    it 'точки коллинеарны' do
      collinear1 = Geo2d::Point.new(0, 0)
      collinear2 = Geo2d::Point.new(1, 0)
      collinear3 = Geo2d::Point.new(2, 0)
      expect { subclass.new([collinear1, collinear2, collinear3]) }
        .to raise_error(ArgumentError, /collinear/)
    end
  end
  describe '#vertices_count' do
    let(:vert1) { Geo2d::Point.new(0, 0) }
    let(:vert2) { Geo2d::Point.new(3, 0) }
    let(:vert3) { Geo2d::Point.new(0, 4) }
    let(:polygon) { subclass.new([vert1, vert2, vert3]) }

    it 'полигон инициализирован' do
      expect(polygon.vertices_count).to eq(3)
    end

    it 'четырёхугольник имеет 4 вершины' do
      quad = subclass.new([
                            Geo2d::Point.new(0, 0),
                            Geo2d::Point.new(4, 0),
                            Geo2d::Point.new(4, 3),
                            Geo2d::Point.new(0, 3)
                          ])
      expect(quad.vertices_count).to eq(4)
    end
  end

  describe '#perimeter' do
    let(:vert1) { Geo2d::Point.new(0, 0) }
    let(:vert2) { Geo2d::Point.new(3, 0) }
    let(:vert3) { Geo2d::Point.new(0, 4) }
    let(:polygon) { subclass.new([vert1, vert2, vert3]) }

    it 'периметр треугольника' do
      expect(polygon.perimeter).to eq(12)
    end

    it 'периметр прямоугольника 4x3' do
      rect = subclass.new([
                            Geo2d::Point.new(0, 0),
                            Geo2d::Point.new(4, 0),
                            Geo2d::Point.new(4, 3),
                            Geo2d::Point.new(0, 3)
                          ])
      expect(rect.perimeter).to eq(14)
    end

    it 'периметр квадрата со стороной 5' do
      square = subclass.new([
                              Geo2d::Point.new(0, 0),
                              Geo2d::Point.new(5, 0),
                              Geo2d::Point.new(5, 5),
                              Geo2d::Point.new(0, 5)
                            ])
      expect(square.perimeter).to eq(20)
    end
  end
end
