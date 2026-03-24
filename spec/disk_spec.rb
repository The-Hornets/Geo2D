# frozen_string_literal: true

require_relative '../lib/geo2d/disk'
require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/circle'

RSpec.describe Geo2d::Disk do
  let(:center) { Geo2d::Point.new(0, 0) }
  let(:radius) { 5.0 }
  let(:disk) { Geo2d::Disk.new(center, radius) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт круг с заданным центром и радиусом' do
      expect(disk.center).to eq(center)
      expect(disk.radius).to eq(5.0)
    end

    it 'принимает целый радиус и преобразует в Float' do
      disk = Geo2d::Disk.new(center, 10)
      expect(disk.radius).to eq(10.0)
    end

    it 'выбрасывает ArgumentError, если центр не Point' do
      expect { Geo2d::Disk.new([0, 0], radius) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError, если радиус ≤ 0' do
      expect { Geo2d::Disk.new(center, 0) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
      expect { Geo2d::Disk.new(center, -5) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe '.from_diameter' do
    it 'создаёт круг по двум точкам диаметра' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(4, 0)
      disk = Geo2d::Disk.from_diameter(point1, point2)
      expect(disk.center.x).to eq(2.0)
      expect(disk.center.y).to eq(0.0)
      expect(disk.radius).to eq(2.0)
    end

    it 'работает с диагональным диаметром' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(6, 8)
      disk = Geo2d::Disk.from_diameter(point1, point2)
      expect(disk.center.x).to eq(3.0)
      expect(disk.center.y).to eq(4.0)
      expect(disk.radius).to eq(5.0)
    end

    it 'выбрасывает ArgumentError, если точки совпадают' do
      point = Geo2d::Point.new(1, 1)
      expect { Geo2d::Disk.from_diameter(point, point) }
        .to raise_error(ArgumentError, /Точки диаметра не должны совпадать/)
    end

    it 'выбрасывает ArgumentError, если аргументы не точки' do
      expect { Geo2d::Disk.from_diameter([0, 0], Geo2d::Point.new(1, 1)) }
        .to raise_error(ArgumentError, /должны быть точками/)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА
  # ============================================================================

  describe '#center' do
    it 'возвращает центр круга' do
      expect(disk.center).to eq(center)
    end
  end

  describe '#radius' do
    it 'возвращает радиус круга' do
      expect(disk.radius).to eq(5.0)
    end
  end

  describe '#diameter' do
    it 'возвращает удвоенный радиус' do
      expect(disk.diameter).to eq(10.0)
    end
  end

  describe '#area' do
    it 'возвращает площадь круга π * r²' do
      expect(disk.area).to be_within(Geo2d::Disk::EPSILON).of(Math::PI * 25)
    end
  end

  describe '#circumference' do
    it 'возвращает длину границы 2 * π * r' do
      expect(disk.circumference).to be_within(Geo2d::Disk::EPSILON).of(10 * Math::PI)
    end
  end

  describe '#perimeter' do
    it 'является алиасом для circumference' do
      expect(disk.method(:perimeter)).to eq(disk.method(:circumference))
    end
  end

  describe '#boundary' do
    it 'возвращает окружность как границу круга' do
      boundary = disk.boundary
      expect(boundary).to be_a(Geo2d::Circle)
      expect(boundary.center).to eq(disk.center)
      expect(boundary.radius).to eq(disk.radius)
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки внутри круга' do
      point_inside = Geo2d::Point.new(3, 0)
      expect(disk.contains_point?(point_inside)).to be true
    end

    it 'возвращает true для точки на границе круга' do
      point_on_boundary = Geo2d::Point.new(5, 0)
      expect(disk.contains_point?(point_on_boundary)).to be true
    end

    it 'возвращает true для центра круга' do
      expect(disk.contains_point?(center)).to be true
    end

    it 'возвращает false для точки вне круга' do
      point_outside = Geo2d::Point.new(6, 0)
      expect(disk.contains_point?(point_outside)).to be false
    end

    it 'выбрасывает ArgumentError, если аргумент не точка' do
      expect { disk.contains_point?([5, 0]) }
        .to raise_error(ArgumentError, /Аргумент должен быть точкой/)
    end
  end

  describe '#contains_circle?' do
    it 'возвращает true для окружности полностью внутри круга' do
      inner_circle = Geo2d::Circle.new(Geo2d::Point.new(0, 0), 2.0)
      expect(disk.contains_circle?(inner_circle)).to be true
    end

    it 'возвращает true для окружности на границе круга' do
      boundary_circle = Geo2d::Circle.new(Geo2d::Point.new(0, 0), 5.0)
      expect(disk.contains_circle?(boundary_circle)).to be true
    end

    it 'возвращает false для окружности частично вне круга' do
      outer_circle = Geo2d::Circle.new(Geo2d::Point.new(4, 0), 2.0)
      expect(disk.contains_circle?(outer_circle)).to be false
    end

    it 'выбрасывает ArgumentError, если аргумент не окружность' do
      expect { disk.contains_circle?(center) }
        .to raise_error(ArgumentError, /Аргумент должен быть окружностью/)
    end
  end

  describe '#contains_disk?' do
    it 'возвращает true для круга полностью внутри другого круга' do
      inner_disk = Geo2d::Disk.new(Geo2d::Point.new(0, 0), 2.0)
      expect(disk.contains_disk?(inner_disk)).to be true
    end

    it 'возвращает true для одинаковых кругов' do
      same_disk = Geo2d::Disk.new(center, 5.0)
      expect(disk.contains_disk?(same_disk)).to be true
    end

    it 'возвращает false для круга частично вне другого круга' do
      outer_disk = Geo2d::Disk.new(Geo2d::Point.new(4, 0), 2.0)
      expect(disk.contains_disk?(outer_disk)).to be false
    end

    it 'выбрасывает ArgumentError, если аргумент не Disk' do
      expect { disk.contains_disk?(center) }
        .to raise_error(ArgumentError, /Аргумент должен быть Disk/)
    end
  end

  describe '#intersects_disk?' do
    it 'возвращает true для пересекающихся кругов' do
      other_disk = Geo2d::Disk.new(Geo2d::Point.new(8, 0), 5.0)
      expect(disk.intersects_disk?(other_disk)).to be true
    end

    it 'возвращает true для одного круга внутри другого' do
      inner_disk = Geo2d::Disk.new(Geo2d::Point.new(0, 0), 2.0)
      expect(disk.intersects_disk?(inner_disk)).to be true
    end

    it 'возвращает true для касающихся кругов' do
      tangent_disk = Geo2d::Disk.new(Geo2d::Point.new(10, 0), 5.0)
      expect(disk.intersects_disk?(tangent_disk)).to be true
    end

    it 'возвращает false для непересекающихся кругов' do
      far_disk = Geo2d::Disk.new(Geo2d::Point.new(20, 0), 3.0)
      expect(disk.intersects_disk?(far_disk)).to be false
    end

    it 'выбрасывает ArgumentError, если аргумент не Disk' do
      expect { disk.intersects_disk?(center) }
        .to raise_error(ArgumentError, /Аргумент должен быть Disk/)
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного круга' do
      expect(disk.valid?).to be true
    end

    it 'возвращает false для невалидного круга' do
      disk.instance_variable_set(:@radius, 0.0)
      expect(disk.valid?).to be false
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых кругов' do
      same_disk = Geo2d::Disk.new(center, radius)
      expect(disk).to eq(same_disk)
    end

    it 'возвращает true для кругов с одинаковыми параметрами' do
      another_disk = Geo2d::Disk.new(Geo2d::Point.new(0, 0), 5.0)
      expect(disk).to eq(another_disk)
    end

    it 'возвращает false для кругов с разными центрами' do
      different_disk = Geo2d::Disk.new(Geo2d::Point.new(1, 1), 5.0)
      expect(disk).not_to eq(different_disk)
    end

    it 'возвращает false для кругов с разными радиусами' do
      different_disk = Geo2d::Disk.new(center, 10.0)
      expect(disk).not_to eq(different_disk)
    end

    it 'учитывает погрешность при сравнении' do
      slightly_different = Geo2d::Disk.new(
        Geo2d::Point.new(Geo2d::Disk::EPSILON / 2, Geo2d::Disk::EPSILON / 2),
        radius + (Geo2d::Disk::EPSILON / 2)
      )
      expect(disk).to eq(slightly_different)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для nil радиуса' do
      expect { Geo2d::Disk.new(center, nil) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end

    it 'выбрасывает ArgumentError для строки вместо радиуса' do
      expect { Geo2d::Disk.new(center, '5') }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает точки на границе EPSILON' do
      point_near_boundary = Geo2d::Point.new(5 + (Geo2d::Disk::EPSILON / 2), 0)
      expect(disk.contains_point?(point_near_boundary)).to be true
    end

    it 'сравнивает диски с учётом погрешности' do
      disk1 = Geo2d::Disk.new(center, 5.0)
      disk2 = Geo2d::Disk.new(center, 5.0 + (Geo2d::Disk::EPSILON / 2))
      expect(disk1).to eq(disk2)
    end
  end

  describe 'large radius values' do
    it 'корректно работает с большими значениями радиуса' do
      large_disk = Geo2d::Disk.new(center, 1_000_000.0)
      expect(large_disk.diameter).to eq(2_000_000.0)
      expect(large_disk.area).to be_within(1).of(Math::PI * 1_000_000_000_000)
    end

    it 'корректно работает с очень малыми значениями радиуса' do
      small_disk = Geo2d::Disk.new(center, 0.0001)
      expect(small_disk.radius).to eq(0.0001)
      expect(small_disk.valid?).to be true
    end
  end
end
