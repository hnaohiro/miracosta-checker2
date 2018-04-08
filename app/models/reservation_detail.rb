class ReservationDetail < ApplicationRecord
  belongs_to :room
  belongs_to :target_date
end
