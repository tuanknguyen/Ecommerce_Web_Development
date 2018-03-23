class SendMail < ApplicationMailer
  default :from => '"Fashion#" <venustovn@gmail.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.send_mail.registration_confirmation.subject
  #
  def registration_confirmation(user)
      @user = user
      # @url  = 'http://www.gmail.com'
      mail(to: @user.email, cc: 'fathanghotro@gmail.com', subject: 'Cảm ơn bạn đã đăng ký với Fa#')
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.send_mail.forgot_password.subject
  #
  def forgot_password(user)
      @user = user
      # @url  = 'http://www.gmail.com'
      mail(to: @user.email, cc: 'fathanghotro@gmail.com', subject: 'Fa# cài đặt lại mật khẩu')
  end

  def order_confirmation(order, shipping_fee)
    @line_items = order.line_items
    @order = order
    @shipping_fee = shipping_fee
    if @order.coupon_id.present?
      @coupon = Coupon.find(@order.coupon_id)
    end
    @total_item_price =  order.total_item_price
    mail(to: order.user_email, cc: 'fathanghotro@gmail.com', bcc: 'tuongvi.hoang12@gmail.com', subject: '[Fa#] Hóa đơn giao dịch')
  end
  
  def subscribe(email)
    mail(to: email, cc: 'fathanghotro@gmail.com', subject: '[Fa#] Cảm ơn bạn đã subscribe')
  end
  
  def contact_us(name, email, subject, message)
    @name = name
    @subject = subject
    @message = message
    mail(to: email, cc: 'fathanghotro@gmail.com', subject: '[Fa#] Yêu cầu của bạn đã được tiếp nhận')
  end
end
