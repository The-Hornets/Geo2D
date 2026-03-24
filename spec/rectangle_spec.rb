# frozen_string_literal: true

require_relative '../lib/geo2d/rectangle'

describe Geo2d::Rectangle do
  # 1. КОНСТРУКТОРЫ
  describe '.from_points' do
    let(:p1) { Geo2d::Point.new(0, 0) }
    let(:p2) { Geo2d::Point.new(4, 0) }
    let(:p3) { Geo2d::Point.new(4, 3) }
    let(:p4) { Geo2d::Point.new(0, 3) }

    it 'создаёт прямоугольник из 4 точек' do
      rect = Geo2d::Rectangle.from_points(p1, p2, p3, p4)
      expect(rect).to be_a(Geo2d::Rectangle)
    end

    it 'создаёт квадрат' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(0, 2)
      rect = Geo2d::Rectangle.from_points(a, b, c, d)
      expect(rect.valid?).to be(true)
    end

    it 'вызывает ошибку для точек, не образующих прямоугольник' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(5, 3)
      d = Geo2d::Point.new(1, 3)
      expect { Geo2d::Rectangle.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rectangle/)
    end

    it 'вызывает ошибку для ромба (не прямоугольник)' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(3, 1)
      d = Geo2d::Point.new(1, 1)
      expect { Geo2d::Rectangle.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rectangle/)
    end
  end

  describe '.from_sides' do
    it 'создаёт прямоугольник по ширине и высоте' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect).to be_a(Geo2d::Rectangle)
    end

    it 'создаёт квадрат' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.valid?).to be(true)
    end

    it 'вызывает ошибку при ширине <= 0' do
      expect { Geo2d::Rectangle.from_sides(0, 3) }
        .to raise_error(ArgumentError, /width|positive/)
      expect { Geo2d::Rectangle.from_sides(-1, 3) }
        .to raise_error(ArgumentError, /width|positive/)
    end

    it 'вызывает ошибку при высоте <= 0' do
      expect { Geo2d::Rectangle.from_sides(4, 0) }
        .to raise_error(ArgumentError, /height|positive/)
      expect { Geo2d::Rectangle.from_sides(4, -2) }
        .to raise_error(ArgumentError, /height|positive/)
    end
  end

  describe '.from_side_and_angle' do
    it 'создаёт прямоугольник при угле π/2' do
      rect = Geo2d::Rectangle.from_side_and_angle(4, 3, Math::PI / 2)
      expect(rect).to be_a(Geo2d::Rectangle)
    end

    it 'вызывает ошибку при угле != π/2' do
      expect { Geo2d::Rectangle.from_side_and_angle(4, 3, Math::PI / 4) }
        .to raise_error(ArgumentError, /angle|right/)
      expect { Geo2d::Rectangle.from_side_and_angle(4, 3, Math::PI / 3) }
        .to raise_error(ArgumentError, /angle|right/)
    end

    it 'вызывает ошибку при угле 0' do
      expect { Geo2d::Rectangle.from_side_and_angle(4, 3, 0) }
        .to raise_error(ArgumentError, /angle|right/)
    end

    it 'вызывает ошибку при угле π' do
      expect { Geo2d::Rectangle.from_side_and_angle(4, 3, Math::PI) }
        .to raise_error(ArgumentError, /angle|right/)
    end
  end

  # 2. СВОЙСТВА
  describe '#area' do
    it 'вычисляет площадь прямоугольника 4x3' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.area).to be_within(0.01).of(12.0)
    end

    it 'вычисляет площадь квадрата 5x5' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.area).to be_within(0.01).of(25.0)
    end

    it 'вычисляет площадь для прямоугольника 10x2' do
      rect = Geo2d::Rectangle.from_sides(10, 2)
      expect(rect.area).to be_within(0.01).of(20.0)
    end
  end

  describe '#perimeter' do
    it 'вычисляет периметр прямоугольника 4x3' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.perimeter).to be_within(0.01).of(14.0)
    end

    it 'вычисляет периметр квадрата 5x5' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.perimeter).to be_within(0.01).of(20.0)
    end

    it 'вычисляет периметр как 2*(width + height)' do
      rect = Geo2d::Rectangle.from_sides(10, 2)
      expect(rect.perimeter).to be_within(0.01).of(24.0)
    end
  end

  describe '#angles' do
    it 'возвращает 4 прямых угла' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      angles = rect.angles
      expect(angles.size).to eq(4)
      angles.each do |angle|
        expect(angle).to be_within(0.01).of(Math::PI / 2)
      end
    end

    it 'возвращает углы, сумма которых равна 2*PI' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      angles = rect.angles
      expect(angles.sum).to be_within(0.01).of(2 * Math::PI)
    end
  end

  describe '#width' do
    it 'возвращает ширину прямоугольника' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.width).to be_within(0.01).of(4.0)
    end

    it 'возвращает ширину для квадрата' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.width).to be_within(0.01).of(5.0)
    end
  end

  describe '#height' do
    it 'возвращает высоту прямоугольника' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.height).to be_within(0.01).of(3.0)
    end

    it 'возвращает высоту для квадрата' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.height).to be_within(0.01).of(5.0)
    end
  end

  describe '#side_lengths' do
    it 'возвращает стороны [width, height, width, height]' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      sides = rect.side_lengths
      expect(sides).to eq([4.0, 3.0, 4.0, 3.0])
    end

    it 'возвращает стороны для квадрата' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      sides = rect.side_lengths
      expect(sides).to eq([5.0, 5.0, 5.0, 5.0])
    end
  end

  describe '#angle_between_sides' do
    it 'возвращает π/2' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.angle_between_sides).to be_within(0.01).of(Math::PI / 2)
    end

    it 'возвращает π/2 для квадрата' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.angle_between_sides).to be_within(0.01).of(Math::PI / 2)
    end
  end

  # 3. ПРЕДИКАТЫ
  describe '#contains_point?' do
    let(:rect) { Geo2d::Rectangle.from_sides(4, 3) }

    it 'возвращает true для точки внутри' do
      point = Geo2d::Point.new(2, 1.5)
      expect(rect.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки на границе' do
      point = Geo2d::Point.new(2, 0)
      expect(rect.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки в вершине' do
      point = Geo2d::Point.new(0, 0)
      expect(rect.contains_point?(point)).to be(true)
    end

    it 'возвращает false для точки снаружи' do
      point = Geo2d::Point.new(5, 5)
      expect(rect.contains_point?(point)).to be(false)
    end

    it 'возвращает false для точки далеко снаружи' do
      point = Geo2d::Point.new(-10, -10)
      expect(rect.contains_point?(point)).to be(false)
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного прямоугольника' do
      rect = Geo2d::Rectangle.from_sides(4, 3)
      expect(rect.valid?).to be(true)
    end

    it 'возвращает true для квадрата' do
      rect = Geo2d::Rectangle.from_sides(5, 5)
      expect(rect.valid?).to be(true)
    end
  end

  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  describe 'invalid input' do
    it 'вызывает ошибку для параллелограмма (не прямоугольник)' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(5, 3)
      d = Geo2d::Point.new(1, 3)
      expect { Geo2d::Rectangle.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rectangle/)
    end

    it 'вызывает ошибку для коллинеарных точек' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 1)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(3, 3)
      expect { Geo2d::Rectangle.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rectangle|area|convex/)
    end

    it 'вызывает ошибку при совпадающих точках' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Rectangle.from_points(same_point, same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end

    it 'вызывает ошибку при нулевой площади' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      c = Geo2d::Point.new(2, 0)
      d = Geo2d::Point.new(3, 0)
      expect { Geo2d::Rectangle.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /rectangle|area|convex/)
    end
  end
end
