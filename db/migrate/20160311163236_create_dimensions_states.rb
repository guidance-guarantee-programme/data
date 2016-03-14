class CreateDimensionsStates < ActiveRecord::Migration
  def change
    create_table :dimensions_states do |t|
      t.string :name, null: false
      t.boolean :default, value: false
      t.timestamps null: false
    end
    add_reference :facts_appointments, :dimensions_state
  end
end
