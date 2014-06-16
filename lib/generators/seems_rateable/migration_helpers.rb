require 'rails/generators/migration'

module SeemsRateable
  module Generators
    module MigrationHelpers
      extend ActiveSupport::Concern

      included do
        include ::Rails::Generators::Migration

        def self.next_migration_number(dirname)
          if ActiveRecord::Base.timestamped_migrations
            Time.now.utc.strftime("%Y%m%d%H%M%S%6N")
          else
            "%.3d" % (current_migration_number(dirname) + 1)
          end
        end
      end
    end
  end
end
