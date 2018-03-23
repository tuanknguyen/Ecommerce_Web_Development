#---
# Excerpted from "Agile Web Development with Rails",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/rails4 for more book information.
#---

class OrdersController < ApplicationController
  include CurrentCart
  include CurrentRole
  # include ApplicationHelper
  # include ActionView::Helpers::NumberHelper
  
  before_action :check_role_admin , only: [:index,:show, :edit, :update, :destroy]
  before_action :set_cart
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.order('created_at DESC')
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @item_products = []
    @total_price = 0
    @line_items = LineItem.all.where(order_id: @order.id)
    @line_items.each do |item|
      if (item.subproduct.product.admin_id == session[:user_id] || User.find(session[:user_id]).roles_mask == 3)
         @item_products << item
      end
    end
    @item_products.each do |item|
      @total_price += item.total_price
    end
    @total_price
  end

  # GET /orders/lookup/confirmation
  def lookup
    @order = Order.find_by_confirmation(params[:confirmation])
    if @order.coupon_id
      @coupon = Coupon.find(@order.coupon_id)
    end
    @total_item_price =  @order.total_item_price
    @shipping_fee, @shop_num = @order.shipping_fee
  end

  def thankyou
    @confirmation = params[:confirmation]
  end

  # GET /orders/new
  def new
    if @cart.cart_items.empty?
      redirect_to root_path, alert: "Giỏ hàng của bạn chưa có sản phẩm nào."
      return
    end
    @order = Order.new
    @shipping_fee, @shop_num = @cart.shipping_fee

    if session[:user_id]
      @user =  User.find(session[:user_id])
      if @user
        @coupons = []
        user_map_coupons = UserMapCoupon.where(user_id: @user.id).pluck(:coupon_id)
        user_map_coupons.each do |user_map_coupon|
          user_coupons = Coupon.find(user_map_coupon)
          if user_coupons.present?
            @coupons << user_coupons
          end
        end
      end
    end    
    
    @count_item = 0
    @cart.cart_items.each do |item|
      @count_item += item.quantity
    end
    @order
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
    @shipping_fee, @shop_num = @cart.shipping_fee
  end

  # POST /orders
  # POST /orders.json
  def create
    #calculate shipping fee
    @shipping_fee, @shop_num = @cart.shipping_fee
    @order = Order.new(order_params)
    
    respond_to do |format|
      if @order.save
        # Transfer items from cart to order
        @cart.cart_items.each do |cart_item|
          @item = LineItem.new
          @order.convert_into_line_item(cart_item)
          cart_item.destroy
        end
        
        #Reduce product quantity when order complete
        line_items = LineItem.all.where(order_id: @order.id)
        line_items.each do |item|
          p = Subproduct.find(item.subproduct.id)
          p.quantity -= item.quantity
          p.save
        end
        
        # Give user points and delete coupon if there's any
        if session[:user_id]
          if User.find(session[:user_id])
            @user = User.find(session[:user_id])
            @user.point += 1
            @user.save
    
            if @user.inviter_id.present? && !@user.status_gift
              inviter_coupon_id = Coupon.where(type_user: 'inviter').pluck(:id).last.to_s
              create_coupon_for_inviter(@user.inviter_id, inviter_coupon_id)
              @user.status_gift = true
              @user.save
            end
            # Use coupon
            if params[:coupon_id].present?
              @order.coupon_id = params[:coupon_id]
              @order.save
              @user.user_map_coupons.find_by(coupon_id: params[:coupon_id]).destroy
            end
          end
        end

        #Confirmation number
        @order.confirmation = rand(1000..9999).to_s + @order.id.to_s
        @order.save
        
        #Send mail 
        SendMail.order_confirmation(@order, @shipping_fee).deliver
        format.html { redirect_to :controller => 'orders', :action => 'thankyou', confirmation: @order.confirmation }
        format.json { render action: 'show', status: :created,
          location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def total_amount
    total_amount = params[:total_amount]
    if total_amount[-1] = 'đ'
      total_amount[-1] = ''
      total_amount = total_amount.gsub('.','')
    end
    
    total_amount = total_amount.to_i
    # if there's a coupon
    if params[:coupon_id].present?
      coupon_id = params[:coupon_id]
      if Coupon.find(coupon_id).type_value == '%'
        total_amount = (total_amount*(100-Coupon.find(coupon_id).value)).to_i/100
      else
        total_amount = (total_amount - Coupon.find(coupon_id).value).to_i
      end
    end
    @total_price = total_amount
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Cảm ơn bạn đã mua hàng.' }
      format.json { render json: total_amount }
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end
    
    def create_coupon_for_inviter(user,inviter_coupon)
      inviter_user = User.find(@user.inviter_id)
      inviter_user.user_map_coupons.create(coupon_id: inviter_coupon)
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:user_name, :telephone, :address,:user_email, :method_of_payment, :status, :note, :coupon_id )
    end
  #...
end