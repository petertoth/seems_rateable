require_relative 'builder/html_options'

module SeemsRateable
  class Builder
    include ActionView::Helpers::TagHelper

    attr_reader :rateable, :options

    def self.build(rateable, options)
      new(rateable, options).build
    end

    def initialize(rateable, options)
      @rateable, @options = rateable, options
    end

    def build
      content_tag :div, nil, html_options
    end

    private

    def html_options
      HtmlOptions.new(rating, options).to_h
    end

    def rating
      rateable.rating dimension
    end

    def dimension
      options.delete(:dimension)
    end
  end
end
