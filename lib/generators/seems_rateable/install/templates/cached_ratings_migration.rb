class CreateSeemsRateableCachedRatings < ActiveRecord::Migration
  def self.up
      create_table :seems_rateable_cached_ratings do |t|
        t.belongs_to :cacheable, :polymorphic => true
        t.float :avg, :null => false  
        t.integer :cnt, :null => false
        t.string :dimension
        t.integer :cacheable_id, :limit => 8
        t.string :cacheable_type
        t.timestamps
      end
    end

    def self.down
      drop_table :cached_ratings
    end  
end
