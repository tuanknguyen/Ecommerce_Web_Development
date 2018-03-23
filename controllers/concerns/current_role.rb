module CurrentRole
  extend ActiveSupport::Concern
  private
    def check_role_admin
      @user = User.find(session[:user_id])
      if (@user.roles_mask == 1)
      	redirect_to root_path , alert: 'Không tìm thấy trang bạn yêu cầu.'
      end
    end
end