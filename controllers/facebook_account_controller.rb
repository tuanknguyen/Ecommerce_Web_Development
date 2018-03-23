class FacebookAccountController < ApplicationController
  def fb_login
    facebook_account = FacebookAccount.from_omniauth(env["omniauth.auth"])
    if session[:user_id]
        facebook_account.user_id = session[:user_id]
    end
    if facebook_account.save
      facebook_account.fb_share
    else
      redirect_to root_path, alert: 'Đăng nhập vào Facebook gặp lỗi.'
    end
  end
end
