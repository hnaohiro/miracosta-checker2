json.extract! reservation_detail, :id, :room_id, :target_date_id, :reservable, :created_at, :updated_at
json.url reservation_detail_url(reservation_detail, format: :json)
