# frozen_string_literal: true

require_relative '../lib/geo2d/line'
require_relative '../lib/geo2d/point'

RSpec.describe Geo2d::Line do
  let(:point1) { Geo2d::Point.new(0, 0) }
  let(:point2) { Geo2d::Point.new(4, 4) }
  let(:line) { Geo2d::Line.new(point1, point2) }

  # ============================================================================
  # 1. КОНСТРУКТОРЫ
  # ============================================================================

  describe '#initialize' do
    it 'создаёт прямую по двум точкам' do
      expect(line.point1).to eq(point1)
      expect(line.point2).to eq(point2)
    end

    it 'выбрасывает ArgumentError, если точки совпадают' do
      point = Geo2d::Point.new(1, 1)
      expect { Geo2d::Line.new(point, point) }
        .to raise_error(ArgumentError, /Points must be distinct/)
    end

    it 'выбрасывает ArgumentError, если аргументы не точки' do
      expect { Geo2d::Line.new([0, 0], [4, 4]) }
        .to raise_error(ArgumentError, /must be Point objects/)
    end
  end

  describe '.from_points' do
    it 'создаёт прямую по двум точкам' do
      line = Geo2d::Line.from_points(point1, point2)
      expect(line.point1).to eq(point1)
      expect(line.point2).to eq(point2)
    end
  end

  describe '.from_sides' do
    it 'создаёт прямую из уравнения a*x + b*y + c = 0' do
      line = Geo2d::Line.from_sides(1, -1, 0)
      expect(line.contains_point?(Geo2d::Point.new(0, 0))).to be true
      expect(line.contains_point?(Geo2d::Point.new(4, 4))).to be true
    end

    it 'выбрасывает ArgumentError, если a и b оба равны нулю' do
      expect { Geo2d::Line.from_sides(0, 0, 5) }
        .to raise_error(ArgumentError, /cannot both be zero/)
    end
  end

  # ============================================================================
  # 2. СВОЙСТВА (геттеры)
  # ============================================================================

  describe '#point1' do
    it 'возвращает первую точку' do
      expect(line.point1).to eq(point1)
    end
  end

  describe '#point2' do
    it 'возвращает вторую точку' do
      expect(line.point2).to eq(point2)
    end
  end

  describe '#slope' do
    it 'возвращает угловой коэффициент для наклонной прямой' do
      expect(line.slope).to eq(1.0)
    end

    it 'возвращает nil для вертикальной прямой' do
      vertical_line = Geo2d::Line.new(
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(5, 10)
      )
      expect(vertical_line.slope).to be_nil
    end

    it 'возвращает 0 для горизонтальной прямой' do
      horizontal_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 5),
        Geo2d::Point.new(10, 5)
      )
      expect(horizontal_line.slope).to eq(0.0)
    end
  end

  describe '#coef_a' do
    it 'возвращает коэффициент a уравнения прямой' do
      expect(line.coef_a).to eq(-4)
    end
  end

  describe '#coef_b' do
    it 'возвращает коэффициент b уравнения прямой' do
      expect(line.coef_b).to eq(4)
    end
  end

  describe '#coef_c' do
    it 'возвращает коэффициент c уравнения прямой' do
      expect(line.coef_c).to eq(0)
    end
  end

  # ============================================================================
  # 3. ПРЕДИКАТЫ
  # ============================================================================

  describe '#contains_point?' do
    it 'возвращает true для точки на прямой' do
      point_on_line = Geo2d::Point.new(2, 2)
      expect(line.contains_point?(point_on_line)).to be true
    end

    it 'возвращает true для первой точки прямой' do
      expect(line.contains_point?(point1)).to be true
    end

    it 'возвращает true для второй точки прямой' do
      expect(line.contains_point?(point2)).to be true
    end

    it 'возвращает false для точки не на прямой' do
      point_off_line = Geo2d::Point.new(2, 3)
      expect(line.contains_point?(point_off_line)).to be false
    end

    it 'возвращает false для не Point объекта' do
      expect(line.contains_point?([2, 2])).to be false
    end
  end

  describe '#parallel?' do
    it 'возвращает true для параллельных прямых' do
      parallel_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 1),
        Geo2d::Point.new(4, 5)
      )
      expect(line.parallel?(parallel_line)).to be true
    end

    it 'возвращает true для двух вертикальных прямых' do
      vertical1 = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(0, 10)
      )
      vertical2 = Geo2d::Line.new(
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(5, 10)
      )
      expect(vertical1.parallel?(vertical2)).to be true
    end

    it 'возвращает false для непараллельных прямых' do
      horizontal_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(10, 0)
      )
      expect(line.parallel?(horizontal_line)).to be false
    end

    it 'возвращает false для не Line объекта' do
      expect(line.parallel?(point1)).to be false
    end
  end

  describe '#perpendicular?' do
    it 'возвращает true для перпендикулярных прямых' do
      perpendicular_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(4, -4)
      )
      expect(line.perpendicular?(perpendicular_line)).to be true
    end

    it 'возвращает true для вертикальной и горизонтальной прямых' do
      vertical = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(0, 10)
      )
      horizontal = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(10, 0)
      )
      expect(vertical.perpendicular?(horizontal)).to be true
    end

    it 'возвращает false для неперпендикулярных прямых' do
      parallel_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 1),
        Geo2d::Point.new(4, 5)
      )
      expect(line.perpendicular?(parallel_line)).to be false
    end

    it 'возвращает false для не Line объекта' do
      expect(line.perpendicular?(point1)).to be false
    end
  end

  describe '#==' do
    it 'возвращает true для одинаковых прямых' do
      same_line = Geo2d::Line.new(point1, point2)
      expect(line).to eq(same_line)
    end

    it 'возвращает true для прямых с разными точками, но лежащих на одной линии' do
      same_line = Geo2d::Line.new(
        Geo2d::Point.new(1, 1),
        Geo2d::Point.new(3, 3)
      )
      expect(line).to eq(same_line)
    end

    it 'возвращает false для разных прямых' do
      different_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 1),
        Geo2d::Point.new(4, 5)
      )
      expect(line).not_to eq(different_line)
    end

    it 'возвращает false для не Line объекта' do
      expect(line).not_to eq(point1)
    end
  end

  describe '#valid?' do
    it 'возвращает true для валидной прямой' do
      expect(line.valid?).to be true
    end

    it 'возвращает false для невалидной прямой' do
      line.instance_variable_set(:@point2, point1)
      expect(line.valid?).to be false
    end
  end

  describe '#intersection_of_lines' do
    it 'находит точку пересечения двух прямых' do
      line1 = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(4, 4)
      )
      line2 = Geo2d::Line.new(
        Geo2d::Point.new(0, 4),
        Geo2d::Point.new(4, 0)
      )
      intersection = line1.intersection_of_lines(line2)
      expect(intersection.x).to be_within(Geo2d::Line::EPSILON).of(2.0)
      expect(intersection.y).to be_within(Geo2d::Line::EPSILON).of(2.0)
    end

    it 'возвращает nil для параллельных непересекающихся прямых' do
      parallel_line = Geo2d::Line.new(
        Geo2d::Point.new(0, 1),
        Geo2d::Point.new(4, 5)
      )
      expect(line.intersection_of_lines(parallel_line)).to be_nil
    end

    it 'возвращает self для совпадающих прямых' do
      same_line = Geo2d::Line.new(
        Geo2d::Point.new(1, 1),
        Geo2d::Point.new(3, 3)
      )
      expect(line.intersection_of_lines(same_line)).to eq(line)
    end

    it 'выбрасывает ArgumentError, если аргумент не Line' do
      expect { line.intersection_of_lines(point1) }
        .to raise_error(ArgumentError, /must be a Line/)
    end
  end

  # ============================================================================
  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  # ============================================================================

  describe 'invalid input' do
    it 'выбрасывает ArgumentError для не Point аргументов в from_points' do
      expect { Geo2d::Line.from_points([0, 0], [4, 4]) }
        .to raise_error(ArgumentError, /must be Point objects/)
    end

    it 'выбрасывает ArgumentError для одинаковых точек в from_points' do
      point = Geo2d::Point.new(1, 1)
      expect { Geo2d::Line.from_points(point, point) }
        .to raise_error(ArgumentError, /Points must be distinct/)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает точки в пределах EPSILON' do
      line = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(10, 0)
      )
      point_near_line = Geo2d::Point.new(5, Geo2d::Line::EPSILON / 100)
      expect(line.contains_point?(point_near_line)).to be true
    end

    it 'сравнивает прямые с учётом погрешности' do
      line1 = Geo2d::Line.new(
        Geo2d::Point.new(0, 0),
        Geo2d::Point.new(4, 4)
      )
      line2 = Geo2d::Line.new(
        Geo2d::Point.new(Geo2d::Line::EPSILON / 2, Geo2d::Line::EPSILON / 2),
        Geo2d::Point.new(4 + (Geo2d::Line::EPSILON / 2), 4 + (Geo2d::Line::EPSILON / 2))
      )
      expect(line1).to eq(line2)
    end
  end

  describe 'special cases' do
    it 'корректно работает с вертикальной прямой' do
      vertical = Geo2d::Line.new(
        Geo2d::Point.new(5, 0),
        Geo2d::Point.new(5, 10)
      )
      expect(vertical.slope).to be_nil
      expect(vertical.coef_a).to eq(-10)
      expect(vertical.coef_b).to eq(0)
    end

    it 'корректно работает с горизонтальной прямой' do
      horizontal = Geo2d::Line.new(
        Geo2d::Point.new(0, 5),
        Geo2d::Point.new(10, 5)
      )
      expect(horizontal.slope).to eq(0.0)
      expect(horizontal.coef_a).to eq(0)
      expect(horizontal.coef_b).to eq(10)
    end
  end
end
