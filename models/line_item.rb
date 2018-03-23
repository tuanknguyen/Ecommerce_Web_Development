class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :subproduct
  
  STATUS = [ "Đang xử lý", "Sẵn sàng", "Đã giao cho shipper", "**Hết hàng**", "Chờ trả hàng", "Đã hoàn trả", "**Cần trợ giúp/Báo lỗi**" ]
  validates :status, inclusion: STATUS, allow_nil: true
  
  $status = false;
  def total_price
    price = ((quantity * subproduct.product.price * (100 - subproduct.product.discount)) / 100)
  end
end
