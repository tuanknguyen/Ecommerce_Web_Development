class CartItem < ActiveRecord::Base
  belongs_to :subproduct
  belongs_to :cart

  STATUS = ['shopping', 'purchased']
  validates :status, inclusion: STATUS, allow_nil: true  
  
  def total_price
  	(quantity * subproduct.product.price * (100 - subproduct.product.discount)) / 100
  end
  
end
