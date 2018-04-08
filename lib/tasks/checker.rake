require 'net/http'

class Checker

  def run(room, target_date)
    params = default_params.merge(
      commodityCD: room.code,
      useDate: target_date.date_for_query
    )
    data = parse_response(http_post(url, params))

    reservationDetail = ReservationDetail.new(
      room: room,
      target_date: target_date,
      reservable: data['saleStatus'].to_i == 0
    )
  end

  private

  def url
    ENV['CHECK_URL']
  end

  def default_params
    {
      _xhr: nil,
      commodityCD: nil,
      useDate: nil,
      stayingDays: 1,
      adultNum: 2,
      childNum: 0,
      roomsNum: 1,
      childAgeBedInform: 0,
      stockQueryType: 3,
      rrc3005ProcessingType: 'update'
    }
  end

  def parse_response(data)
    data.dig('ecRoomStockInfos', '1DHM003', 'roomStockInfos').values[0]['roomBedStockRangeInfos'].values[0]['currentRoomBedStock']
  end

  def http_post(url, params)
    res = Net::HTTP.post_form(URI.parse(url), params)
    JSON.parse(res.body)
  end
end

namespace :checker do
  task run: :environment do
    rooms = Room.where(enabled: true)
    target_dates = TargetDate.where(enabled: true)

    reservation_details = rooms.zip(target_dates).map do |room, target_date|
      Checker.new.run(room, target_date)
    end

    Reservation.create(reservation_details: reservation_details)
  end
end
