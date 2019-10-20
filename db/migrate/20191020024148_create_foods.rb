class CreateFoods < ActiveRecord::Migration[5.2]
  def change
    create_table :foods do |t|
      t.string :name
      t.string :allergens
      t.string :diet
      t.string :serving
      t.string :calories
      t.string :fat
      t.string :fat_dv
      t.string :sat_fat
      t.string :sat_fat_dv
      t.string :trans_fat
      t.string :cholestrol
      t.string :cholestrol_dv
      t.string :sodium
      t.string :sodium_dv
      t.string :total_carb
      t.string :total_carb_dv
      t.string :dietary_fiber
      t.string :dietary_fiber_dv
      t.string :sugars
      t.string :sugars_dv
      t.string :protein
      t.string :protein_dv

      t.timestamps
    end
  end
end
