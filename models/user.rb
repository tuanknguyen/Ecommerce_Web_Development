class User < ActiveRecord::Base
  has_secure_password
  validates :invitation_code, length: { :in => 3..10 }, uniqueness: true, allow_nil: true
  validates :email , presence: true, uniqueness: { case_sensitive: false}
  validates_format_of :email,:with => Devise::email_regexp
  validates :password, length: { :in => 6..100 }, allow_nil: true
  validates :user_name, length: { :in => 6..50 }, presence: true
  validates :address, length: { :in => 6..1000 }, presence: true
  validates :telephone, length: { :in => 8..20 }, presence: true

  has_one :role
  has_many :user_map_coupons

  attr_accessor :refer_code
  
  ROLES = %i[visitor admin superadmin] 
  
  def get_line_items
    return LineItem.where(user_id: id).order(:created_at)
  end
  
end
