module SeemsRateable
  module Models
    module ActiveRecordExtension
      module Rater
        def rates_given(dimension=nil)
          super.where(dimension: dimension)
        end
      end
    end
  end
end
