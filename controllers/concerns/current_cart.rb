module CurrentCart
  extend ActiveSupport::Concern
  private
  	# create cart if there's no cart for current session
    def set_cart
      @cart = Cart.find(session[:cart_id])
		  rescue ActiveRecord::RecordNotFound
		    @cart = Cart.create
		    session[:cart_id] = @cart.id
	   	
	   	# if @cart.blank?
	   	# 	@cart = Cart.create
	   	# 	session[:cart_id] = @cart.id
	   	# end
	  end
end