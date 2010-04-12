class CreateSavedFilterParams < ActiveRecord::Migration
  def self.up
    create_table :saved_filter_params do |t|
      t.integer :user_id
      t.string :filter_name
      t.text :params

      t.timestamps
    end
  end

  def self.down
    drop_table :saved_filter_params
  end
end
