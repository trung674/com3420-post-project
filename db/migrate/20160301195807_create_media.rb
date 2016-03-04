class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :upload, null: true
      t.string :transcript, null: true
      t.boolean :public_ref
      t.boolean :education_use
      t.boolean :public_archive
      t.boolean :publication
      t.boolean :broadcasting
      t.boolean :editing

      t.timestamps null: false
    end
  end
end
