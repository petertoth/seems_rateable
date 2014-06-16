class CreateSeemsRateableRates < ActiveRecord::Migration
  def change
    create_table :seems_rateable_rates do |t|
      t.belongs_to :rater
      t.belongs_to :rateable, polymorphic: true
      t.float :stars, null: false
      t.string :dimension
      t.timestamps
    end

    add_index :seems_rateable_rates, :rater_id
    add_index :seems_rateable_rates, [:rateable_id, :rateable_type]
    add_index :seems_rateable_rates, :dimension
  end
end
