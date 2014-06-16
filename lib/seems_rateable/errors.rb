module SeemsRateable
  module Errors
    class InvalidRateableError < StandardError;end
    class NonExistentDimension < StandardError;end
    class NoCurrentRaterError < StandardError;end
  end
end
