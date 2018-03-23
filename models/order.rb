class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :user

  PAYMENT_TYPES = ["Thanh toán khi nhận hàng"]
  STATUS = [ "Đang xử lý", "Trên đường vận chuyển", "Đã giao hàng", "Yêu cầu đổi trả" ]

  validates :user_name, length: { :in => 6..50 }, presence: true
  validates :user_email , presence: true
  validates_format_of :user_email,:with => Devise::email_regexp
  validates :address, length: { :in => 6..1000 }, presence: true
  validates :telephone, length: { :in => 8..20 }, presence: true
  validates :note, length: {maximum: 1000}, allow_nil: true
  validates :method_of_payment, inclusion: PAYMENT_TYPES

  def convert_into_line_item (cart_item)
    @item = LineItem.new
    cart_item.status = 'purchased'
    @item.user_id = cart_item.user_id
    @item.subproduct = cart_item.subproduct
    @item.quantity = cart_item.quantity
    line_items << @item
  end
  
  def shipping_fee
    @shop_num = 0
    @shop_ids = []
    line_items.each do |item|
      @shop_id = item.subproduct.product.admin_id
      if @shop_ids.include?(@shop_id) == false
        @shop_ids << @shop_id
        @shop_num += 1
      end
    end

    if @shop_num == 1
      @shipping_fee = 25000;
    elsif @shop_num == 2
      @shipping_fee = 30000;
    else
      @shipping_fee = 35000;
    end
    return [@shipping_fee, @shop_num]
  end
  
  def total_item_price
    @sum = 0;
    line_items.each do |item|
      @sum += item.total_price
    end
    
    if coupon_id.present?
      @coupon = Coupon.find(coupon_id)
      if @coupon
        if @coupon.type_value == '%'
          @sum = (@sum*(100-@coupon.value)).to_i/100
        else
          @sum = (@sum - @coupon.value).to_i
        end  
      end
    end
    return @sum
  end
end
