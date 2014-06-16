require 'generators/seems_rateable/migration_helpers'

module SeemsRateable
  module Generators
    class UninstallOld < ::Rails::Generators::Base
      include SeemsRateable::Generators::MigrationHelpers

      source_root File.expand_path('../templates', __FILE__)

      def drop_tables
        (ActiveRecord::Migration.tables & %w[seems_rateable_rates seems_rateable_cached_ratings]).each do |table|
          migration_template "drop_#{table}_table.rb", "db/migrate/drop_#{table}_table"
        end

        rake 'db:migrate' if yes?('Run rake db:migrate? To drop seems_rateable tables')

        Dir.glob('db/migrate/*').keep_if { |f| f.include?('seems_rateable') }.each do |file|
            remove_file(file)
          end if yes?('Remove also remaining seems_rateable migration files?')
      end

      def remove_initializer
        remove_file 'config/initializers/seems_rateable.rb'
      end

      def remove_javascripts
        remove_dir 'app/assets/javascripts/rateable/'
      end

      def remove_stylesheet_include_in_template
        %w[erb haml slim].each do |extension|

          file = 'app/views/layouts/application.html.' + extension

          if File.exists?(file)
            gsub_file file, /seems_rateable_stylesheet/, ''
          end
        end
      end

      def comment_seems_rateable_in_models
        Dir.glob('app/models/*').keep_if { |f| File.extname(f) == '.rb' }.each do |model|
          comment_lines model, /seems_rateable/
        end
      end
    end
  end
end
