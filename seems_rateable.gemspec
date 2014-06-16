$:.push File.expand_path("../lib", __FILE__)

require "seems_rateable/version"

Gem::Specification.new do |s|
  s.name        = "seems_rateable"
  s.version     = SeemsRateable::VERSION
  s.authors     = ["Peter Toth"]
  s.email       = ["peter@petertoth.me"]
  s.homepage    = "http://rateable.herokuapp.com"
  s.summary     = "Star Rating Engine"
  s.description = "Star rating engine using jQuery plugin jRating for Rails applications"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/**/*`.split("\n")

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "pry-rails"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "devise"

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "generator_spec"
end
