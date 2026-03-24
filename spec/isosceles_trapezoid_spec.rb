# frozen_string_literal: true

require_relative '../lib/geo2d/isosceles_trapezoid'
require_relative '../lib/geo2d/point'

module Geo2d
  RSpec.describe IsoscelesTrapezoid do
    def point(x, y) = Point.new(x, y)

    # 1. CONSTRUCTORS
    describe '.from_bases_and_height' do
      it 'creates an isosceles trapezoid' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t).to be_a(IsoscelesTrapezoid)
        expect(t.base1).to eq(10)
        expect(t.base2).to eq(6)
        expect(t.height).to eq(4)
      end

      it 'raises error for negative base1' do
        expect { IsoscelesTrapezoid.from_bases_and_height(-1, 5, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error for negative base2' do
        expect { IsoscelesTrapezoid.from_bases_and_height(5, -1, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error for negative height' do
        expect { IsoscelesTrapezoid.from_bases_and_height(5, 3, -1) }.to raise_error(ArgumentError)
      end
    end

    # 2. PROPERTIES
    describe '#area' do
      it 'returns correct area' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.area).to eq(32)
      end
    end

    describe '#perimeter' do
      it 'returns sum of sides' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        leg = Math.sqrt((4**2) + (((10 - 6) / 2.0)**2))
        expect(t.perimeter).to be_within(0.001).of(10 + 6 + leg + leg)
      end
    end

    describe '#midline' do
      it 'returns average of bases' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.midline).to eq(8)
      end
    end

    describe '#height' do
      it 'returns height' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.height).to eq(4)
      end
    end

    describe '#leg' do
      it 'returns leg length' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expected_leg = Math.sqrt((4**2) + (((10 - 6) / 2.0)**2))
        expect(t.leg).to be_within(0.001).of(expected_leg)
      end
    end

    # 3. PREDICATES
    describe '#isosceles?' do
      it 'returns true' do
        t = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t.isosceles?).to be(true)
      end
    end

    # 4. EDGE CASES
    describe 'equality' do
      it 'compares two isosceles trapezoids' do
        t1 = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        t2 = IsoscelesTrapezoid.from_bases_and_height(10, 6, 4)
        expect(t1).to eq(t2)
      end
    end
  end
end
