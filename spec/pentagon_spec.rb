# frozen_string_literal: true

require_relative '../lib/geo2d/pentagon'
require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/regular_polygon'

RSpec.describe Geo2d::Pentagon do
  let(:side) { 10.0 }
  let(:center) { Geo2d::Point.new(0, 0) }
  let(:pentagon) { Geo2d::Pentagon.new(side, center) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт пятиугольник с заданной стороной и центром' do
      expect(pentagon.side).to eq(10.0)
      expect(pentagon.center).to eq(center)
    end

    it 'устанавливает n = 5' do
      expect(pentagon.n).to eq(5)
    end

    it 'корректно вычисляет радиус описанной окружности' do
      expected_radius = side / (2 * Math.sin(Math::PI / 5))
      expect(pentagon.radius).to be_within(Geo2d::Pentagon::EPSILON).of(expected_radius)
    end

    it 'создаёт пятиугольник с центром по умолчанию (0, 0)' do
      pentagon = Geo2d::Pentagon.new(5.0)
      expect(pentagon.center).to eq(Geo2d::Point.new(0, 0))
    end

    it 'выбрасывает ArgumentError, если сторона ≤ 0' do
      expect { Geo2d::Pentagon.new(0) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
      expect { Geo2d::Pentagon.new(-5) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end
  end

  describe '.from_radius' do
    it 'создаёт пятиугольник по радиусу описанной окружности' do
      radius = 10.0
      pentagon = Geo2d::Pentagon.from_radius(radius, center)
      expect(pentagon.radius).to eq(10.0)
      expect(pentagon.center).to eq(center)
    end

    it 'корректно вычисляет сторону из радиуса' do
      radius = 10.0
      pentagon = Geo2d::Pentagon.from_radius(radius, center)
      expected_side = 2 * radius * Math.sin(Math::PI / 5)
      expect(pentagon.side).to be_within(Geo2d::Pentagon::EPSILON).of(expected_side)
    end

    it 'выбрасывает ArgumentError, если радиус ≤ 0' do
      expect { Geo2d::Pentagon.from_radius(0) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
      expect { Geo2d::Pentagon.from_radius(-5) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe '.from_point_and_side' do
    it 'создаёт пятиугольник с центром в указанной точке' do
      point = Geo2d::Point.new(5, 5)
      pentagon = Geo2d::Pentagon.from_point_and_side(point, 10.0)
      expect(pentagon.center).to eq(point)
      expect(pentagon.side).to eq(10.0)
    end

    it 'выбрасывает ArgumentError, если точка не Point' do
      expect { Geo2d::Pentagon.from_point_and_side([0, 0], 10.0) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError, если сторона ≤ 0' do
      point = Geo2d::Point.new(0, 0)
      expect { Geo2d::Pentagon.from_point_and_side(point, 0) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end
  end

  describe '.from_points' do
    it 'создаёт правильный пятиугольник по пяти вершинам' do
      radius = 10.0
      vertices = []
      5.times do |i|
        angle = 2 * Math::PI * i / 5
        x = radius * Math.cos(angle)
        y = radius * Math.sin(angle)
        vertices << Geo2d::Point.new(x, y)
      end
      pentagon = Geo2d::Pentagon.from_points(*vertices)
      expect(pentagon.n).to eq(5)
      expect(pentagon.side).to be_within(Geo2d::Pentagon::EPSILON).of(2 * radius * Math.sin(Math::PI / 5))
    end

    it 'выбрасывает ArgumentError, если передано не 5 точек' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(4, 0)
      p3 = Geo2d::Point.new(4, 4)
      p4 = Geo2d::Point.new(0, 4)
      expect { Geo2d::Pentagon.from_points(p1, p2, p3, p4) }
        .to raise_error(ArgumentError)
    end

    it 'выбрасывает ArgumentError, если стороны не равны' do
      p1 = Geo2d::Point.new(10, 0)
      p2 = Geo2d::Point.new(3, 9)
      p3 = Geo2d::Point.new(-8, 6)
      p4 = Geo2d::Point.new(-8, -6)
      p5 = Geo2d::Point.new(3, -9)
      expect { Geo2d::Pentagon.from_points(p1, p2, p3, p4, p5) }
        .to raise_error(ArgumentError, /Все стороны должны быть равны/)
    end
  end

  describe 'наследование от RegularPolygon' do
    it 'наследуется от Geo2d::RegularPolygon' do
      expect(Geo2d::Pentagon.ancestors).to include(Geo2d::RegularPolygon)
    end

    it 'наследуется от Geo2d::Polygon' do
      expect(Geo2d::Pentagon.ancestors).to include(Geo2d::Polygon)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА
  # ============================================================================

  describe '#n' do
    it 'всегда возвращает 5' do
      expect(pentagon.n).to eq(5)
    end
  end

  describe '#side' do
    it 'возвращает длину стороны' do
      expect(pentagon.side).to eq(10.0)
    end

    it 'является алиасом для side_length' do
      expect(pentagon.method(:side)).to eq(pentagon.method(:side_length))
    end
  end

  describe '#area' do
    it 'возвращает площадь правильного пятиугольника' do
      expected = (5 * (pentagon.radius**2) * Math.sin(2 * Math::PI / 5)) / 2
      expect(pentagon.area).to be_within(Geo2d::Pentagon::EPSILON).of(expected)
    end

    it 'корректно вычисляет площадь для разных сторон' do
      pentagon = Geo2d::Pentagon.new(5.0)
      expected = (5 * (pentagon.radius**2) * Math.sin(2 * Math::PI / 5)) / 2
      expect(pentagon.area).to be_within(Geo2d::Pentagon::EPSILON).of(expected)
    end
  end

  describe '#perimeter' do
    it 'возвращает периметр 5 * side' do
      expect(pentagon.perimeter).to eq(50.0)
    end
  end

  describe '#interior_angle' do
    it 'всегда возвращает 108° (3π/5)' do
      expect(pentagon.interior_angle).to be_within(Geo2d::Pentagon::EPSILON).of(3 * Math::PI / 5)
    end
  end

  describe '#exterior_angle' do
    it 'всегда возвращает 72° (2π/5)' do
      expect(pentagon.exterior_angle).to be_within(Geo2d::Pentagon::EPSILON).of(2 * Math::PI / 5)
    end
  end

  describe '#apothem' do
    it 'возвращает апофему пятиугольника' do
      expected = pentagon.radius * Math.cos(Math::PI / 5)
      expect(pentagon.apothem).to be_within(Geo2d::Pentagon::EPSILON).of(expected)
    end
  end

  describe '#vertices' do
    it 'возвращает 5 вершин' do
      expect(pentagon.vertices.count).to eq(5)
    end

    it 'содержит объекты Point' do
      pentagon.vertices.each do |vertex|
        expect(vertex).to be_a(Geo2d::Point)
      end
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки внутри пятиугольника' do
      expect(pentagon.contains_point?(Geo2d::Point.new(0, 0))).to be true
    end

    it 'возвращает true для точки на границе пятиугольника' do
      vertex = pentagon.vertices.first
      expect(pentagon.contains_point?(vertex)).to be true
    end

    it 'возвращает false для точки вне пятиугольника' do
      expect(pentagon.contains_point?(Geo2d::Point.new(100, 100))).to be false
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного пятиугольника' do
      expect(pentagon.valid?).to be true
    end
  end

  describe '#pentagon?' do
    it 'всегда возвращает true' do
      expect(pentagon.pentagon?).to be true
    end
  end

  describe '#regular?' do
    it 'всегда возвращает true' do
      expect(pentagon.regular?).to be true
    end
  end

  describe '#convex?' do
    it 'всегда возвращает true' do
      expect(pentagon.convex?).to be true
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых пятиугольников' do
      same_pentagon = Geo2d::Pentagon.new(side, center)
      expect(pentagon).to eq(same_pentagon)
    end

    it 'возвращает false для пятиугольников с разными сторонами' do
      different_pentagon = Geo2d::Pentagon.new(15.0, center)
      expect(pentagon).not_to eq(different_pentagon)
    end

    it 'возвращает false для пятиугольников с разными центрами' do
      different_pentagon = Geo2d::Pentagon.new(side, Geo2d::Point.new(1, 1))
      expect(pentagon).not_to eq(different_pentagon)
    end

    it 'учитывает погрешность при сравнении' do
      slightly_different = Geo2d::Pentagon.new(
        side + (Geo2d::Pentagon::EPSILON / 2),
        Geo2d::Point.new(Geo2d::Pentagon::EPSILON / 2, Geo2d::Pentagon::EPSILON / 2)
      )
      expect(pentagon).to eq(slightly_different)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для nil стороны' do
      expect { Geo2d::Pentagon.new(nil) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end

    it 'выбрасывает ArgumentError для строки вместо стороны' do
      expect { Geo2d::Pentagon.new('10') }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end

    it 'выбрасывает ArgumentError для nil радиуса в from_radius' do
      expect { Geo2d::Pentagon.from_radius(nil) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает вершины с учётом погрешности' do
      pentagon = Geo2d::Pentagon.new(10.0, center)
      pentagon.vertices.each do |vertex|
        distance = center.distance_to(vertex)
        expect(distance).to be_within(Geo2d::Pentagon::EPSILON).of(pentagon.radius)
      end
    end

    it 'сравнивает пятиугольники с учётом погрешности' do
      pentagon1 = Geo2d::Pentagon.new(10.0, center)
      pentagon2 = Geo2d::Pentagon.new(10.0 + (Geo2d::Pentagon::EPSILON / 2), center)
      expect(pentagon1).to eq(pentagon2)
    end
  end

  describe 'large side values' do
    it 'корректно работает с большими значениями стороны' do
      pentagon = Geo2d::Pentagon.new(1_000_000.0, center)
      expect(pentagon.side).to eq(1_000_000.0)
      expect(pentagon.perimeter).to eq(5_000_000.0)
    end

    it 'корректно вычисляет площадь для больших сторон' do
      pentagon = Geo2d::Pentagon.new(1_000_000.0, center)
      expect(pentagon.area).to be > 0
    end

    it 'корректно работает с очень малыми значениями стороны' do
      pentagon = Geo2d::Pentagon.new(0.0001, center)
      expect(pentagon.side).to eq(0.0001)
      expect(pentagon.valid?).to be true
    end
  end
end
