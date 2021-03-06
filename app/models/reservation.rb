class Reservation < ApplicationRecord
  has_many :reservation_details, dependent: :destroy

  default_scope { order('id DESC') }

  after_create :notification, if: :exists_reserable_room

  def reservable_count
    reservation_details.select(&:reservable).size
  end

  def exists_reserable_room
    new_reservables = Reservation.first.reservation_details.select(&:reservable).map(&:room_id)
    old_reservables = (Reservation.second&.reservation_details || []).select(&:reservable).map(&:room_id)
    (new_reservables - old_reservables).present?
  end

  def notification
    NotificationMailer.push(self).deliver
  end
end
