# frozen_string_literal: true

require_relative '../lib/geo2d/point'

describe Geo2d::Point do
  describe '#initialize' do
    it 'хранит координаты x и y' do
      point = Geo2d::Point.new(3, 5)
      expect(point.x).to eq(3)
      expect(point.y).to eq(5)
    end
  end
  describe '#==' do
    it 'равны если координаты совпадают' do
      point1 = Geo2d::Point.new(1, -3)
      point2 = Geo2d::Point.new(1, -3)
      expect(point1).to eq(point2)
    end

    it 'не равны если координаты различаются' do
      point1 = Geo2d::Point.new(3, 4)
      point2 = Geo2d::Point.new(-7, -8)
      expect(point1).not_to eq(point2)
    end
  end

  describe '#distance_to' do
    it 'Точки совпадают' do
      point1 = Geo2d::Point.new(1, -3)
      point2 = Geo2d::Point.new(1, -3)
      expect(point1.distance_to(point2)).to eq(0)
    end
    it 'Точки не совпадают' do
      point1 = Geo2d::Point.new(0, 0)
      point2 = Geo2d::Point.new(3, 4)
      expect(point1.distance_to(point2)).to eq(5)
    end
  end
  describe '#to_s' do
    it 'Точка инициализирована' do
      point = Geo2d::Point.new(5, 6)
      expect(point.to_s).to eq('(5, 6)')
    end
  end
end
