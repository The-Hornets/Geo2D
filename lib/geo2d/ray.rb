# frozen_string_literal: true

require_relative 'point'
require_relative 'angle'

# Класс для работы с лучом (полупрямой)
class Ray
  attr_reader :origin, :direction_angle

  # Создаёт луч по начальной точке и углу направления
  def initialize(origin, direction_angle)
    raise ArgumentError, 'Origin must be a Point' unless origin.is_a?(Geo2d::Point)
    raise ArgumentError, 'Direction angle must be an Angle' unless direction_angle.is_a?(Angle)
    
    @origin = origin
    @direction_angle = direction_angle
  end

  # Создаёт луч по двум точкам
  def self.from_points(point1, point2)
    raise ArgumentError, 'Both arguments must be Point' unless point1.is_a?(Geo2d::Point) && point2.is_a?(Geo2d::Point)
    raise ArgumentError, 'Points must be distinct' if point1 == point2
    
    dx = point2.x - point1.x
    dy = point2.y - point1.y
    radians = Math.atan2(dy, dx)
    angle = Angle.new(radians)
    
    new(point1, angle)
  end

  # Возвращает единичный вектор направления
  def direction_vector
    x = Math.cos(direction_angle.radians)
    y = Math.sin(direction_angle.radians)
    Geo2d::Point.new(x, y)
  end

  # Возвращает точку на луче на заданном расстоянии от начала
  def point_at(distance)
    raise ArgumentError, 'distance must be non-negative' if distance < 0
    
    vector = direction_vector
    x = origin.x + vector.x * distance
    y = origin.y + vector.y * distance
    Geo2d::Point.new(x, y)
  end

  # Проверяет, принадлежит ли точка лучу
  def contains_point?(point)
    return false unless point.is_a?(Geo2d::Point)
    
    dx = point.x - origin.x
    dy = point.y - origin.y
    
    # Если точка совпадает с началом луча
    return true if dx.abs < 1e-10 && dy.abs < 1e-10
    
    # Вычисляем угол от начала луча до точки
    point_angle = Math.atan2(dy, dx)
    point_angle += 2 * Math::PI if point_angle < 0
    
    ray_angle = direction_angle.radians
    
    # Проверяем сонаправленность с учётом погрешности
    angle_diff = (point_angle - ray_angle).abs
    angle_diff = 2 * Math::PI - angle_diff if angle_diff > Math::PI
    
    # Проверяем, что точка лежит в том же направлении
    return false unless angle_diff < 1e-10
    
    # Проверяем, что точка не находится "перед" началом луча
    # Для этого проверяем, что скалярное произведение вектора направления
    # и вектора к точке положительно
    dir_vector = direction_vector
    dot_product = dx * dir_vector.x + dy * dir_vector.y
    
    dot_product > -1e-10
  end

  # Проверка параллельности двух лучей
  def parallel?(other)
    return false unless other.is_a?(Ray)
    
    angle1 = direction_angle.radians
    angle2 = other.direction_angle.radians
    
    diff = (angle1 - angle2).abs
    diff = 2 * Math::PI - diff if diff > Math::PI
    
    diff < 1e-10 || (diff - Math::PI).abs < 1e-10
  end

  # Проверка перпендикулярности двух лучей
  def perpendicular?(other)
    return false unless other.is_a?(Ray)
    
    angle1 = direction_angle.radians
    angle2 = other.direction_angle.radians
    
    diff = (angle1 - angle2).abs
    diff = 2 * Math::PI - diff if diff > Math::PI
    
    (diff - Math::PI / 2).abs < 1e-10
  end

  # Сравнение лучей
  def ==(other)
    return false unless other.is_a?(Ray)
    
    origin == other.origin && direction_angle == other.direction_angle
  end
end