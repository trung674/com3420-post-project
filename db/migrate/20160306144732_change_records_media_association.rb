class ChangeRecordsMediaAssociation < ActiveRecord::Migration
  def change
    remove_column :records, :media_id

    change_table :records do |t|
      t.belongs_to :medium, index: true
    end
  end
end
