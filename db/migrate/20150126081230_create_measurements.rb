class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.string     :type
      t.references :node, index: true
      t.integer    :node_guid
      t.integer    :recorded_at
      t.integer    :sequence_number
      t.text       :data

      t.timestamps null: false
    end
    add_foreign_key :measurements, :nodes # foreign key constraints to guarantee referential integrity
    add_index       :measurements, [:node_id, :recorded_at] # expect to retrieve all measurements associated with a given node in reverse order of recorded timestamp
  end
end
