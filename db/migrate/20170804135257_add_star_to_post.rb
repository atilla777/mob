class AddStarToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :star, :integer, default: 0
  end
end
