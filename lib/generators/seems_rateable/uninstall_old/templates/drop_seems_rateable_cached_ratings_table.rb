class DropSeemsRateableCachedRatingsTable < ActiveRecord::Migration
  def self.up
    drop_table :seems_rateable_cached_ratings
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
