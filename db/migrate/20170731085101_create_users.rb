class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :admin, default: false
      t.text :description

      t.timestamps
    end
    add_index :users, :name
    add_index :users, :email
  end
end
