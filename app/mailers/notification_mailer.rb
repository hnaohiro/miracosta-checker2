class NotificationMailer < ApplicationMailer
  def push(reservation)
    @reservation = reservation
    from = "Miracosta Checker2 <#{ENV['MAIL_FROM']}>"
    to = ENV['MAIL_TO'].split(',')
    mail from: from, to: to, subject: 'Miracosta Checker2'
  end
end
