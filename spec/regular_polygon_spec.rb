# frozen_string_literal: true

require_relative '../lib/geo2d/regular_polygon'
require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/polygon'

RSpec.describe Geo2d::RegularPolygon do
  let(:center) { Geo2d::Point.new(0, 0) }
  let(:n) { 6 }
  let(:radius) { 5.0 }
  let(:polygon) { Geo2d::RegularPolygon.new(n, center, radius) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт правильный многоугольник с заданным количеством сторон, центром и радиусом' do
      expect(polygon.n).to eq(6)
      expect(polygon.center).to eq(center)
      expect(polygon.radius).to eq(5.0)
    end

    it 'генерирует вершины равномерно по окружности' do
      expect(polygon.vertices.count).to eq(6)
      polygon.vertices.each do |vertex|
        distance = center.distance_to(vertex)
        expect(distance).to be_within(Geo2d::RegularPolygon::EPSILON).of(radius)
      end
    end

    it 'выбрасывает ArgumentError, если n < 3' do
      expect { Geo2d::RegularPolygon.new(2, center, radius) }
        .to raise_error(ArgumentError, /Количество сторон должно быть не менее 3/)
    end

    it 'выбрасывает ArgumentError, если центр не Point' do
      expect { Geo2d::RegularPolygon.new(5, [0, 0], radius) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError, если радиус ≤ 0' do
      expect { Geo2d::RegularPolygon.new(5, center, 0) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
      expect { Geo2d::RegularPolygon.new(5, center, -5) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe '.from_side_length' do
    it 'создаёт многоугольник по количеству сторон и длине стороны' do
      polygon = Geo2d::RegularPolygon.from_side_length(4, 10.0)
      expect(polygon.n).to eq(4)
      expect(polygon.side_length).to be_within(Geo2d::RegularPolygon::EPSILON).of(10.0)
    end

    it 'корректно вычисляет радиус для равностороннего треугольника' do
      polygon = Geo2d::RegularPolygon.from_side_length(3, 10.0)
      expected_radius = 10.0 / (2 * Math.sin(Math::PI / 3))
      expect(polygon.radius).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected_radius)
    end

    it 'выбрасывает ArgumentError, если n < 3' do
      expect { Geo2d::RegularPolygon.from_side_length(2, 10.0) }
        .to raise_error(ArgumentError, /Количество сторон должно быть не менее 3/)
    end

    it 'выбрасывает ArgumentError, если длина стороны ≤ 0' do
      expect { Geo2d::RegularPolygon.from_side_length(5, 0) }
        .to raise_error(ArgumentError, /Длина стороны должна быть положительной/)
      expect { Geo2d::RegularPolygon.from_side_length(5, -10) }
        .to raise_error(ArgumentError, /Длина стороны должна быть положительной/)
    end
  end

  describe '.from_points' do
    it 'создаёт многоугольник по центру и вершинам' do
      center = Geo2d::Point.new(0, 0)
      vertices = [
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(2.5, 4.330127018922193),
        Geo2d::Point.new(-2.5, 4.330127018922193),
        Geo2d::Point.new(-5, 0),
        Geo2d::Point.new(-2.5, -4.330127018922193),
        Geo2d::Point.new(2.5, -4.330127018922193)
      ]
      polygon = Geo2d::RegularPolygon.from_points(center, *vertices)
      expect(polygon.n).to eq(6)
      expect(polygon.center).to eq(center)
    end

    it 'выбрасывает ArgumentError, если вершины не на одинаковом расстоянии от центра' do
      center = Geo2d::Point.new(0, 0)
      vertices = [
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(0, 6),
        Geo2d::Point.new(-5, 0)
      ]
      expect { Geo2d::RegularPolygon.from_points(center, *vertices) }
        .to raise_error(ArgumentError, /Вершины должны быть на одинаковом расстоянии/)
    end

    it 'выбрасывает ArgumentError, если углы между вершинами не равны' do
      center = Geo2d::Point.new(0, 0)
      vertices = [
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(3, 4),
        Geo2d::Point.new(-5, 0),
        Geo2d::Point.new(0, -5)
      ]
      expect { Geo2d::RegularPolygon.from_points(center, *vertices) }
        .to raise_error(ArgumentError, /Углы между вершинами должны быть равны/)
    end
  end

  describe 'наследование от Polygon' do
    it 'наследуется от Geo2d::Polygon' do
      expect(Geo2d::RegularPolygon.ancestors).to include(Geo2d::Polygon)
    end

    it 'переопределяет метод #area' do
      expect(polygon.method(:area).owner).to eq(Geo2d::RegularPolygon)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА
  # ============================================================================

  describe '#n' do
    it 'возвращает количество сторон' do
      expect(polygon.n).to eq(6)
    end
  end

  describe '#center' do
    it 'возвращает центр многоугольника' do
      expect(polygon.center).to eq(center)
    end
  end

  describe '#radius' do
    it 'возвращает радиус описанной окружности' do
      expect(polygon.radius).to eq(5.0)
    end
  end

  describe '#side_length' do
    it 'возвращает длину стороны' do
      expected = 2 * radius * Math.sin(Math::PI / n)
      expect(polygon.side_length).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет длину стороны для квадрата' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      expected = 2 * 5.0 * Math.sin(Math::PI / 4)
      expect(square.side_length).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#perimeter' do
    it 'возвращает периметр многоугольника' do
      expected = n * polygon.side_length
      expect(polygon.perimeter).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#area' do
    it 'возвращает площадь многоугольника' do
      expected = (n * (radius**2) * Math.sin(2 * Math::PI / n)) / 2
      expect(polygon.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет площадь для равностороннего треугольника' do
      triangle = Geo2d::RegularPolygon.new(3, center, 5.0)
      expected = (3 * 25 * Math.sin(2 * Math::PI / 3)) / 2
      expect(triangle.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет площадь для квадрата' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      expected = (4 * 25 * Math.sin(2 * Math::PI / 4)) / 2
      expect(square.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#interior_angle' do
    it 'возвращает внутренний угол в радианах' do
      expected = (n - 2) * Math::PI / n
      expect(polygon.interior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет угол для равностороннего треугольника (60 градусов)' do
      triangle = Geo2d::RegularPolygon.new(3, center, 5.0)
      expected = (3 - 2) * Math::PI / 3
      expect(triangle.interior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет угол для квадрата (90 градусов)' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      expected = (4 - 2) * Math::PI / 4
      expect(square.interior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#exterior_angle' do
    it 'возвращает внешний угол в радианах' do
      expected = 2 * Math::PI / n
      expect(polygon.exterior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#apothem' do
    it 'возвращает апофему многоугольника' do
      expected = radius * Math.cos(Math::PI / n)
      expect(polygon.apothem).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe '#vertices' do
    it 'возвращает массив вершин' do
      expect(polygon.vertices).to be_a(Array)
      expect(polygon.vertices.count).to eq(6)
    end

    it 'содержит объекты Point' do
      polygon.vertices.each do |vertex|
        expect(vertex).to be_a(Geo2d::Point)
      end
    end
  end

  describe '#vertices_count' do
    it 'возвращает количество вершин' do
      expect(polygon.vertices_count).to eq(6)
    end

    it 'равняется n' do
      expect(polygon.vertices_count).to eq(polygon.n)
    end
  end

  describe '#angles' do
    it 'возвращает массив внутренних углов' do
      expect(polygon.angles).to be_a(Array)
      expect(polygon.angles.count).to eq(6)
    end

    it 'все углы равны interior_angle' do
      polygon.angles.each do |angle|
        expect(angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(polygon.interior_angle)
      end
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки внутри многоугольника' do
      expect(polygon.contains_point?(Geo2d::Point.new(0, 0))).to be true
    end

    it 'возвращает true для точки на границе многоугольника' do
      vertex = polygon.vertices.first
      expect(polygon.contains_point?(vertex)).to be true
    end

    it 'возвращает false для точки вне многоугольника' do
      expect(polygon.contains_point?(Geo2d::Point.new(10, 10))).to be false
    end

    it 'корректно работает для квадрата' do
      square = Geo2d::RegularPolygon.new(4, Geo2d::Point.new(0, 0), 5.0)
      expect(square.contains_point?(Geo2d::Point.new(0, 0))).to be true
      expect(square.contains_point?(Geo2d::Point.new(2, 2))).to be true
      expect(square.contains_point?(Geo2d::Point.new(4, 4))).to be false
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидного многоугольника' do
      expect(polygon.valid?).to be true
    end

    it 'возвращает false для невалидного многоугольника' do
      polygon.instance_variable_set(:@n, 2)
      expect(polygon.valid?).to be false
    end
  end

  describe '#convex?' do
    it 'возвращает true для правильного многоугольника' do
      expect(polygon.convex?).to be true
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых многоугольников' do
      same_polygon = Geo2d::RegularPolygon.new(n, center, radius)
      expect(polygon).to eq(same_polygon)
    end

    it 'возвращает false для многоугольников с разным n' do
      different_polygon = Geo2d::RegularPolygon.new(5, center, radius)
      expect(polygon).not_to eq(different_polygon)
    end

    it 'возвращает false для многоугольников с разными центрами' do
      different_polygon = Geo2d::RegularPolygon.new(n, Geo2d::Point.new(1, 1), radius)
      expect(polygon).not_to eq(different_polygon)
    end

    it 'возвращает false для многоугольников с разными радиусами' do
      different_polygon = Geo2d::RegularPolygon.new(n, center, 10.0)
      expect(polygon).not_to eq(different_polygon)
    end

    it 'учитывает погрешность при сравнении' do
      slightly_different = Geo2d::RegularPolygon.new(
        n,
        Geo2d::Point.new(Geo2d::RegularPolygon::EPSILON / 2, Geo2d::RegularPolygon::EPSILON / 2),
        radius + (Geo2d::RegularPolygon::EPSILON / 2)
      )
      expect(polygon).to eq(slightly_different)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для nil центра' do
      expect { Geo2d::RegularPolygon.new(5, nil, radius) }
        .to raise_error(ArgumentError, /Центр должен быть точкой/)
    end

    it 'выбрасывает ArgumentError для nil радиуса' do
      expect { Geo2d::RegularPolygon.new(5, center, nil) }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end

    it 'выбрасывает ArgumentError для строки вместо радиуса' do
      expect { Geo2d::RegularPolygon.new(5, center, '5') }
        .to raise_error(ArgumentError, /Радиус должен быть положительным/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает вершины с учётом погрешности' do
      polygon = Geo2d::RegularPolygon.new(6, center, 5.0)
      polygon.vertices.each do |vertex|
        distance = center.distance_to(vertex)
        expect(distance).to be_within(Geo2d::RegularPolygon::EPSILON).of(radius)
      end
    end

    it 'сравнивает многоугольники с учётом погрешности' do
      poly1 = Geo2d::RegularPolygon.new(6, center, 5.0)
      poly2 = Geo2d::RegularPolygon.new(6, center, 5.0 + (Geo2d::RegularPolygon::EPSILON / 2))
      expect(poly1).to eq(poly2)
    end
  end

  describe 'triangle (n=3)' do
    it 'создаёт равносторонний треугольник' do
      triangle = Geo2d::RegularPolygon.new(3, center, 5.0)
      expect(triangle.n).to eq(3)
      expect(triangle.vertices.count).to eq(3)
      expect(triangle.interior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(Math::PI / 3)
    end

    it 'корректно вычисляет площадь треугольника' do
      triangle = Geo2d::RegularPolygon.new(3, center, 5.0)
      expected = (3 * 25 * Math.sin(2 * Math::PI / 3)) / 2
      expect(triangle.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe 'square (n=4)' do
    it 'создаёт квадрат' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      expect(square.n).to eq(4)
      expect(square.vertices.count).to eq(4)
      expect(square.interior_angle).to be_within(Geo2d::RegularPolygon::EPSILON).of(Math::PI / 2)
    end

    it 'корректно вычисляет площадь квадрата' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      expected = (4 * 25 * Math.sin(2 * Math::PI / 4)) / 2
      expect(square.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'корректно вычисляет периметр квадрата' do
      square = Geo2d::RegularPolygon.new(4, center, 5.0)
      side = 2 * 5.0 * Math.sin(Math::PI / 4)
      expected = 4 * side
      expect(square.perimeter).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end
  end

  describe 'large n values' do
    it 'корректно работает с большим количеством сторон' do
      polygon = Geo2d::RegularPolygon.new(100, center, 5.0)
      expect(polygon.n).to eq(100)
      expect(polygon.vertices.count).to eq(100)
    end

    it 'корректно вычисляет площадь для большого n' do
      polygon = Geo2d::RegularPolygon.new(100, center, 5.0)
      expected = (100 * 25 * Math.sin(2 * Math::PI / 100)) / 2
      expect(polygon.area).to be_within(Geo2d::RegularPolygon::EPSILON).of(expected)
    end

    it 'при большом n многоугольник приближается к кругу' do
      polygon = Geo2d::RegularPolygon.new(1000, center, 5.0)
      circle_area = Math::PI * 25
      expect(polygon.area).to be_within(0.01).of(circle_area)
    end
  end
end
