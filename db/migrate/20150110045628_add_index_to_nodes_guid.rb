class AddIndexToNodesGuid < ActiveRecord::Migration
  def change
    add_index :nodes, :guid, unique: true
  end
end
