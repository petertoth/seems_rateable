$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "seems_rateable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "seems_rateable"
  s.version     = SeemsRateable::VERSION
  s.authors     = ["Peter Toth"]
  s.email       = ["proximin@gmail.com"]
  s.homepage    = "http://rateable.herokuapp.com"
  s.summary     = "Star Rating Engine"
  s.description = "Star rating engine using jQuery plugin jRating for Rails applications"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
