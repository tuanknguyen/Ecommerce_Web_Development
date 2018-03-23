class AddRoleController < ApplicationController
  before_action :set_user, only: [:update, :destroy]
  before_action :check_super_admin_account
  def index
    @users = User.all
  end
  def edit
    @user = User.find(params[:id])
  end
  def update
    # @user = User.find params[:id]
    case user_params[:roles_mask]
    when "visitor"
      user_params[:roles_mask] = 1
    when "admin"
      user_params[:roles_mask] = 2
    when "superadmin"
      user_params[:roles_mask] = 3
    end
    
    if @user.update(user_params)
      redirect_to add_role_path, notice: "Update #{@user.email } was completed"
    end
  end

  def destroy
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to add_role_path, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to add_role_path, notice: 'User wasn\'t successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end
  private
      def set_user
        @user = User.find(params[:id])
      end
      def user_params
        @user_params ||= params.require(:user).permit(:user_name, :email , :address, :telephone, :roles_mask, :status)
      end
      def check_super_admin_account
      	@super_user = User.find(session[:user_id])
        if @super_user.roles_mask != 3
          redirect_to root_path , notice: 'Page not found'
        end
        rescue
        redirect_to login_path, notice: 'Hãy đăng nhập :)'
      end
  protected
end