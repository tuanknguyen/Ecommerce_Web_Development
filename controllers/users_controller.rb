class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # need to login before can check out myaccount page
  before_action :authorize, only: [:myaccount]
  include CurrentRole
  before_action :check_role_admin , only: [:index,:show, :edit, :update, :destroy]
  
  def myaccount
    @user = User.find(session[:user_id])
    
    #For order history
    @line_items = @user.get_line_items
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.invitation_code = @user.email[0..3]
    # set up flag to catch error if refer_code is not found
    flag = true
    refer_code = params[:user][:refer_code]
    if refer_code.present?
      @inviter = User.find_by(invitation_code: refer_code)
      if @inviter
        @user.inviter_id = @inviter.id
      else
        flag = false
      end      
    end
    respond_to do |format|
      if @user.save && flag
        @user.invitation_code += @user.id.to_s.rjust(5, "0")
        @user.save
        invitee_coupon_id = Coupon.where(type_user: 'invitee').pluck(:id).last.to_s
        create_coupon_for_invitee(@user, invitee_coupon_id)

        SendMail.registration_confirmation(@user).deliver
        format.html { redirect_to login_url, alert: 'Cảm ơn bạn đã đăng ký. Hãy kiểm tra email của bạn để xác nhận tài khoản.' }
        format.json { render :show, status: :created, location: @user }
      else
        if flag == false
          @user.errors[:base] << "Không tìm thấy mã giới thiệu."
        end
        format.html { render :new, alert: 'Đăng ký không thể hoàn tất.' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url, notice: 'Thông tin tài khoản đã được lưu thành công.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Đã xóa thành công tài khoản.' }
      format.json { head :no_content }
    end
  end

  def create_coupon_for_invitee(invitee_user, invitee_coupon)
    invitee_user.user_map_coupons.create(coupon_id: invitee_coupon)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :user_name, :telephone, :address, :status, :refer_code, :provider, :uid, :oauth_token, :oauth_expires_at)
    end
end
