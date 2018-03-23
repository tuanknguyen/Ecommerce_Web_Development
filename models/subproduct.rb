class Subproduct < ActiveRecord::Base
  belongs_to :product
  has_many :cart_items, dependent: :destroy
  has_many :line_items
  
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: true
  validates :size, presence: true
  validates :color, length: {maximum: 30}, presence: true


  before_destroy :ensure_not_referenced_by_any_cart_item
  
  # Remove validation of product_id when creating a subproduct so that subproduct 
  # can be created before saving the product itself
  # validates :product_id, presence: true

  SIZE = ["S", "M", "L", "Free size"]
  
  private
  
  # ensure that there are no cart items referencing this product
  def ensure_not_referenced_by_any_cart_item
    if cart_items.empty?
      return true
    else
      errors.add(:base, 'cart Items present')
      return false
    end
  end
  
end
