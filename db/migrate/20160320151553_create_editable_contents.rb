class CreateEditableContents < ActiveRecord::Migration
  def change
    create_table :editable_contents do |t|
      t.string :name
      t.text :content

      t.timestamps null: false
    end
  end
end
