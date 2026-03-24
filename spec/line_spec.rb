# frozen_string_literal: true

require_relative '../lib/geo2d/point'
require_relative '../lib/geo2d/line'

describe Geo2d::Line do
  # Вспомогательная константа для сравнения float, так как в line.rb она может отсутствовать
  let(:epsilon) { 1e-10 }

  # 1. КОНСТРУКТОРЫ
  describe '#initialize' do
    let(:p1) { Geo2d::Point.new(0, 0) }
    let(:p2) { Geo2d::Point.new(1, 1) }

    it 'создаёт прямую по двум точкам' do
      line = Geo2d::Line.new(p1, p2)
      expect(line.point1).to eq(p1)
      expect(line.point2).to eq(p2)
    end

    it 'выбрасывает ошибку, если точки совпадают' do
      expect { Geo2d::Line.new(p1, p1) }.to raise_error(ArgumentError, /Points must be distinct/)
    end

    it 'выбрасывает ошибку, если аргументы не являются Point' do
      expect { Geo2d::Line.new([0, 0], p2) }.to raise_error(ArgumentError, /must be Point objects/)
    end
  end

  describe '.from_equation' do
    it 'создаёт прямую из общего уравнения (наклонная)' do
      # x + y - 1 = 0 -> проходит через (0, 1) и (1, 0)
      line = Geo2d::Line.from_equation(1, 1, -1)
      expect(line.contains_point?(Geo2d::Point.new(0, 1))).to be true
      expect(line.contains_point?(Geo2d::Point.new(1, 0))).to be true
    end

    it 'создаёт горизонтальную прямую (a = 0)' do
      # y - 5 = 0 -> y = 5
      line = Geo2d::Line.from_equation(0, 1, -5)
      expect(line.contains_point?(Geo2d::Point.new(0, 5))).to be true
      expect(line.contains_point?(Geo2d::Point.new(100, 5))).to be true
    end

    it 'создаёт вертикальную прямую (b = 0)' do
      # x - 3 = 0 -> x = 3
      line = Geo2d::Line.from_equation(1, 0, -3)
      expect(line.contains_point?(Geo2d::Point.new(3, 0))).to be true
      expect(line.contains_point?(Geo2d::Point.new(3, 100))).to be true
    end

    it 'выбрасывает ошибку, если a и b равны нулю' do
      expect { Geo2d::Line.from_equation(0, 0, 5) }.to raise_error(ArgumentError, /cannot both be zero/)
    end
  end

  # 2. СВОЙСТВА (ГЕТТЕРЫ)
  describe '#slope' do
    it 'возвращает угловой коэффициент для наклонной прямой' do
      # y = x -> slope = 1
      line = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      expect(line.slope).to be_within(epsilon).of(1.0)
    end

    it 'возвращает 0 для горизонтальной прямой' do
      line = Geo2d::Line.new(Geo2d::Point.new(0, 5), Geo2d::Point.new(10, 5))
      expect(line.slope).to be_within(epsilon).of(0.0)
    end

    it 'возвращает nil для вертикальной прямой' do
      line = Geo2d::Line.new(Geo2d::Point.new(5, 0), Geo2d::Point.new(5, 10))
      expect(line.slope).to be_nil
    end
  end

  describe '#coef_a, #coef_b, #coef_c' do
    it 'возвращает коэффициенты уравнения прямой' do
      # Точки (0,0) и (1,1) -> y = x -> x - y = 0 -> a=1, b=-1, c=0
      # Реализация в line.rb: a = y1 - y2, b = x2 - x1
      line = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))

      expect(line.coef_a).to eq(-1) # 0 - 1
      expect(line.coef_b).to eq(1)  # 1 - 0
      # c = -ax1 - by1 = -(-1)*0 - 1*0 = 0
      expect(line.coef_c).to be_within(epsilon).of(0)
    end
  end

  # 3. ПРЕДИКАТЫ
  describe '#contains_point?' do
    let(:line) { Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(2, 2)) }

    it 'возвращает true для точки на прямой' do
      expect(line.contains_point?(Geo2d::Point.new(1, 1))).to be true
      expect(line.contains_point?(Geo2d::Point.new(3, 3))).to be true
    end

    it 'возвращает true для точек, задающих прямую' do
      expect(line.contains_point?(line.point1)).to be true
      expect(line.contains_point?(line.point2)).to be true
    end

    it 'возвращает false для точки не на прямой' do
      expect(line.contains_point?(Geo2d::Point.new(1, 2))).to be false
    end

    it 'возвращает false, если аргумент не Point' do
      expect(line.contains_point?([1, 1])).to be false
    end
  end

  describe '#parallel?' do
    it 'возвращает true для параллельных прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 1), Geo2d::Point.new(1, 2))
      expect(line1.parallel?(line2)).to be true
    end

    it 'возвращает true для двух вертикальных прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(0, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(5, 0), Geo2d::Point.new(5, 1))
      expect(line1.parallel?(line2)).to be true
    end

    it 'возвращает false для пересекающихся прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, -1))
      expect(line1.parallel?(line2)).to be false
    end

    it 'возвращает false, если аргумент не Line' do
      line = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      expect(line.parallel?('string')).to be false
    end
  end

  describe '#perpendicular?' do
    it 'возвращает true для перпендикулярных прямых' do
      # y = x (slope 1) и y = -x (slope -1)
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, -1))
      expect(line1.perpendicular?(line2)).to be true
    end

    it 'возвращает true для вертикальной и горизонтальной прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(0, 1)) # Vertical
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 0)) # Horizontal
      expect(line1.perpendicular?(line2)).to be true
    end

    it 'возвращает false для неперпендикулярных прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(2, 1))
      expect(line1.perpendicular?(line2)).to be false
    end
  end

  describe '#==' do
    it 'считает равными прямые, заданные разными точками на одной линии' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(2, 2), Geo2d::Point.new(3, 3))
      expect(line1).to eq(line2)
    end

    it 'считает неравными параллельные прямые' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 1), Geo2d::Point.new(1, 2))
      expect(line1).not_to eq(line2)
    end
  end

  # 4. ГРАНИЧНЫЕ СЛУЧАИ И ОШИБКИ
  describe '#intersection_of_lines' do
    it 'находит точку пересечения двух прямых' do
      # y = 0 и x = 0 -> пересечение в (0, 0)
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 0))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(0, 1))

      intersection = line1.intersection_of_lines(line2)
      expect(intersection.x).to be_within(epsilon).of(0)
      expect(intersection.y).to be_within(epsilon).of(0)
    end

    it 'находит точку пересечения наклонных прямых' do
      # y = x и y = -x + 2 -> пересечение в (1, 1)
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(2, 2))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 2), Geo2d::Point.new(2, 0))

      intersection = line1.intersection_of_lines(line2)
      expect(intersection.x).to be_within(epsilon).of(1)
      expect(intersection.y).to be_within(epsilon).of(1)
    end

    it 'возвращает nil для параллельных несовпадающих прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(0, 1), Geo2d::Point.new(1, 2))

      expect(line1.intersection_of_lines(line2)).to be_nil
    end

    it 'возвращает self для совпадающих прямых' do
      line1 = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      line2 = Geo2d::Line.new(Geo2d::Point.new(2, 2), Geo2d::Point.new(3, 3))

      expect(line1.intersection_of_lines(line2)).to eq(line1)
    end

    it 'выбрасывает ошибку, если аргумент не Line' do
      line = Geo2d::Line.new(Geo2d::Point.new(0, 0), Geo2d::Point.new(1, 1))
      expect { line.intersection_of_lines('string') }.to raise_error(ArgumentError)
    end
  end

  describe 'floating point precision' do
    it 'корректно обрабатывает точки с плавающей точкой' do
      p1 = Geo2d::Point.new(0.1, 0.2)
      p2 = Geo2d::Point.new(0.3, 0.6)
      line = Geo2d::Line.new(p1, p2)

      # Точка должна лежать на прямой (y = 2x)
      expect(line.contains_point?(Geo2d::Point.new(0.2, 0.4))).to be true
    end
  end
end
