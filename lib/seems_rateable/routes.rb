module SeemsRateable
  module Routes
    def seems_rateable
      mount SeemsRateable::Engine => '/rateable', as: 'seems_rateable'
    end
  end
end
