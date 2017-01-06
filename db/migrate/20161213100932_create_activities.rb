class CreateActivities < ActiveRecord::Migration[5.0]
  def change
    create_table :activities do |t|
      t.string :action
      t.integer :target_id
      t.string :target_type
      t.integer :person_target_id
      t.string :person_target_type
      t.timestamps
    end
  end
end
