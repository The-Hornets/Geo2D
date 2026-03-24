# frozen_string_literal: true

require_relative '../lib/geo2d/quadrilateral'

describe Geo2d::Quadrilateral do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(4, 0) }
  let(:p3) { Geo2d::Point.new(4, 3) }
  let(:p4) { Geo2d::Point.new(0, 3) }

  # 1. КОНСТРУКТОРЫ
  describe '.from_points' do
    it 'создаёт четырёхугольник из 4 точек' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      expect(quad).to be_a(Geo2d::Quadrilateral)
    end

    it 'создаёт квадрат' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(0, 2)
      quad = Geo2d::Quadrilateral.from_points(a, b, c, d)
      expect(quad.valid?).to be(true)
    end

    it 'вызывает ошибку при менее чем 4 точках' do
      expect { Geo2d::Quadrilateral.from_points(p1, p2, p3) }
        .to raise_error(ArgumentError, /4 vertices/)
    end

    it 'вызывает ошибку при более чем 4 точках' do
      p5 = Geo2d::Point.new(5, 5)
      expect { Geo2d::Quadrilateral.from_points(p1, p2, p3, p4, p5) }
        .to raise_error(ArgumentError, /4 vertices/)
    end
  end

  # 2. СВОЙСТВА
  describe '#area' do
    it 'вычисляет площадь прямоугольника 4x3' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      expect(quad.area).to be_within(0.01).of(12.0)
    end

    it 'вычисляет площадь квадрата со стороной 2' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(0, 2)
      quad = Geo2d::Quadrilateral.from_points(a, b, c, d)
      expect(quad.area).to be_within(0.01).of(4.0)
    end

    it 'вычисляет площадь произвольного выпуклого четырёхугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(3, 3)
      d = Geo2d::Point.new(1, 2)
      quad = Geo2d::Quadrilateral.from_points(a, b, c, d)
      expect(quad.area).to be_within(0.01).of(7.5)
    end
  end

  describe '#perimeter' do
    it 'вычисляет периметр прямоугольника 4x3' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      expect(quad.perimeter).to be_within(0.01).of(14.0)
    end

    it 'вычисляет периметр квадрата со стороной 2' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(0, 2)
      quad = Geo2d::Quadrilateral.from_points(a, b, c, d)
      expect(quad.perimeter).to be_within(0.01).of(8.0)
    end
  end

  describe '#angles' do
    it 'возвращает 4 угла для прямоугольника' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      angles = quad.angles
      expect(angles.size).to eq(4)
      angles.each do |angle|
        expect(angle).to be_within(0.01).of(Math::PI / 2)
      end
    end

    it 'возвращает углы, сумма которых равна 2*PI' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      angles = quad.angles
      expect(angles.sum).to be_within(0.01).of(2 * Math::PI)
    end
  end

  # 3. ПРЕДИКАТЫ
  describe '#contains_point?' do
    let(:quad) { Geo2d::Quadrilateral.from_points(p1, p2, p3, p4) }

    it 'возвращает true для точки внутри четырёхугольника' do
      point = Geo2d::Point.new(2, 1.5)
      expect(quad.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки на границе' do
      point = Geo2d::Point.new(2, 0)
      expect(quad.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки в вершине' do
      expect(quad.contains_point?(p1)).to be(true)
    end

    it 'возвращает false для точки снаружи' do
      point = Geo2d::Point.new(5, 5)
      expect(quad.contains_point?(point)).to be(false)
    end

    it 'возвращает false для точки далеко снаружи' do
      point = Geo2d::Point.new(-10, -10)
      expect(quad.contains_point?(point)).to be(false)
    end
  end

  describe '#valid?' do
    it 'возвращает true для выпуклого четырёхугольника' do
      quad = Geo2d::Quadrilateral.from_points(p1, p2, p3, p4)
      expect(quad.valid?).to be(true)
    end

    it 'возвращает true для квадрата' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(0, 2)
      quad = Geo2d::Quadrilateral.from_points(a, b, c, d)
      expect(quad.valid?).to be(true)
    end
  end

  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  describe 'invalid input' do
    it 'вызывает ошибку для вогнутого четырёхугольника' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(2, 1)
      d = Geo2d::Point.new(0, 4)
      expect { Geo2d::Quadrilateral.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /convex/)
    end

    it 'вызывает ошибку для коллинеарных точек' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 1)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(3, 3)
      expect { Geo2d::Quadrilateral.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /collinear|area|convex/)
    end

    it 'вызывает ошибку при совпадающих точках' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Quadrilateral.from_points(same_point, same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end

    it 'вызывает ошибку при трёх совпадающих точках' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      expect { Geo2d::Quadrilateral.from_points(a, a, a, b) }
        .to raise_error(ArgumentError, /Duplicate/)
    end

    it 'вызывает ошибку при нулевой площади' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      c = Geo2d::Point.new(2, 0)
      d = Geo2d::Point.new(3, 0)
      expect { Geo2d::Quadrilateral.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /collinear|area/)
    end
  end
end
