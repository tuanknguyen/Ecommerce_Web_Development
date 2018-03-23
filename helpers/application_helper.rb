module ApplicationHelper
  # display price in correct format
  def formatted_price(price)
    number_to_currency(price.round(-2), unit: "", separator: ",", delimiter: ".", precision: 0) + 'đ'
  end
  
  def format_time(time)
    # time.in_time_zone(7).to_formatted_s(:short)
    time.in_time_zone(7).to_s
  end
  
  def get_latest_products
    @latest_products ||= Product.order("created_at DESC").limit(4);
  end
  
  def order_noti_count(user_id)
    count = 0
    LineItem.where(status: nil).each do |item|
      if item.subproduct.product.admin_id == user_id
        count = count+1
      end
    end
    return count
  end
end
