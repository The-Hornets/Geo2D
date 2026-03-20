# frozen_string_literal: true

require_relative '../lib/geo2d/vector'

describe Geo2d::Vector do
  # Создание через компоненты (не через точки!)
  let(:v1) { Geo2d::Vector.new(3, 4) }
  let(:v2) { Geo2d::Vector.new(1, 2) }

  describe '#initialize' do
    it 'хранит компоненты x и y' do
      expect(v1.x).to eq(3)
      expect(v1.y).to eq(4)
    end
  end

  describe '#==' do
    it 'равны если компоненты совпадают' do
      expect(Geo2d::Vector.new(3, 4)).to eq(Geo2d::Vector.new(3, 4))
    end
    it 'не равны если компоненты различаются' do
      expect(Geo2d::Vector.new(1, 2)).not_to eq(Geo2d::Vector.new(1, 1))
    end
  end

  describe '#+' do
    it 'складывает два вектора' do
      expect(v1 + v2).to eq(Geo2d::Vector.new(4, 6))
      expect(v2 + v1).to eq(Geo2d::Vector.new(4, 6))
    end
  end

  describe '#-' do
    it 'вычитает два вектора' do
      expect(v1 - v2).to eq(Geo2d::Vector.new(2, 2))
      expect(v2 - v1).to eq(Geo2d::Vector.new(-2, -2))
    end
  end

  describe '#*' do
    it 'умножает вектор на скаляр' do
      expect(v1 * 2).to eq(Geo2d::Vector.new(6, 8))
      expect(v2 * 2).to eq(Geo2d::Vector.new(2, 4))
    end
  end

  describe '#magnitude' do
    it 'возвращает длину вектора' do
      expect(v1.magnitude).to eq(5)
      expect(v2.magnitude).to be_within(Geo2d::EPSILON).of(Math.sqrt(5))
    end
  end

  describe '#dot' do
    it 'вычисляет скалярное произведение' do
      expect(v1.dot(v2)).to eq(11)
    end
  end

  describe '#cross' do
    it 'вычисляет псевдовекторное произведение' do
      expect(v1.cross(v2)).to eq(2)
    end
  end
  describe '#to_s' do
    it 'вектор инициализирован' do
      expect(v1.to_s).to eq('(3, 4)')
      expect(v2.to_s).to eq('(1, 2)')
    end
  end
end
