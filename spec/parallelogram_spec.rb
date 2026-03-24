# frozen_string_literal: true

require_relative '../lib/geo2d/parallelogram'

describe Geo2d::Parallelogram do
  # 1. КОНСТРУКТОРЫ
  describe '.from_points' do
    let(:p1) { Geo2d::Point.new(0, 0) }
    let(:p2) { Geo2d::Point.new(4, 0) }
    let(:p3) { Geo2d::Point.new(5, 3) }
    let(:p4) { Geo2d::Point.new(1, 3) }

    it 'создаёт параллелограмм из 4 точек' do
      para = Geo2d::Parallelogram.from_points(p1, p2, p3, p4)
      expect(para).to be_a(Geo2d::Parallelogram)
    end

    it 'создаёт прямоугольник' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(4, 3)
      d = Geo2d::Point.new(0, 3)
      para = Geo2d::Parallelogram.from_points(a, b, c, d)
      expect(para.valid?).to be(true)
    end

    it 'создаёт ромб' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(2, 0)
      c = Geo2d::Point.new(3, 1)
      d = Geo2d::Point.new(1, 1)
      para = Geo2d::Parallelogram.from_points(a, b, c, d)
      expect(para.valid?).to be(true)
    end

    it 'вызывает ошибку для точек, не образующих параллелограмм' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(3, 3)
      d = Geo2d::Point.new(0, 3)
      expect { Geo2d::Parallelogram.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /parallelogram/)
    end
  end

  describe '.from_side_and_angle' do
    it 'создаёт параллелограмм по сторонам и углу' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      expect(para).to be_a(Geo2d::Parallelogram)
    end

    it 'создаёт параллелограмм с острым углом' do
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, Math::PI / 4)
      expect(para.valid?).to be(true)
    end

    it 'вызывает ошибку при стороне <= 0' do
      expect { Geo2d::Parallelogram.from_side_and_angle(0, 3, Math::PI / 2) }
        .to raise_error(ArgumentError, /positive/)
      expect { Geo2d::Parallelogram.from_side_and_angle(-1, 3, Math::PI / 2) }
        .to raise_error(ArgumentError, /positive/)
    end

    it 'вызывает ошибку при угле вне диапазона (0, π)' do
      expect { Geo2d::Parallelogram.from_side_and_angle(4, 3, 0) }
        .to raise_error(ArgumentError, /range/)
      expect { Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI) }
        .to raise_error(ArgumentError, /range/)
      expect { Geo2d::Parallelogram.from_side_and_angle(4, 3, -Math::PI / 2) }
        .to raise_error(ArgumentError, /range/)
      expect { Geo2d::Parallelogram.from_side_and_angle(4, 3, 2 * Math::PI) }
        .to raise_error(ArgumentError, /range/)
    end
  end

  # 2. СВОЙСТВА
  describe '#area' do
    it 'вычисляет площадь прямоугольника 4x3' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      expect(para.area).to be_within(0.01).of(12.0)
    end

    it 'вычисляет площадь через a * b * sin(angle)' do
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, Math::PI / 6)
      expected_area = 5 * 4 * Math.sin(Math::PI / 6)
      expect(para.area).to be_within(0.01).of(expected_area)
    end

    it 'вычисляет площадь ромба со стороной 2 и углом 60°' do
      para = Geo2d::Parallelogram.from_side_and_angle(2, 2, Math::PI / 3)
      expected_area = 2 * 2 * Math.sin(Math::PI / 3)
      expect(para.area).to be_within(0.01).of(expected_area)
    end
  end

  describe '#perimeter' do
    it 'вычисляет периметр прямоугольника 4x3' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      expect(para.perimeter).to be_within(0.01).of(14.0)
    end

    it 'вычисляет периметр как 2*(a+b)' do
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, Math::PI / 4)
      expect(para.perimeter).to be_within(0.01).of(18.0)
    end
  end

  describe '#angles' do
    it 'возвращает углы прямоугольника [π/2, π/2, π/2, π/2]' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      angles = para.angles
      expect(angles.size).to eq(4)
      angles.each do |angle|
        expect(angle).to be_within(0.01).of(Math::PI / 2)
      end
    end

    it 'возвращает углы [angle, π-angle, angle, π-angle]' do
      angle = Math::PI / 4
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, angle)
      angles = para.angles
      expect(angles[0]).to be_within(0.01).of(angle)
      expect(angles[1]).to be_within(0.01).of(Math::PI - angle)
      expect(angles[2]).to be_within(0.01).of(angle)
      expect(angles[3]).to be_within(0.01).of(Math::PI - angle)
    end

    it 'возвращает углы, сумма которых равна 2*PI' do
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, Math::PI / 3)
      angles = para.angles
      expect(angles.sum).to be_within(0.01).of(2 * Math::PI)
    end
  end

  describe '#side_lengths' do
    it 'возвращает стороны прямоугольника [4, 3, 4, 3]' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      sides = para.side_lengths
      expect(sides).to eq([4.0, 3.0, 4.0, 3.0])
    end

    it 'возвращает стороны в порядке обхода [a, b, a, b]' do
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, Math::PI / 4)
      sides = para.side_lengths
      expect(sides[0]).to be_within(0.01).of(5.0)
      expect(sides[1]).to be_within(0.01).of(4.0)
      expect(sides[2]).to be_within(0.01).of(5.0)
      expect(sides[3]).to be_within(0.01).of(4.0)
    end
  end

  describe '#angle_between_sides' do
    it 'возвращает угол π/2 для прямоугольника' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      expect(para.angle_between_sides).to be_within(0.01).of(Math::PI / 2)
    end

    it 'возвращает угол, переданный при создании' do
      angle = Math::PI / 6
      para = Geo2d::Parallelogram.from_side_and_angle(5, 4, angle)
      expect(para.angle_between_sides).to be_within(0.01).of(angle)
    end
  end

  # 3. ПРЕДИКАТЫ
  describe '#contains_point?' do
    let(:para) { Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2) }

    it 'возвращает true для точки внутри' do
      point = Geo2d::Point.new(2, 1.5)
      expect(para.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки на границе' do
      point = Geo2d::Point.new(2, 0)
      expect(para.contains_point?(point)).to be(true)
    end

    it 'возвращает true для точки в вершине' do
      point = Geo2d::Point.new(0, 0)
      expect(para.contains_point?(point)).to be(true)
    end

    it 'возвращает false для точки снаружи' do
      point = Geo2d::Point.new(5, 5)
      expect(para.contains_point?(point)).to be(false)
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного параллелограмма' do
      para = Geo2d::Parallelogram.from_side_and_angle(4, 3, Math::PI / 2)
      expect(para.valid?).to be(true)
    end

    it 'возвращает true для ромба' do
      para = Geo2d::Parallelogram.from_side_and_angle(2, 2, Math::PI / 3)
      expect(para.valid?).to be(true)
    end
  end

  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  describe 'invalid input' do
    it 'вызывает ошибку для точек, образующих трапецию' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(4, 0)
      c = Geo2d::Point.new(3, 3)
      d = Geo2d::Point.new(1, 3)
      expect { Geo2d::Parallelogram.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /parallelogram/)
    end

    it 'вызывает ошибку для коллинеарных точек' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 1)
      c = Geo2d::Point.new(2, 2)
      d = Geo2d::Point.new(3, 3)
      expect { Geo2d::Parallelogram.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /parallelogram|area|convex/)
    end

    it 'вызывает ошибку при совпадающих точках' do
      same_point = Geo2d::Point.new(5, 5)
      expect { Geo2d::Parallelogram.from_points(same_point, same_point, same_point, same_point) }
        .to raise_error(ArgumentError, /Duplicate/)
    end

    it 'вызывает ошибку при нулевой площади' do
      a = Geo2d::Point.new(0, 0)
      b = Geo2d::Point.new(1, 0)
      c = Geo2d::Point.new(2, 0)
      d = Geo2d::Point.new(3, 0)
      expect { Geo2d::Parallelogram.from_points(a, b, c, d) }
        .to raise_error(ArgumentError, /parallelogram|area|convex/)
    end
  end
end
