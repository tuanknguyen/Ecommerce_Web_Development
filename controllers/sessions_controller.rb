class SessionsController < ApplicationController
  before_action :store_return_to
  
  def authorize
  end

  def new 
    @user = User.new     
  end

  def register
  end
  
  def store_return_to
    session[:return_to] = request.referer
  end

  def fb_login
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def login
  	user = User.find_by(email: params[:email])
  	if user.blank?
  	  redirect_to login_url, alert: "Lỗi đăng nhập. Email của bạn không tồn tại."
  	else
  	  if user.status == true
      	if user and user.authenticate(params[:password])
      		session[:user_id] = user.id
      		redirect_to root_path, notice: "Đăng nhập thành công"
    		else
      		redirect_to login_url, alert: "Sai tên đăng nhập hoặc mật khẩu."
      	end
      else
        redirect_to root_path , notice: 'Tài khoản của bạn chưa được xác nhận email. Hãy vào email của bạn để xác nhận.'
      end
  	end

  end
  
  def confirm_account
    user = User.find(params[:id])
    if user
      user.status = true
      user.save
      redirect_to login_path, notice: 'Tài khoản đã được xác nhận. Mời bạn đăng nhập.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Đã đăng xuất."
  end

  def forgot_password_confirmation
    @user = User.find_by(email: params[:email])
    if @user
      require 'securerandom'
      random_password = SecureRandom.hex
      @user.forgot_password_code = random_password
      @user.save
      SendMail.forgot_password(@user).deliver
      redirect_to root_path, notice: 'Hãy kiểm tra email của bạn.'
    else
      redirect_to root_path, alert: 'Email không hợp lệ.'
    end
  end
  
  def reset_password
    code = params[:forgot_password_code]
    @user = User.find_by(forgot_password_code: code)
    if @user.blank?
      redirect_to root_path, alert: 'Không tìm thấy tài khoản bạn muốn thiết lập mật khẩu.'
    end
  end
  
  def new_password
    code = params[:forgot_password_code]
    @user = User.find_by(forgot_password_code: code)
    if @user
      @user.password = params[:password]
      @user.forgot_password_code = nil
      @user.save
      redirect_to login_path, notice: 'Mật khẩu đã được đổi thành công.'
    else
      redirect_to login_path, alert: 'Không tìm thấy tài khoản bạn muốn thiết lập mật khẩu.'
    end
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      user_params ||= params.require(:user).permit(:email, :password, :password_confirmation, :user_name, :address, )
    end
end
