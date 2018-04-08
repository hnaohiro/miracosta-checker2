class CreateReservationDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :reservation_details do |t|
      t.references :reservation, foreign_key: true
      t.references :room, foreign_key: true
      t.references :target_date, foreign_key: true
      t.boolean :reservable

      t.timestamps
    end
  end
end
