class RemoveNameInDish < ActiveRecord::Migration[5.2]
  def change
  	remove_column :dishes, :name
  end
end
