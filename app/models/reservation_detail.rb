class ReservationDetail < ApplicationRecord
  belongs_to :room
  belongs_to :target_date

  def room_id
    room.id
  end

  def reservable_link
    "https://reserve.tokyodisneyresort.jp/hotel/list/?roomsNum=1&adultNum=2&childNum=0&stayingDays=1&useDate=#{target_date.date_for_query}&searchHotelCD=DHM&hotelSearchDetail=true&displayType=hotel-search"
  end
end
