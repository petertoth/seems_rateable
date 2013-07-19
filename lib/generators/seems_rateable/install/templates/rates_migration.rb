class CreateSeemsRateableRates < ActiveRecord::Migration
  def self.up
    create_table :seems_rateable_rates do |t|
      t.belongs_to :rater
      t.belongs_to :rateable, :polymorphic => true
      t.float :stars, :null => false
      t.integer :rater_id, :limit => 8
      t.integer :rateable_id
      t.string :rateable_type
      t.string :dimension
      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end 
