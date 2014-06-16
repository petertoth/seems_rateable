require 'generators/seems_rateable/migration_helpers'
require 'generators/seems_rateable/manifest_finder'
require 'fileutils'

module SeemsRateable
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include SeemsRateable::Generators::MigrationHelpers
      include SeemsRateable::Generators::ManifestFinder

      source_root File.expand_path('../templates', __FILE__)

      def routes
        route 'seems_rateable'
      end

      def javascript_assets
        Dir.mkdir 'app/assets/javascripts/rateable' unless File.directory?('app/assets/javascripts/rateable')

        copy_file 'rateable.js.erb', 'app/assets/javascripts/rateable/rateable.js.erb'
      end

      def migrations
        migration_template 'rates_migration.rb', 'db/migrate/create_seems_rateable_rates.rb'
      end

      def initializer
        template 'initializer.rb', 'config/initializers/seems_rateable.rb'
      end

      def require_stylesheet
        if File.binread(detect_css[0]).include? "require_self"
          insert_into_file detect_css[0], "\n#{detect_css[1]} require seems_rateable\n", after: /require_self/
        else
          prepend_to_file detect_css[0], "/*\n#{detect_css[1]} require seems_rateable\n*/\n"
        end
      end

      def require_javascript
        if File.binread(detect_js[0]).include? "require_tree"
          insert_into_file detect_js[0], "\n#{detect_js[1]} require seems_rateable\n#{detect_js[1]} require_directory ./rateable\n", after: /require_tree/
        else
          prepend_to_file detect_js[0], "\n#{detect_js[1]} require seems_rateable\n #{detect_js[1]} require_directory ./rateable\n"
        end
      end
    end
  end
end
