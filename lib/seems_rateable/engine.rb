module SeemsRateable
 class Engine < ::Rails::Engine
  isolate_namespace SeemsRateable
   
  config.generators do |g|
   g.test_framework :rspec, :fixture => false
	g.fixture_replacement :factory_girl, :dir => 'spec/factories'
  end
    
  initializer :seems_rateable do
	ActiveRecord::Base.send :include, SeemsRateable::Model
	ActionView::Base.send :include, SeemsRateable::Helpers
	ActionDispatch::Routing::Mapper.send :include, SeemsRateable::Routes
  end
       
 end
end
