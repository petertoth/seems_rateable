module SeemsRateable
  module Helpers
    module CurrentRater
      extend ActiveSupport::Concern

      def current_rater
        send SeemsRateable.config.current_rater_method
      end

      included do
        helper_method :current_rater
      end
    end
  end
end
