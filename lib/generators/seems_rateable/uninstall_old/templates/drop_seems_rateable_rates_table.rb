class DropSeemsRateableRatesTable < ActiveRecord::Migration
  def self.up
    drop_table :seems_rateable_rates
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
