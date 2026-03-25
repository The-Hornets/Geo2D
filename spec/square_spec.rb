# frozen_string_literal: true

require_relative '../lib/geo2d/square'
require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/regular_polygon'

RSpec.describe Geo2d::Square do
  let(:side) { 10.0 }
  let(:center) { Geo2d::Point.new(0, 0) }
  let(:square) { Geo2d::Square.new(side, center) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт квадрат с заданной стороной и центром' do
      expect(square.side).to eq(10.0)
      expect(square.center).to eq(center)
    end

    it 'устанавливает n = 4' do
      expect(square.n).to eq(4)
    end

    it 'корректно вычисляет радиус описанной окружности' do
      expected_radius = side / Math.sqrt(2)
      expect(square.radius).to be_within(Geo2d::Square::EPSILON).of(expected_radius)
    end

    it 'создаёт квадрат с центром по умолчанию (0, 0)' do
      square = Geo2d::Square.new(5.0)
      expect(square.center).to eq(Geo2d::Point.new(0, 0))
    end

    it 'выбрасывает ArgumentError, если сторона ≤ 0' do
      expect { Geo2d::Square.new(0) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
      expect { Geo2d::Square.new(-5) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end
  end

  describe '.from_diagonal' do
    it 'создаёт квадрат по двум противоположным вершинам' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(4, 4)
      square = Geo2d::Square.from_diagonal(point1, point2)
      expect(square.center).to eq(Geo2d::Point.new(2, 2))
      expect(square.side).to be_within(Geo2d::Square::EPSILON).of(4.0)
    end

    it 'корректно вычисляет сторону из диагонали' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(6, 8)
      square = Geo2d::Square.from_diagonal(point1, point2)
      diagonal = 10.0
      expected_side = diagonal / Math.sqrt(2)
      expect(square.side).to be_within(Geo2d::Square::EPSILON).of(expected_side)
    end

    it 'выбрасывает ArgumentError, если точки совпадают' do
      point = Geo2d::Point.new(1, 1)
      expect { Geo2d::Square.from_diagonal(point, point) }
        .to raise_error(ArgumentError, /Точки не должны совпадать/)
    end
  end

  describe '.from_point_and_side' do
    it 'создаёт квадрат с центром в указанной точке' do
      point = Geo2d::Point.new(5, 5)
      square = Geo2d::Square.from_point_and_side(point, 10.0)
      expect(square.center).to eq(point)
      expect(square.side).to eq(10.0)
    end

    it 'выбрасывает ArgumentError, если точка не Point' do
      expect { Geo2d::Square.from_point_and_side([0, 0], 10.0) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError, если сторона ≤ 0' do
      point = Geo2d::Point.new(0, 0)
      expect { Geo2d::Square.from_point_and_side(point, 0) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end
  end

  describe '.from_points' do
    it 'создаёт квадрат по четырём вершинам' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(4, 0)
      p3 = Geo2d::Point.new(4, 4)
      p4 = Geo2d::Point.new(0, 4)
      square = Geo2d::Square.from_points(p1, p2, p3, p4)
      expect(square.n).to eq(4)
      expect(square.side).to be_within(Geo2d::Square::EPSILON).of(4.0)
    end

    it 'выбрасывает ArgumentError, если передано не 4 точки' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(4, 0)
      p3 = Geo2d::Point.new(4, 4)
      expect { Geo2d::Square.from_points(p1, p2, p3) }
        .to raise_error(ArgumentError)
    end

    it 'выбрасывает ArgumentError, если стороны не равны' do
      p1 = Geo2d::Point.new(0, 0)
      p2 = Geo2d::Point.new(5, 0)
      p3 = Geo2d::Point.new(5, 4)
      p4 = Geo2d::Point.new(0, 4)
      expect { Geo2d::Square.from_points(p1, p2, p3, p4) }
        .to raise_error(ArgumentError, /Все стороны должны быть равны/)
    end
  end

  describe 'модуль Rectangular' do
    it 'включает модуль Rectangular' do
      expect(Geo2d::Square.ancestors).to include(Geo2d::Rectangular)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА
  # ============================================================================

  describe '#n' do
    it 'всегда возвращает 4' do
      expect(square.n).to eq(4)
    end
  end

  describe '#side' do
    it 'возвращает длину стороны' do
      expect(square.side).to eq(10.0)
    end

    it 'является алиасом для side_length' do
      expect(square.method(:side)).to eq(square.method(:side_length))
    end
  end

  describe '#area' do
    it 'возвращает площадь квадрата side²' do
      expect(square.area).to eq(100.0)
    end

    it 'корректно вычисляет площадь для разных сторон' do
      square = Geo2d::Square.new(5.0)
      expect(square.area).to eq(25.0)
    end
  end

  describe '#perimeter' do
    it 'возвращает периметр 4 * side' do
      expect(square.perimeter).to eq(40.0)
    end
  end

  describe '#diagonal' do
    it 'возвращает длину диагонали side * √2' do
      expected = side * Math.sqrt(2)
      expect(square.diagonal).to be_within(Geo2d::Square::EPSILON).of(expected)
    end
  end

  describe '#width' do
    it 'возвращает ширину (равна стороне)' do
      expect(square.width).to eq(side)
    end
  end

  describe '#height' do
    it 'возвращает высоту (равна стороне)' do
      expect(square.height).to eq(side)
    end
  end

  describe '#aspect_ratio' do
    it 'всегда возвращает 1.0' do
      expect(square.aspect_ratio).to eq(1.0)
    end
  end

  describe '#interior_angle' do
    it 'всегда возвращает π/2' do
      expect(square.interior_angle).to be_within(Geo2d::Square::EPSILON).of(Math::PI / 2)
    end
  end

  describe '#vertices' do
    it 'возвращает 4 вершины' do
      expect(square.vertices.count).to eq(4)
    end

    it 'содержит объекты Point' do
      square.vertices.each do |vertex|
        expect(vertex).to be_a(Geo2d::Point)
      end
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки внутри квадрата' do
      expect(square.contains_point?(Geo2d::Point.new(0, 0))).to be true
    end

    it 'возвращает true для точки на границе квадрата' do
      vertex = square.vertices.first
      expect(square.contains_point?(vertex)).to be true
    end

    it 'возвращает false для точки вне квадрата' do
      expect(square.contains_point?(Geo2d::Point.new(10, 10))).to be false
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного квадрата' do
      expect(square.valid?).to be true
    end
  end

  describe '#square?' do
    it 'всегда возвращает true' do
      expect(square.square?).to be true
    end
  end

  describe '#rectangular?' do
    it 'всегда возвращает true' do
      expect(square.rectangular?).to be true
    end
  end

  describe '#rhombus?' do
    it 'всегда возвращает true' do
      expect(square.rhombus?).to be true
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых квадратов' do
      same_square = Geo2d::Square.new(side, center)
      expect(square).to eq(same_square)
    end

    it 'возвращает false для квадратов с разными сторонами' do
      different_square = Geo2d::Square.new(15.0, center)
      expect(square).not_to eq(different_square)
    end

    it 'возвращает false для квадратов с разными центрами' do
      different_square = Geo2d::Square.new(side, Geo2d::Point.new(1, 1))
      expect(square).not_to eq(different_square)
    end

    it 'учитывает погрешность при сравнении' do
      slightly_different = Geo2d::Square.new(
        side + (Geo2d::Square::EPSILON / 2),
        Geo2d::Point.new(Geo2d::Square::EPSILON / 2, Geo2d::Square::EPSILON / 2)
      )
      expect(square).to eq(slightly_different)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для nil стороны' do
      expect { Geo2d::Square.new(nil) }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end

    it 'выбрасывает ArgumentError для строки вместо стороны' do
      expect { Geo2d::Square.new('10') }
        .to raise_error(ArgumentError, /Сторона должна быть положительной/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает вершины с учётом погрешности' do
      square = Geo2d::Square.new(10.0, center)
      square.vertices.each do |vertex|
        distance = center.distance_to(vertex)
        expected_radius = 10.0 / Math.sqrt(2)
        expect(distance).to be_within(Geo2d::Square::EPSILON).of(expected_radius)
      end
    end

    it 'сравнивает квадраты с учётом погрешности' do
      square1 = Geo2d::Square.new(10.0, center)
      square2 = Geo2d::Square.new(10.0 + (Geo2d::Square::EPSILON / 2), center)
      expect(square1).to eq(square2)
    end
  end

  describe 'large side values' do
    it 'корректно работает с большими значениями стороны' do
      square = Geo2d::Square.new(1_000_000.0, center)
      expect(square.side).to eq(1_000_000.0)
      expect(square.area).to eq(1_000_000_000_000.0)
    end

    it 'корректно вычисляет периметр для больших сторон' do
      square = Geo2d::Square.new(1_000_000.0, center)
      expect(square.perimeter).to eq(4_000_000.0)
    end

    it 'корректно работает с очень малыми значениями стороны' do
      square = Geo2d::Square.new(0.0001, center)
      expect(square.side).to eq(0.0001)
      expect(square.valid?).to be true
    end
  end
end
