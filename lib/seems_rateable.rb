begin
  require 'rails'
rescue LoadError
end

require "jquery-rails"

require "seems_rateable/engine"
require "seems_rateable/errors"
require "seems_rateable/helpers"
require "seems_rateable/model"
require "seems_rateable/routes"
require "seems_rateable/version"

module SeemsRateable
end
