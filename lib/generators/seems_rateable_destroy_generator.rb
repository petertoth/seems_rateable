require 'fileutils'
class SeemsRateableDestroyGenerator < Rails::Generators::Base

  def remove_asset_files    
    FileUtils.remove_dir('vendor/assets/stylesheets/rateable')
    FileUtils.remove_dir('vendor/assets/javascripts/rateable')
    FileUtils.remove_dir('vendor/assets/images/rateable')
  end
  
  def remove_model_files
    FileUtils.rm('app/models/rate.rb')
    FileUtils.rm('app/models/cached_rating.rb')
  end
  
   def remove_controller_file
    FileUtils.rm('app/controllers/ratings_controller.rb')
  end
  
end