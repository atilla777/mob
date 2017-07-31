class AddFieldsToPost < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :user, foreign_key: true
    add_column :posts, :body, :text
  end
end
