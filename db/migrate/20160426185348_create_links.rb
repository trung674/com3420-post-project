class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :med_one
      t.integer :med_two

      t.timestamps null: false
    end
  end
end
