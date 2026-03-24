# frozen_string_literal: true

require_relative '../lib/geo2d/circle'
require_relative '../lib/geo2d/point'

RSpec.describe Geo2d::Circle do
  let(:center) { Geo2d::Point.new(0, 0) }
  let(:radius) { 5.0 }
  let(:circle) { Geo2d::Circle.new(center, radius) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт окружность с заданным центром и радиусом' do
      expect(circle.center).to eq(center)
      expect(circle.radius).to eq(5.0)
    end

    it 'выбрасывает ArgumentError, если центр не Point' do
      expect { Geo2d::Circle.new([0, 0], radius) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError, если радиус ≤ 0' do
      expect { Geo2d::Circle.new(center, 0) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
      expect { Geo2d::Circle.new(center, -5) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe '.from_diameter' do
    it 'создаёт окружность по двум точкам диаметра' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(4, 0)
      circle = Geo2d::Circle.from_diameter(point1, point2)
      expect(circle.center.x).to eq(2.0)
      expect(circle.center.y).to eq(0.0)
      expect(circle.radius).to eq(2.0)
    end

    it 'выбрасывает ArgumentError, если точки совпадают' do
      point = Geo2d::Point.new(1, 1)
      expect { Geo2d::Circle.from_diameter(point, point) }
        .to raise_error(ArgumentError, /Точки диаметра не должны совпадать/)
    end
  end

  describe '.from_three_points' do
    it 'создаёт описанную окружность по трём точкам' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(4, 0)
      p3 = Geo2d::Point.new(0, 3)
      circle = Geo2d::Circle.from_three_points(p1, p2, p3)
      expect(circle.center.x).to be_within(Geo2d::Circle::EPSILON).of(2.0)
      expect(circle.center.y).to be_within(Geo2d::Circle::EPSILON).of(1.5)
      expect(circle.radius).to be_within(Geo2d::Circle::EPSILON).of(2.5)
    end

    it 'выбрасывает ArgumentError, если точки коллинеарны' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(1, 1)
      p3 = Geo2d::Point.new(2, 2)
      expect { Geo2d::Circle.from_three_points(p1, p2, p3) }
        .to raise_error(ArgumentError, /Точки не должны быть коллинеарны/)
    end

    it 'выбрасывает ArgumentError, если точки совпадают' do
      p = Geo2d::Point.new(1, 1)
      expect { Geo2d::Circle.from_three_points(p, p, Geo2d::Point.new(2, 2)) }
        .to raise_error(ArgumentError, /Точки не должны совпадать/)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА
  # ============================================================================

  describe '#center' do
    it 'возвращает центр окружности' do
      expect(circle.center).to eq(center)
    end
  end

  describe '#radius' do
    it 'возвращает радиус окружности' do
      expect(circle.radius).to eq(5.0)
    end
  end

  describe '#diameter' do
    it 'возвращает удвоенный радиус' do
      expect(circle.diameter).to eq(10.0)
    end
  end

  describe '#area' do
    it 'возвращает площадь круга π * r²' do
      expect(circle.area).to be_within(Geo2d::Circle::EPSILON).of(Math::PI * 25)
    end
  end

  describe '#circumference' do
    it 'возвращает длину окружности 2 * π * r' do
      expect(circle.circumference).to be_within(Geo2d::Circle::EPSILON).of(10 * Math::PI)
    end
  end

  describe '#perimeter' do
    it 'является алиасом для circumference' do
      expect(circle.method(:perimeter)).to eq(circle.method(:circumference))
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки на окружности' do
      point_on_circle = Geo2d::Point.new(5, 0)
      expect(circle.contains_point?(point_on_circle)).to be true
    end

    it 'возвращает false для точки не на окружности' do
      point_inside = Geo2d::Point.new(3, 0)
      expect(circle.contains_point?(point_inside)).to be false
    end
  end

  describe '#intersects_circle?' do
    it 'возвращает true для пересекающихся окружностей' do
      other_circle = Geo2d::Circle.new(Geo2d::Point.new(8, 0), 5.0)
      expect(circle.intersects_circle?(other_circle)).to be true
    end

    it 'возвращает false для непересекающихся окружностей' do
      far_circle = Geo2d::Circle.new(Geo2d::Point.new(20, 0), 3.0)
      expect(circle.intersects_circle?(far_circle)).to be false
    end
  end

  describe '#tangent_to_circle?' do
    it 'возвращает true для касающихся окружностей' do
      tangent_circle = Geo2d::Circle.new(Geo2d::Point.new(10, 0), 5.0)
      expect(circle.tangent_to_circle?(tangent_circle)).to be true
    end

    it 'возвращает false для некасающихся окружностей' do
      intersecting_circle = Geo2d::Circle.new(Geo2d::Point.new(8, 0), 5.0)
      expect(circle.tangent_to_circle?(intersecting_circle)).to be false
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидной окружности' do
      expect(circle.valid?).to be true
    end

    it 'возвращает false для невалидной окружности' do
      circle.instance_variable_set(:@radius, 0.0)
      expect(circle.valid?).to be false
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых окружностей' do
      same_circle = Geo2d::Circle.new(center, radius)
      expect(circle).to eq(same_circle)
    end

    it 'возвращает false для разных окружностей' do
      different_circle = Geo2d::Circle.new(Geo2d::Point.new(1, 1), 10.0)
      expect(circle).not_to eq(different_circle)
    end

    it 'учитывает погрешность при сравнении' do
      slightly_different = Geo2d::Circle.new(
        Geo2d::Point.new(Geo2d::Circle::EPSILON / 2, Geo2d::Circle::EPSILON / 2),
        radius + Geo2d::Circle::EPSILON / 2
      )
      expect(circle).to eq(slightly_different)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для невалидного центра в from_diameter' do
      expect { Geo2d::Circle.from_diameter([0, 0], Geo2d::Point.new(1, 1)) }
        .to raise_error(ArgumentError, /должны быть точками/)
    end

    it 'выбрасывает ArgumentError для невалидных точек в from_three_points' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(1, 1)
      expect { Geo2d::Circle.from_three_points(p1, p2, nil) }
        .to raise_error(ArgumentError, /должны быть точками/)
    end

    it 'выбрасывает ArgumentError для nil радиуса' do
      expect { Geo2d::Circle.new(center, nil) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает точки на границе EPSILON' do
      point_near_circle = Geo2d::Point.new(5 + Geo2d::Circle::EPSILON / 2, 0)
      expect(circle.contains_point?(point_near_circle)).to be true
    end

    it 'сравнивает окружности с учётом погрешности' do
      circle1 = Geo2d::Circle.new(center, 5.0)
      circle2 = Geo2d::Circle.new(center, 5.0 + Geo2d::Circle::EPSILON / 2)
      expect(circle1).to eq(circle2)
    end
  end

  describe 'large radius values' do
    it 'корректно работает с большими значениями радиуса' do
      large_circle = Geo2d::Circle.new(center, 1_000_000.0)
      expect(large_circle.diameter).to eq(2_000_000.0)
      expect(large_circle.area).to be_within(1).of(Math::PI * 1_000_000_000_000)
    end

    it 'корректно работает с очень малыми значениями радиуса' do
      small_circle = Geo2d::Circle.new(center, 0.0001)
      expect(small_circle.radius).to eq(0.0001)
      expect(small_circle.valid?).to be true
    end
  end
end
