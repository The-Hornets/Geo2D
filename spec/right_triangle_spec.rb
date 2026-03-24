# frozen_string_literal: true

require_relative '../lib/geo2d/right_triangle'

describe Geo2d::RightTriangle do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(4, 0) }
  let(:p3) { Geo2d::Point.new(0, 3) }

  describe '#initialize' do
    it 'создаёт прямоугольный треугольник' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.vertices_count).to eq(3)
    end

    it 'вызывает ошибку для непрямоугольного треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(1, Math.sqrt(3))
      expect { Geo2d::RightTriangle.new(a, b, c) }
        .to raise_error(ArgumentError, /right triangle/)
    end

    it 'вызывает ошибку при коллинеарных точках' do
      collinear1 = Geo2d::Point.new(0, 0)
      collinear2 = Geo2d::Point.new(1, 1)
      collinear3 = Geo2d::Point.new(2, 2)
      expect { Geo2d::RightTriangle.new(collinear1, collinear2, collinear3) }
        .to raise_error(ArgumentError, /collinear/)
    end
  end

  describe '#right?' do
    it 'всегда возвращает true для RightTriangle' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.right?).to be(true)
    end
  end

  describe '#hypotenuse' do
    it 'возвращает длину гипотенузы для треугольника 3-4-5' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.hypotenuse).to eq(5)
    end

    it 'возвращает длину гипотенузы для равнобедренного прямоугольного треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      c = Geo2d::Point.new(0, 1)
      triangle = Geo2d::RightTriangle.new(a, b, c)
      expect(triangle.hypotenuse).to be_within(0.01).of(Math.sqrt(2))
    end
  end

  describe '#legs' do
    it 'возвращает катеты для треугольника 3-4-5' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      legs = triangle.legs
      expect(legs.sort).to eq([3.0, 4.0])
    end
  end

  describe '#area' do
    it 'вычисляет площадь через катеты' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.area).to eq(6.0)
    end
  end

  describe '#equilateral?' do
    it 'всегда возвращает false для прямоугольного треугольника' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.equilateral?).to be(false)
    end
  end

  describe '#isosceles?' do
    it 'возвращает true для равнобедренного прямоугольного треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      c = Geo2d::Point.new(0, 1)
      triangle = Geo2d::RightTriangle.new(a, b, c)
      expect(triangle.isosceles?).to be(true)
    end

    it 'возвращает false для разностороннего прямоугольного треугольника' do
      triangle = Geo2d::RightTriangle.new(p1, p2, p3)
      expect(triangle.isosceles?).to be(false)
    end
  end
end
