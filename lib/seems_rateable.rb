begin
  require 'rails'
rescue LoadError
end

require 'seems_rateable/engine'
require 'seems_rateable/configuration'

require 'jquery-rails'

module SeemsRateable
  autoload :Errors, 'seems_rateable/errors'
  autoload :Builder, 'seems_rateable/builder'
  autoload :Routes, 'seems_rateable/routes'
  autoload :Rating, 'seems_rateable/rating'

  module Helpers
    autoload :ActionViewExtension, 'seems_rateable/helpers/action_view_extension'
    autoload :HtmlOptions, 'seems_rateable/helpers/html_options'
    autoload :CurrentRater, 'seems_rateable/helpers/current_rater'
  end

  module Models
    autoload :ActiveRecordExtension, 'seems_rateable/models/active_record_extension'

    module ActiveRecordExtension
      autoload :Rateable, 'seems_rateable/models/active_record_extension/rateable'
      autoload :Rater, 'seems_rateable/models/active_record_extension/rater'
    end
  end
end
