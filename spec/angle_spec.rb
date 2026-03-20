require_relative '../../lib/geo2d/angle'

describe Angle do
  # 1. КОНСТРУКТОРЫ
  describe '#initialize' do
    it 'создаёт угол с радианами' do
      angle = Angle.new(Math::PI)
      expect(angle.radians).to eq(Math::PI)
    end

    it 'нормализует угол в диапазон [0, 2π)' do
      angle1 = Angle.new(3 * Math::PI)
      angle2 = Angle.new(-Math::PI / 2)
      expect(angle1.radians).to be_within(1e-10).of(Math::PI)
      expect(angle2.radians).to be_within(1e-10).of(3 * Math::PI / 2)
    end
  end

  describe '.from_degrees' do
    it 'создаёт угол из градусов' do
      angle = Angle.from_degrees(180)
      expect(angle.radians).to be_within(1e-10).of(Math::PI)
    end

    it 'нормализует градусы > 360' do
      angle = Angle.from_degrees(540)
      expect(angle.radians).to be_within(1e-10).of(Math::PI)
    end

    it 'нормализует отрицательные градусы' do
      angle = Angle.from_degrees(-90)
      expect(angle.radians).to be_within(1e-10).of(3 * Math::PI / 2)
    end
  end
    # 2. СВОЙСТВА
  describe '#degrees' do
    it 'возвращает угол в градусах' do
      angle = Angle.new(Math::PI / 2)
      expect(angle.degrees).to be_within(1e-10).of(90)
    end

    it 'возвращает нормализованное значение для углов > 360°' do
      angle = Angle.from_degrees(450)
      expect(angle.degrees).to be_within(1e-10).of(90)
    end
  end
   # 3. ПРЕДИКАТЫ
  describe '#acute?' do
    it 'возвращает true для острого угла (< 90°)' do
      expect(Angle.new(Math::PI / 4)).to be_acute
    end

    it 'возвращает false для прямого угла' do
      expect(Angle.new(Math::PI / 2)).not_to be_acute
    end

    it 'возвращает false для тупого угла' do
      expect(Angle.new(3 * Math::PI / 4)).not_to be_acute
    end
  end

  describe '#right?' do
    it 'возвращает true для прямого угла (90°)' do
      expect(Angle.new(Math::PI / 2)).to be_right
    end

    it 'возвращает false для острого угла' do
      expect(Angle.new(Math::PI / 4)).not_to be_right
    end

    it 'возвращает false для тупого угла' do
      expect(Angle.new(3 * Math::PI / 4)).not_to be_right
    end
  end

  describe '#obtuse?' do
    it 'возвращает true для тупого угла (90° < angle < 180°)' do
      expect(Angle.new(3 * Math::PI / 4)).to be_obtuse
    end

    it 'возвращает false для острого угла' do
      expect(Angle.new(Math::PI / 4)).not_to be_obtuse
    end

    it 'возвращает false для прямого угла' do
      expect(Angle.new(Math::PI / 2)).not_to be_obtuse
    end
  end

  describe '#straight?' do
    it 'возвращает true для развёрнутого угла (180°)' do
      expect(Angle.new(Math::PI)).to be_straight
    end

    it 'возвращает false для других углов' do
      expect(Angle.new(Math::PI / 2)).not_to be_straight
    end
  end

  describe '#reflex?' do
    it 'возвращает true для рефлекторного угла (> 180°)' do
      expect(Angle.new(5 * Math::PI / 4)).to be_reflex
    end

    it 'возвращает false для угла <= 180°' do
      expect(Angle.new(Math::PI)).not_to be_reflex
    end
  end
    
    

  
