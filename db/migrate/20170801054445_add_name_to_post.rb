class AddNameToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :name, :string
    add_index :posts, :name
  end
end
