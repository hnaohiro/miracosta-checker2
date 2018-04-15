require 'net/http'
require 'json'

class HttpClient

  def http_get(url)
    retry_on_error do
      res = Net::HTTP.get(URI.parse(url))
      JSON.parse(res)
    end
  end

  def http_post(url, params)
    retry_on_error do
      res = Net::HTTP.post_form(URI.parse(url), params)
      JSON.parse(res.body)
    end
  end

  def http_post_json(url, json)
    retry_on_error do
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = json
      res = http.request(req)
      JSON.parse(res.body)
    end
  end

  private

  def retry_on_error(times: 10)
    try = 0
    begin
      try += 1
      yield
    rescue
      sleep 1
      retry if try < times
      raise
    end
  end
end

class Checker

  def run(room, target_date) 
    params = default_params.merge(
      commodityCD: room['code'],
      useDate: sprintf("%04d%02d%02d", target_date['year'], target_date['month'], target_date['day'])
    )

    response = http_client.http_post(url, params)
    current_room_bed_stock = parse_current_room_bed_stock(response)

    {
      room: room,
      target_date: target_date,
      reservable: current_room_bed_stock['saleStatus'].to_i == 0
    }
  end

  private

  def url
    'https://reserve.tokyodisneyresort.jp/hotel/api/queryHotelPriceStock/'
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
      childAgeBedInform: 0
    }
  end

  def http_client
    @http_client ||= HttpClient.new
  end

  def parse_current_room_bed_stock(response)
    response.dig('ecRoomStockInfos', '1DHM003', 'roomStockInfos')
      .values[0]['roomBedStockRangeInfos']
      .values[0]['currentRoomBedStock']
  end
end

class AdminClient

  def fetch_rooms
    http_client.http_get("#{url}/rooms.json").select { |e| e['enabled'] }
  end

  def fetch_target_dates
    http_client.http_get("#{url}/target_dates.json").select { |e| e['enabled'] }
  end

  def post_reservation(reservation_details)
    params = {
      reservation: {
        reservation_details: reservation_details.map do |detail|
          {
            room_id: detail[:room]['id'],
            target_date_id: detail[:target_date]['id'],
            reservable: detail[:reservable]
          }
        end
      }
    }
    http_client.http_post_json("#{url}/reservations.json", params.to_json)
  end

  private

  def url
    'https://miracosta-checker2.herokuapp.com'
  end

  def http_client
    @http_client ||= HttpClient.new
  end
end

def main
  adminClient = AdminClient.new
  checker = Checker.new

  rooms = adminClient.fetch_rooms
  puts "rooms", rooms.map { |e| "* #{e['name']}" }.join("\n")

  target_dates = adminClient.fetch_target_dates
  puts "dates", target_dates.map { |e| "* #{e['year']}/#{e['month']}/#{e['day']}" }.join("\n")

  puts "\nchecking..."

  reservation_details = rooms.map do |room|
    target_dates.map do |target_date|
      checker.run(room, target_date).tap do |reservation_detail|
        reservable = reservation_detail[:reservable] ? '○' : '×'
        puts "[#{reservable}] #{room['name']} (#{target_date['year']}/#{target_date['month']}/#{target_date['day']})"
      end
    end
  end.flatten

  puts 'checking done'

  adminClient.post_reservation(reservation_details)

  puts 'Completed!'
end

main
