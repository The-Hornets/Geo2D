require_relative '../lib/geo2d'

def test_segment
  tests_passed = 0
  total_tests = 0
  
  puts "\nTesting Segment..."
  puts "=" * 40
  
  # Test 1: Create segment from two Points
  total_tests += 1
  begin
    p1 = Geo2D::Point.new(0, 0)
    p2 = Geo2D::Point.new(3, 4)
    segment = Geo2D::Segment.new(p1, p2)
    if segment.start_point == p1 && segment.end_point == p2
      tests_passed += 1
      puts "✓ Test 1 passed: Create segment from two Points"
    else
      puts "✗ Test 1 failed: Points incorrect"
    end
  rescue => e
    puts "✗ Test 1 failed: #{e.message}"
  end
  
  # Test 2: from_coords constructor
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(1, 2, 3, 4)
    if segment.start_point.x == 1 && segment.end_point.x == 3
      tests_passed += 1
      puts "✓ Test 2 passed: from_coords constructor"
    else
      puts "✗ Test 2 failed: from_coords incorrect"
    end
  rescue => e
    puts "✗ Test 2 failed: #{e.message}"
  end
  
  # Test 3: Length calculation (3-4-5 triangle)
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 0, 3, 4)
    length = segment.length
    if (length - 5.0).abs < 0.0001
      tests_passed += 1
      puts "✓ Test 3 passed: Length calculation"
    else
      puts "✗ Test 3 failed: Length incorrect (got #{length})"
    end
  rescue => e
    puts "✗ Test 3 failed: #{e.message}"
  end
  
  # Test 4: Zero length for identical points
  total_tests += 1
  begin
    p = Geo2D::Point.new(1, 1)
    segment = Geo2D::Segment.new(p, p)
    if segment.length == 0
      tests_passed += 1
      puts "✓ Test 4 passed: Zero length for identical points"
    else
      puts "✗ Test 4 failed: Zero length incorrect"
    end
  rescue => e
    puts "✗ Test 4 failed: #{e.message}"
  end
  
  # Test 5: Midpoint calculation
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 0, 4, 6)
    mid = segment.midpoint
    if mid.x == 2.0 && mid.y == 3.0
      tests_passed += 1
      puts "✓ Test 5 passed: Midpoint calculation"
    else
      puts "✗ Test 5 failed: Midpoint incorrect"
    end
  rescue => e
    puts "✗ Test 5 failed: #{e.message}"
  end
  
  # Test 6: Direction vector
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(1, 1, 4, 5)
    dir = segment.direction
    if dir.x == 3 && dir.y == 4
      tests_passed += 1
      puts "✓ Test 6 passed: Direction vector"
    else
      puts "✗ Test 6 failed: Direction incorrect"
    end
  rescue => e
    puts "✗ Test 6 failed: #{e.message}"
  end
  
  # Test 7: contains_point? for point on segment
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 0, 4, 4)
    mid = Geo2D::Point.new(2, 2)
    if segment.contains_point?(mid)
      tests_passed += 1
      puts "✓ Test 7 passed: contains_point? for point on segment"
    else
      puts "✗ Test 7 failed: contains_point? incorrect"
    end
  rescue => e
    puts "✗ Test 7 failed: #{e.message}"
  end
  
  # Test 8: contains_point? includes endpoints
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 0, 3, 4)
    if segment.contains_point?(segment.start_point) && 
       segment.contains_point?(segment.end_point)
      tests_passed += 1
      puts "✓ Test 8 passed: contains_point? includes endpoints"
    else
      puts "✗ Test 8 failed: Endpoints not included"
    end
  rescue => e
    puts "✗ Test 8 failed: #{e.message}"
  end
  
  # Test 9: contains_point? for point outside
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 0, 2, 2)
    outside = Geo2D::Point.new(10, 10)
    if !segment.contains_point?(outside)
      tests_passed += 1
      puts "✓ Test 9 passed: contains_point? for point outside"
    else
      puts "✗ Test 9 failed: Outside point incorrectly included"
    end
  rescue => e
    puts "✗ Test 9 failed: #{e.message}"
  end
  
  # Test 10: Segment equality (order-independent)
  total_tests += 1
  begin
    p1 = Geo2D::Point.new(0, 0)
    p2 = Geo2D::Point.new(3, 4)
    seg1 = Geo2D::Segment.new(p1, p2)
    seg2 = Geo2D::Segment.new(p2, p1)
    if seg1 == seg2
      tests_passed += 1
      puts "✓ Test 10 passed: Segment equality (order-independent)"
    else
      puts "✗ Test 10 failed: Equality incorrect"
    end
  rescue => e
    puts "✗ Test 10 failed: #{e.message}"
  end
  
  # Test 11: degenerate? for zero-length segment
  total_tests += 1
  begin
    p = Geo2D::Point.new(1, 1)
    segment = Geo2D::Segment.new(p, p)
    if segment.degenerate?
      tests_passed += 1
      puts "✓ Test 11 passed: degenerate? for zero-length"
    else
      puts "✗ Test 11 failed: degenerate? incorrect"
    end
  rescue => e
    puts "✗ Test 11 failed: #{e.message}"
  end
  
  # Test 12: Reject non-Point arguments
  total_tests += 1
  begin
    Geo2D::Segment.new([0, 0], Geo2D::Point.new(1, 1))
    puts "✗ Test 12 failed: Should reject non-Point"
  rescue ArgumentError
    tests_passed += 1
    puts "✓ Test 12 passed: Reject non-Point arguments"
  rescue => e
    puts "✗ Test 12 failed: Wrong error type"
  end
  
  # Test 13: Vertical segment
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(2, 0, 2, 5)
    if segment.length == 5.0 && segment.contains_point?(Geo2D::Point.new(2, 3))
      tests_passed += 1
      puts "✓ Test 13 passed: Vertical segment"
    else
      puts "✗ Test 13 failed: Vertical segment incorrect"
    end
  rescue => e
    puts "✗ Test 13 failed: #{e.message}"
  end
  
  # Test 14: Horizontal segment
  total_tests += 1
  begin
    segment = Geo2D::Segment.from_coords(0, 3, 5, 3)
    if segment.length == 5.0 && segment.contains_point?(Geo2D::Point.new(3, 3))
      tests_passed += 1
      puts "✓ Test 14 passed: Horizontal segment"
    else
      puts "✗ Test 14 failed: Horizontal segment incorrect"
    end
  rescue => e
    puts "✗ Test 14 failed: #{e.message}"
  end
  
  puts "=" * 40
  if tests_passed == total_tests
    puts "All Segment tests passed! (#{tests_passed}/#{total_tests})"
  else
    puts "Tests passed: #{tests_passed}/#{total_tests}"
  end
  puts "=" * 40
  
  tests_passed == total_tests
end