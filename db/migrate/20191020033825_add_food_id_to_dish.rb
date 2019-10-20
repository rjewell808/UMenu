class AddFoodIdToDish < ActiveRecord::Migration[5.2]
  def change
  	add_column :dishes, :food_id, :integer
  end
end
