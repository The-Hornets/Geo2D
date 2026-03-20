# frozen_string_literal: true

# Класс для работы с углами
class Angle
  attr_reader :radians

  # Создаёт угол в радианах с нормализацией в [0, 2π)
  def initialize(radians)
    @radians = radians % (2 * Math::PI)
  end

  # Создаёт угол из градусов
  def self.from_degrees(degrees)
    new(degrees * Math::PI / 180.0)
  end

  # Возвращает угол в градусах
  def degrees
    radians * 180.0 / Math::PI
  end

  # Проверка, является ли угол острым (< 90°)
  def acute?
    radians > 0 && radians < Math::PI / 2
  end

  # Проверка, является ли угол прямым (90°)
  def right?
    (radians - Math::PI / 2).abs < 1e-10
  end

  # Проверка, является ли угол тупым (> 90° и < 180°)
  def obtuse?
    radians > Math::PI / 2 && radians < Math::PI
  end

  # Проверка, является ли угол развёрнутым (180°)
  def straight?
    (radians - Math::PI).abs < 1e-10
  end

  # Проверка, является ли угол рефлекторным (> 180°)
  def reflex?
    radians > Math::PI
  end

  # Сравнение углов с учётом погрешности
  def ==(other)
    return false unless other.is_a?(Angle)
    (radians - other.radians).abs < 1e-10
  end
end