class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.boolean :admin, default: false
      t.text :description

      t.timestamps
    end
    add_index :users, :name
  end
end
