require 'rails/generators/migration'
require 'fileutils'

class SeemsRateableGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)      
                                                       
  desc "Copying asset files ..."
  def assets
	 FileUtils.mkdir_p 'vendor/assets/images/rateable'
	 Dir::mkdir 'vendor/assets/stylesheets/rateable'
	 Dir::mkdir 'vendor/assets/javascripts/rateable'
	
	 copy_file 'images/bg_jRatingInfos.png', 'vendor/assets/images/rateable/bg_jRatingInfos.png'
	 copy_file 'images/small.png', 'vendor/assets/images/rateable/small.png'
	 copy_file 'images/stars.png', 'vendor/assets/images/rateable/stars.png'
			
	 copy_file 'stylesheets/jRating.jquery.css', 'vendor/assets/stylesheets/rateable/jRating.jquery.css'
	 copy_file 'javascripts/jRating.jquery.js.erb',  'vendor/assets/javascripts/rateable/jRating.jquery.js.erb'
	 copy_file 'javascripts/rateable.jquery.js.erb',  'vendor/assets/javascripts/rateable/rateable.jquery.js.erb'
	end         
  
  desc "Generating controller file ..."
  def controller
  	class_collisions 'RatingsController'
  	template "controller.rb", File.join('app/controllers', 'ratings_controller.rb')
  end
  
  desc "Generating model files ..."
  def models
		model_file = File.join('app/models', "#{file_path}.rb")
		raise "User model (#{model_file}) must exits." unless File.exists?(model_file)
		class_collisions 'Rate'
		class_collisions 'CachedRating'
		template 'model.rb', File.join('app/models', 'rate.rb')
		template 'cached_model.rb', File.join('app/models', 'cached_rating.rb')	
  end 
                                                                            
  desc "Creating route ..."
  def routegen
    route "resources :ratings, :only => :create"
  end

  desc "Generating migrations ..."
  def migrations
    migration_template "cached_rating_migration.rb", "db/migrate/create_cached_ratings.rb"
    migration_template "rate_migration.rb", "db/migrate/create_rates.rb"
  end
  
  desc "Creating needed database tables"
  def migrating
   rake("db:migrate")
  end
  
  private 
  def self.next_migration_number(dirname)
    #if ActiveRecord::Base.timestamped_migrations
    #  Time.now.utc.strftime("%Y%m%d%H%M%S%L")
    #else
      "%.3d" % (current_migration_number(dirname) + 1)
    #end    
  end
  
end  
         
