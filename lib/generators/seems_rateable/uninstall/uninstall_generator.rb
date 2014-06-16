require 'generators/seems_rateable/migration_helpers'
require 'generators/seems_rateable/manifest_finder'

module SeemsRateable
  module Generators
    class UninstallGenerator < ::Rails::Generators::Base
      include SeemsRateable::Generators::MigrationHelpers
      include SeemsRateable::Generators::ManifestFinder

      source_root File.expand_path('../templates', __FILE__)

      def comment_route
        comment_lines 'config/routes.rb', /seems_rateable/
      end

      def remove_initializer
        remove_file 'config/initializers/seems_rateable.rb'
      end

      def remove_javascripts
        remove_dir 'app/assets/javascripts/rateable/'
      end

      def drop_table
        migration_template 'drop_seems_rateable_rates_table.rb', 'db/migrate/drop_seems_rateable_rates_table.rb'

        rake 'db:migrate' if yes?('Run rake db:migrate?')

        Dir.glob('db/migrate/*').keep_if { |f| f.include?('seems') }.each do |file|
            remove_file(file)
          end if yes?('Remove also remaining seems_rateable migration files?')
      end

      def remove_require_from_stylesheet
        gsub_file detect_css[0], /require seems_rateable/, ''
      end

      def remove_require_from_javascript
        gsub_file detect_js[0], /require seems_rateable/, ''
        gsub_file detect_js[0], /require_directory .\/rateable/, ''
      end

      def comment_seems_rateable_in_models
        Dir.glob('app/models/*').keep_if { |f| File.extname(f) == '.rb' }.each do |model|
          comment_lines model, /seems_rateable/ if File.binread(model).include? 'seems_rateable'
        end
      end
    end
  end
end
