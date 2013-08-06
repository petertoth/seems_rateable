require 'rails/generators/migration'
require 'fileutils'

module SeemsRateable
 module Generators
  class InstallGenerator < ::Rails::Generators::Base
   include Rails::Generators::Migration
	source_root File.expand_path('../templates', __FILE__)
	
   def self.next_migration_number(path)
	 unless @prev_migration_nr
	  @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
	 else
	  @prev_migration_nr += 1
	 end
	 @prev_migration_nr.to_s
	end
			
	def routegen
	 route("seems_rateable")
	end
			
	desc "generating migration files"
	 def copy_migrations
	  migration_template "rates_migration.rb", "db/migrate/create_seems_rateable_rates.rb"
	  migration_template "cached_ratings_migration.rb", "db/migrate/create_seems_rateable_cached_ratings.rb"
	 end
			
  	desc "generating initializer"
	 def copy_initializer
	  template "initializer.rb", "config/initializers/seems_rateable.rb"
	 end
			
	desc "generating javascript files"
	 def copy_javascript_asset
	  Dir.mkdir "app/assets/javascripts/rateable" unless File.directory?("app/assets/javascripts/rateable")
	  copy_file "rateable.js.erb", "app/assets/javascripts/rateable/rateable.js.erb" unless File.exists?("app/assets/javascripts/rateable/rateable.js.erb")
	  copy_file "jRating.js.erb", "app/assets/javascripts/rateable/jRating.js.erb" unless File.exists?("app/assets/javascripts/rateable/jRating.js.erb")
	 end
  end
 end
end
