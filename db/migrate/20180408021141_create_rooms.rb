class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :code
      t.boolean :enabled

      t.timestamps
    end
  end
end
