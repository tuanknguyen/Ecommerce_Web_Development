class StaticPagesController < ApplicationController
  def faq
  end

  def policy
  end

  def about_us
  end

  def contact_us
  end
  
  def subscribe_mail
    email = params[:email]
    #Send mail 
    SendMail.subscribe(email).deliver
    redirect_to root_path, notice: "Chúc mừng, bạn đã subscribe thành công!"
  end
  
  def contact_us_mail
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]
    #Send mail 
    SendMail.contact_us(name, email, subject, message).deliver
    redirect_to root_path, notice: "Bạn đã gửi yêu cầu thành công. Nhân viên chăm sóc khách hàng sẽ trả lời bạn trong thời gian sớm nhất."
  end
end
