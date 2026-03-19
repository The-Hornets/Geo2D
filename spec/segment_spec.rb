# spec/segment_spec.rb
require_relative '../lib/geo2d'

describe Geo2d::Segment do
  let(:p1) { Geo2d::Point.new(0, 0) }
  let(:p2) { Geo2d::Point.new(3, 4) }
  let(:segment) { Geo2d::Segment.new(p1, p2) }

  describe '#initialize' do
    it 'хранит начальную и конечную точки' do
      expect(segment.start_point).to eq(p1)
      expect(segment.end_point).to eq(p2)
    end

    it 'выбрасывает ошибку для не-Point аргументов' do
      expect { Geo2d::Segment.new([0, 0], p2) }.to raise_error(ArgumentError)
    end
  end

  describe '.from_coords' do
    it 'создаёт отрезок из координат' do
      s = Geo2d::Segment.from_coords(1, 2, 3, 4)
      expect(s.start_point.x).to eq(1)
      expect(s.end_point.x).to eq(3)
    end
  end

  describe '#length' do
    it 'вычисляет длину (тройка 3-4-5)' do
      expect(segment.length).to be_within(0.0001).of(5.0)
    end

    it 'возвращает 0 для вырожденного отрезка' do
      s = Geo2d::Segment.new(p1, p1)
      expect(s.length).to eq(0)
    end
  end

  describe '#midpoint' do
    it 'возвращает середину отрезка' do
      s = Geo2d::Segment.from_coords(0, 0, 4, 6)
      expect(s.midpoint.x).to be_within(0.0001).of(2.0)
      expect(s.midpoint.y).to be_within(0.0001).of(3.0)
    end
  end

  describe '#contains_point?' do
    it 'содержит точку на отрезке' do
      expect(segment.contains_point?(Geo2d::Point.new(1.5, 2))).to be true
    end

    it 'содержит граничные точки' do
      expect(segment.contains_point?(p1)).to be true
      expect(segment.contains_point?(p2)).to be true
    end

    it 'не содержит точку за пределами' do
      expect(segment.contains_point?(Geo2d::Point.new(10, 10))).to be false
    end
  end

  describe '#==' do
    it 'равен отрезку с обратным порядком точек' do
      expect(Geo2d::Segment.new(p1, p2)).to eq(Geo2d::Segment.new(p2, p1))
    end
  end

  describe '#degenerate?' do
    it 'возвращает true для точки' do
      expect(Geo2d::Segment.new(p1, p1).degenerate?).to eq(true)
    end
  end
end
