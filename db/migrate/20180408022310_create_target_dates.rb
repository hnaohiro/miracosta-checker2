class CreateTargetDates < ActiveRecord::Migration[5.1]
  def change
    create_table :target_dates do |t|
      t.integer :year
      t.integer :month
      t.integer :day
      t.boolean :enabled

      t.timestamps
    end
  end
end
