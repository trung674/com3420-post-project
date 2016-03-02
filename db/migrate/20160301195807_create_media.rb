class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :location, null: true
      t.string :upload, null: true
      t.string :transcript, null: true
      t.date :orig_date, null: true
      t.boolean :approved, null: false, default: false

      t.timestamps null: false
    end
  end
end
