class CreateDishes < ActiveRecord::Migration[5.2]
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :meal
      t.date :date
      t.string :day

      t.timestamps
    end
  end
end
