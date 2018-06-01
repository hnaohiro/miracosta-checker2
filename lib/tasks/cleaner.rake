namespace :cleaner do
  task run: :environment do
    Reservation.where('created_at <= ?', 7.days.ago).destroy_all
  end
end
