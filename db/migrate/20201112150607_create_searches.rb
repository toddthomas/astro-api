class CreateSearches < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :model_class_name, null: false
      t.string :constellation_abbreviation, null: true
      t.float :limiting_magnitude, null: true
      t.bigint :max_results, default: 100, null: false

      t.timestamps
    end
  end
end
