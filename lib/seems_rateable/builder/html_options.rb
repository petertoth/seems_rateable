module SeemsRateable
  class Builder
    class HtmlOptions
      attr_reader :rating, :options

      def initialize(rating, options)
        @rating, @options = rating, options
      end

      def to_h
        options[:class] = "#{klass} #{disabled}".strip
        options[:data] = options.fetch(:data, {}).merge(rating_attributes)
        options
      end

      private

      def rating_attributes
        rate_params.merge average: rating.average
      end

      # Avoids passing nil dimension to the data html attrbitutes
      # because it gets processed as data-dimension="null"
      def rate_params
        rating.rates.where_values_hash.keep_if { |k, v| v }
      end

      def klass
        options[:class] || SeemsRateable.config.default_selector_class
      end

      def disabled
        'jDisabled' if options[:disabled]
      end
    end
  end
end
