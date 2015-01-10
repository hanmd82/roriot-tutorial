class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.integer  :guid
      t.string   :label
      t.decimal  :lat, precision: 9, scale: 6
      t.decimal  :lng, precision: 9, scale: 6
      t.text     :description

      t.timestamps null: false
    end
  end
end
