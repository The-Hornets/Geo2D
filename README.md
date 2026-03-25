# 📐 Geo2D

**Geo2D** is a Ruby gem that provides a simple API for creating and manipulating 2D geometric shapes. It includes classes for points, segments, polygons, and other shapes, allowing you to calculate their properties (area, perimeter, diagonals) and perform geometric transformations.

---

## 🚀 Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add geo2d
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install geo2d
```

---

## 🛠 Usage

```ruby
require_relative 'lib/geo2d'

# Point
point = Geo2d::Point.new(3, 4)
point.distance_to(Geo2d::Point.new(0, 0))  # => 5.0

# Segment
segment = Geo2d::Segment.new(
  Geo2d::Point.new(0, 0),
  Geo2d::Point.new(4, 3)
)
segment.length    # => 5.0
segment.midpoint  # => Point(2.0, 1.5)

# Angle
angle = Geo2d::Angle.new(Math::PI / 4)
angle.degrees     # => 45.0
angle.acute?      # => true

# Ray
ray = Geo2d::Ray.from_points(
  Geo2d::Point.new(0, 0),
  Geo2d::Point.new(1, 1)
)
ray.contains_point?(Geo2d::Point.new(2, 2))  # => true

# Circle (Boundary)
circle = Geo2d::Circle.new(Geo2d::Point.new(0, 0), 5)
circle.area         # => 78.54
circle.circumference # => 31.42

# Disk (Filled area)
disk = Geo2d::Disk.new(Geo2d::Point.new(0, 0), 5)
disk.contains_point?(Geo2d::Point.new(3, 4))  # => true

# Regular Polygon
pentagon = Geo2d::RegularPolygon.new(5, Geo2d::Point.new(0, 0), 5)
pentagon.area       # => 59.44
pentagon.perimeter  # => 29.39

# Rectangle
rectangle = Geo2d::Rectangle.from_sides(4, 3)
rectangle.area      # => 12.0
rectangle.diagonal  # => 5.0
```

---

## 📚 Classes and Methods

### Level 0 — Basic Primitives
| Class | Methods |
| :--- | :--- |
| `Geo2d::Point` | `#x`, `#y`, `#distance_to`, `#==`, `#to_s` |
| `Geo2d::Angle` | `#radians`, `#degrees`, `#acute?`, `#right?`, `#obtuse?`, `#straight?`, `#reflex?`, `#==` |

---

### Level 1 — Linear Objects
| Class | Methods |
| :--- | :--- |
| `Geo2d::Segment` | `#start_point`, `#end_point`, `#length`, `#midpoint`, `#direction`, `#contains_point?`, `#degenerate?`, `#==` |
| `Geo2d::Line` | `#point1`, `#point2`, `#slope`, `#coef_a`, `#coef_b`, `#coef_c`, `#contains_point?`, `#parallel?`, `#perpendicular?`, `#intersection_of_lines`, `#==` |
| `Geo2d::Ray` | `#origin`, `#direction_angle`, `#direction_vector`, `#point_at`, `#contains_point?`, `#parallel?`, `#perpendicular?`, `#==` |

---

### Level 2 — Circular Shapes
| Class | Methods |
| :--- | :--- |
| `Geo2d::Circle` | `#center`, `#radius`, `#diameter`, `#area`, `#circumference`, `#perimeter`, `#contains_point?`, `#intersects_circle?`, `#tangent_to_circle?`, `#==` |
| `Geo2d::Disk` | `#center`, `#radius`, `#diameter`, `#area`, `#circumference`, `#boundary`, `#contains_point?`, `#contains_circle?`, `#contains_disk?`, `#intersects_disk?`, `#==` |

---

### Level 3 — Polygons
| Class | Methods |
| :--- | :--- |
| `Geo2d::Polygon` | `#vertices`, `#vertices_count`, `#perimeter`, `#valid?` *(abstract)* |
| `Geo2d::RegularPolygon` | `#n`, `#center`, `#radius`, `#side_length`, `#area`, `#interior_angle`, `#exterior_angle`, `#apothem`, `#angles`, `#vertices`, `#contains_point?`, `#convex?`, `#valid?`, `#==` |
| `Geo2d::Rectangle` | `#width`, `#height`, `#area`, `#perimeter`, `#angles`, `#side_lengths`, `#diagonal`, `#angle_between_sides`, `#valid?` |

---

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

---

## 🤖 CI/CD 
The project utilizes an automated development lifecycle via GitHub Actions:
* RSpec Testing: Automatically runs tests on every push or Pull Request
* RuboCop: Ensures code follows the Style Guide and best practices
* Gem Build: Verifies the gem builds correctly to prevent broken releases


---

## 📜 License

The gem is available as open source under the terms of the [MIT License](LICENSE).
