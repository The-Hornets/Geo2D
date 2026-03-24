# frozen_string_literal: true

require_relative '../lib/geo2d/triangle'

describe Geo2d::Triangle do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(4, 0) }
  let(:p3) { Geo2d::Point.new(0, 3) }

  describe '#initialize' do
    it 'создаёт треугольник с тремя вершинами' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.vertices_count).to eq(3)
    end

    it 'вызывает ошибку при коллинеарных точках' do
      collinear1 = Geo2d::Point.new(0, 0)
      collinear2 = Geo2d::Point.new(1, 1)
      collinear3 = Geo2d::Point.new(2, 2)
      expect { Geo2d::Triangle.new(collinear1, collinear2, collinear3) }
        .to raise_error(ArgumentError, /collinear/)
    end

    it 'вызывает ошибку при совпадающих точках' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Triangle.new(same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end
  end

  describe '#area' do
    it 'вычисляет площадь прямоугольного треугольника 3-4-5' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.area).to eq(6.0)
    end

    it 'вычисляет площадь равностороннего треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(1, Math.sqrt(3))
      triangle = Geo2d::Triangle.new(a, b, c)
      expect(triangle.area).to be_within(0.01).of(Math.sqrt(3))
    end
  end

  describe '#centroid' do
    it 'вычисляет центроид треугольника' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      centroid = triangle.centroid
      expect(centroid.x).to be_within(0.01).of(4.0 / 3)
      expect(centroid.y).to be_within(0.01).of(1.0)
    end
  end

  describe '#equilateral?' do
    it 'возвращает true для равностороннего треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(1, Math.sqrt(3))
      triangle = Geo2d::Triangle.new(a, b, c)
      expect(triangle.equilateral?).to be(true)
    end

    it 'возвращает false для неравностороннего треугольника' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.equilateral?).to be(false)
    end
  end

  describe '#isosceles?' do
    it 'возвращает true для равнобедренного треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(2, 3)
      triangle = Geo2d::Triangle.new(a, b, c)
      expect(triangle.isosceles?).to be(true)
    end

    it 'возвращает false для разностороннего треугольника' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.isosceles?).to be(false)
    end
  end

  describe '#right?' do
    it 'возвращает true для прямоугольного треугольника' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.right?).to be(true)
    end

    it 'возвращает false для непрямоугольного треугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(1, Math.sqrt(3))
      triangle = Geo2d::Triangle.new(a, b, c)
      expect(triangle.right?).to be(false)
    end
  end

  describe '#perimeter' do
    it 'вычисляет периметр треугольника 3-4-5' do
      triangle = Geo2d::Triangle.new(p1, p2, p3)
      expect(triangle.perimeter).to eq(12)
    end
  end
end
