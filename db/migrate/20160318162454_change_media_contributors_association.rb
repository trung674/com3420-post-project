class ChangeMediaContributorsAssociation < ActiveRecord::Migration
  def change
    change_table :media do |t|
      t.belongs_to :contributor, index: true
    end
  end
end
