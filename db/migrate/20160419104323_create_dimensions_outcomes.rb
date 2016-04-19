class CreateDimensionsOutcomes < ActiveRecord::Migration
  def change
    create_table :dimensions_outcomes do |t|
      t.string :name
      t.boolean :successful, default: false

      t.timestamps null: false
    end

    add_index :dimensions_outcomes, :name, unique: true
  end
end
