module SeemsRateable
  class Engine < ::Rails::Engine
    isolate_namespace SeemsRateable

    initializer :seems_rateable do
      ::ActiveSupport.on_load(:active_record) { extend SeemsRateable::Models::ActiveRecordExtension }
      ::ActiveSupport.on_load(:action_view) { include SeemsRateable::Helpers::ActionViewExtension }
      ::ActiveSupport.on_load(:action_controller) { include SeemsRateable::Helpers::CurrentRater }
      ActionDispatch::Routing::Mapper.send :include, SeemsRateable::Routes
    end

    config.after_initialize do
      require 'seems_rateable/application_controller'
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
