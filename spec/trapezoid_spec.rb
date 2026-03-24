# frozen_string_literal: true

require_relative '../lib/geo2d/trapezoid'
require_relative '../lib/geo2d/point'

module Geo2d
  RSpec.describe Trapezoid do
    def point(x, y) = Point.new(x, y)

    # 1. CONSTRUCTORS
    describe '.from_bases_and_height' do
      it 'creates a trapezoid' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t).to be_a(Trapezoid)
        expect(t.base1).to eq(10)
        expect(t.base2).to eq(6)
        expect(t.height).to eq(4)
      end

      it 'creates with offset' do
        t = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(t.offset).to eq(2)
      end

      it 'raises error for negative values' do
        expect { Trapezoid.from_bases_and_height(-1, 5, 3) }.to raise_error(ArgumentError)
      end
    end

    # 2. PROPERTIES
    describe '#area' do
      it 'returns correct area' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.area).to eq(32)
      end
    end

    describe '#perimeter' do
      it 'returns sum of sides' do
        t = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        leg = Math.sqrt(16 + 4)
        expect(t.perimeter).to be_within(0.001).of(10 + 6 + leg + leg)
      end
    end

    describe '#midline' do
      it 'returns average of bases' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.midline).to eq(8)
      end
    end

    describe '#base1' do
      it 'returns first base' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.base1).to eq(10)
      end
    end

    describe '#base2' do
      it 'returns second base' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.base2).to eq(6)
      end
    end

    describe '#height' do
      it 'returns height' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.height).to eq(4)
      end
    end

    describe '#offset' do
      it 'returns offset' do
        t = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(t.offset).to eq(2)
      end
    end

    # 3. PREDICATES
    describe '#trapezoid?' do
      it 'returns true' do
        t = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t.trapezoid?).to be(true)
      end
    end

    describe '#isosceles?' do
      it 'returns true for isosceles' do
        t = Trapezoid.from_bases_and_height(10, 6, 4, 0)
        expect(t.isosceles?).to be(true)
      end

      it 'returns false for non-isosceles' do
        t = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(t.isosceles?).to be(false)
      end
    end

    describe '#parallelogram?' do
      it 'returns true for parallelogram' do
        t = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(t.parallelogram?).to be(true)
      end
    end

    describe '#rectangle?' do
      it 'returns true for rectangle' do
        t = Trapezoid.from_bases_and_height(10, 10, 10, 0)
        expect(t.rectangle?).to be(true)
      end
    end

    # 4. EDGE CASES
    describe 'equality' do
      it 'compares two trapezoids' do
        t1 = Trapezoid.from_bases_and_height(10, 6, 4)
        t2 = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(t1).to eq(t2)
      end
    end
  end
end
