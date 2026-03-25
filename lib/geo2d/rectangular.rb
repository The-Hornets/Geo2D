# frozen_string_literal: true

module Geo2d
  module Rectangular
    def width
      raise NotImplementedError, 'Метод width должен быть реализован в классе'
    end

    def height
      raise NotImplementedError, 'Метод height должен быть реализован в классе'
    end

    def diagonal
      Math.sqrt((width**2) + (height**2))
    end

    def aspect_ratio
      return 1.0 if height.zero?

      width / height
    end

    def rectangular?
      true
    end
  end
end
