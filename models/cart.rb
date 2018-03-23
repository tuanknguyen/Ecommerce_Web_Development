class Cart < ActiveRecord::Base
  has_many :cart_items , dependent: :destroy
  def add_subproduct(subproduct_id)
    current_cart_item = cart_items.find_by(subproduct_id: subproduct_id)
    if current_cart_item
      current_cart_item.quantity += 1
    else
      current_cart_item = cart_items.build(subproduct_id: subproduct_id, quantity: 1)
    end
    current_cart_item
  end

  def total_price
    @sum = cart_items.to_a.sum { |item| item.total_price }
    return @sum
  end
  
  def shipping_fee
    @shop_num = 0
    @shop_ids = []
    cart_items.each do |item|
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
  
end