class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :media, index: true
      t.string :title
      t.string :description
      t.string :location
      t.date :ref_date
      t.boolean :approved, default: false

      t.timestamps null: false
    end
  end
end
