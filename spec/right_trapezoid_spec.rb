# frozen_string_literal: true

require_relative '../lib/geo2d/right_trapezoid'
require_relative '../lib/geo2d/point'

module Geo2d
  RSpec.describe RightTrapezoid do
    def point(x, y) = Point.new(x, y)

    # 1. CONSTRUCTORS
    describe '.from_bases_and_height' do
      it 'creates a right trapezoid' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t).to be_a(RightTrapezoid)
        expect(t.base1).to eq(10)
        expect(t.base2).to eq(6)
        expect(t.height).to eq(4)
      end

      it 'raises error for offset (non-zero offset)' do
        expect { RightTrapezoid.from_bases_and_height(10, 6, 4, 2) }.to raise_error(ArgumentError)
      end

      it 'raises error for negative base1' do
        expect { RightTrapezoid.from_bases_and_height(-1, 5, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error for negative base2' do
        expect { RightTrapezoid.from_bases_and_height(5, -1, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error for negative height' do
        expect { RightTrapezoid.from_bases_and_height(5, 3, -1) }.to raise_error(ArgumentError)
      end
    end

    # 2. PROPERTIES
    describe '#area' do
      it 'returns correct area' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.area).to eq(32)
      end
    end

    describe '#perimeter' do
      it 'returns sum of sides' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        leg = Math.sqrt((4**2) + ((10 - 6)**2))
        expect(t.perimeter).to be_within(0.001).of(10 + 6 + leg + 4)
      end
    end

    describe '#midline' do
      it 'returns average of bases' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.midline).to eq(8)
      end
    end

    describe '#height' do
      it 'returns height' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.height).to eq(4)
      end
    end

    describe '#right_angle_leg' do
      it 'returns the leg perpendicular to bases' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.right_angle_leg).to eq(4)
      end
    end

    # 3. PREDICATES
    describe '#right_trapezoid?' do
      it 'returns true' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.right_trapezoid?).to be(true)
      end
    end

    describe '#has_right_angle?' do
      it 'returns true' do
        t = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.has_right_angle?).to be(true)
      end
    end

    # 4. EDGE CASES
    describe 'equality' do
      it 'compares two right trapezoids' do
        t1 = RightTrapezoid.from_bases_and_height(10, 6, 4)
        t2 = RightTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t1).to eq(t2)
      end

      it 'detects different dimensions' do
        t1 = RightTrapezoid.from_bases_and_height(10, 6, 4)
        t2 = RightTrapezoid.from_bases_and_height(12, 8, 5)
        expect(t1).not_to eq(t2)
      end
    end
  end
end