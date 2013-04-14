# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seems_rateable/version'

Gem::Specification.new do |gem|
  gem.name          = "seems_rateable"
  gem.version       = SeemsRateable::VERSION
  gem.authors       = ["Peter Toth"]
  gem.email         = ["proximin@gmail.com"]
  gem.description   = %q{Star rating gem for Rails application using jQuery plugin jRating}
  gem.summary       = %q{Star rating gem for Rails application using jQuery plugin jRating}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  
  gem.add_runtime_dependency 'rails'
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency "rspec", "~> 2.6"
  
end
