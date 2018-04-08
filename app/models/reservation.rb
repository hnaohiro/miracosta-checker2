class Reservation < ApplicationRecord
  has_many :reservation_details

  def reservable_count
    reservation_details.select(&:reservable).size
  end
end
