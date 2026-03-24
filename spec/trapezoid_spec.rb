# frozen_string_literal: true

require_relative '../lib/geo2d/trapezoid'
require_relative '../lib/geo2d/point'

module Geo2d
  RSpec.describe Trapezoid do
    def point(x, y)
      Point.new(x, y)
    end

    # 1. CONSTRUCTORS
    describe '.from_bases_and_height' do
      it 'creates a trapezoid' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid).to be_a(Trapezoid)
        expect(trapezoid.base1).to eq(10)
        expect(trapezoid.base2).to eq(6)
        expect(trapezoid.height).to eq(4)
      end

      it 'creates a trapezoid with offset' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(trapezoid.offset).to eq(2)
      end

      it 'creates a parallelogram when bases are equal' do
        trapezoid = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(trapezoid.base1).to eq(8)
        expect(trapezoid.base2).to eq(8)
      end

      it 'raises error when base1 is not positive' do
        expect { Trapezoid.from_bases_and_height(-1, 5, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error when base2 is not positive' do
        expect { Trapezoid.from_bases_and_height(5, -1, 3) }.to raise_error(ArgumentError)
      end

      it 'raises error when height is not positive' do
        expect { Trapezoid.from_bases_and_height(5, 3, -1) }.to raise_error(ArgumentError)
      end
    end

    describe '#initialize' do
      it 'creates a trapezoid from four points' do
        p1 = point(0, 0)
        p2 = point(4, 0)
        p3 = point(3, 2)
        p4 = point(1, 2)
        trapezoid = Trapezoid.new(p1, p2, p3, p4)

        expect(trapezoid.vertices[0]).to eq(p1)
        expect(trapezoid.vertices[1]).to eq(p2)
        expect(trapezoid.vertices[2]).to eq(p3)
        expect(trapezoid.vertices[3]).to eq(p4)
      end
    end

    # 2. PROPERTIES
    describe '#area' do
      it 'returns correct area' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.area).to eq(32)
      end

      it 'returns correct area for parallelogram' do
        trapezoid = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(trapezoid.area).to eq(40)
      end
    end

    describe '#perimeter' do
      it 'returns positive perimeter' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.perimeter).to be > 0
      end

      it 'returns sum of all sides' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        leg_length = Math.sqrt(4**2 + 2**2)
        expected = 10 + 6 + leg_length + leg_length
        expect(trapezoid.perimeter).to be_within(0.001).of(expected)
      end
    end

    describe '#midline' do
      it 'returns average of bases' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.midline).to eq(8)
      end
    end

    describe '#base1' do
      it 'returns first base' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.base1).to eq(10)
      end
    end

    describe '#base2' do
      it 'returns second base' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.base2).to eq(6)
      end
    end

    describe '#height' do
      it 'returns height' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.height).to eq(4)
      end
    end

    describe '#offset' do
      it 'returns offset' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(trapezoid.offset).to eq(2)
      end

      it 'returns zero when no offset' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.offset).to eq(0)
      end
    end

    # 3. PREDICATES
    describe '#trapezoid?' do
      it 'returns true for trapezoid' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.trapezoid?).to be(true)
      end

      it 'returns true for parallelogram' do
        trapezoid = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(trapezoid.trapezoid?).to be(true)
      end
    end

    describe '#isosceles?' do
      it 'returns true for isosceles trapezoid (offset = 0)' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 0)
        expect(trapezoid.isosceles?).to be(true)
      end

      it 'returns false for non-isosceles trapezoid' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(trapezoid.isosceles?).to be(false)
      end

      it 'returns false for parallelogram' do
        trapezoid = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(trapezoid.isosceles?).to be(false)
      end
    end

    describe '#parallelogram?' do
      it 'returns true for parallelogram' do
        trapezoid = Trapezoid.from_bases_and_height(8, 8, 5)
        expect(trapezoid.parallelogram?).to be(true)
      end

      it 'returns false for non-parallelogram' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4, 2)
        expect(trapezoid.parallelogram?).to be(false)
      end
    end

    describe '#rectangle?' do
      it 'returns true for rectangle' do
        rectangle = Trapezoid.from_bases_and_height(10, 10, 10, 0)
        expect(rectangle.rectangle?).to be(true)
      end
    end

    describe '#square?' do
      it 'returns true for square' do
        square = Trapezoid.from_bases_and_height(5, 5, 5, 0)
        expect(square.square?).to be(true)
      end
    end

    describe '#valid?' do
      it 'returns true for valid trapezoid' do
        trapezoid = Trapezoid.from_bases_and_height(10, 6, 4)
        expect(trapezoid.valid?).to be(true)
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

    describe 'different shapes' do
      it 'handles different dimensions' do
        t1 = Trapezoid.from_bases_and_height(10, 6, 4)
        t2 = Trapezoid.from_bases_and_height(12, 8, 5)
        expect(t1).not_to eq(t2)
      end
    end
  end
end