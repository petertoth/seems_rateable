module SeemsRateable
  module Helpers
    module ActionViewExtension
      def rating_for(rateable, options={})
        unless rateable.kind_of? Models::ActiveRecordExtension::Rateable
          raise Errors::InvalidRateableError, "#{rateable.inspect} is not a rateable" +
            " object, try adding 'seems_rateable' into your object's model"
        end

        if !current_rater || rateable.rated_by?(current_rater, options[:dimension])
          options[:disabled] = true
        end

        SeemsRateable::Builder.build(rateable, options)
      end
    end
  end
end
