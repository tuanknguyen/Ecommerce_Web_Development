class FacebookAccount < ActiveRecord::Base
  validates :name, presence: true
  validates :email , presence: true, uniqueness: { case_sensitive: false}
  validates_format_of :email,:with => Devise::email_regexp
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |facebook_account|
      facebook_account.provider = auth.provider
      facebook_account.uid = auth.uid
      facebook_account.name = auth.info.name
      facebook_account.email = auth.info.email
      facebook_account.oauth_token = auth.credentials.token
      facebook_account.oauth_expires_at = Time.at(auth.credentials.expires_at)
      facebook_account.save
    end
  end
  
  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end
  
  def fb_share
    fb_post = facebook.put_wall_post("Mua hàng thời trang thiết kế của những shop đẹp nhất Hà Nội tại Fashion# để được giảm giá 10%!! #fathang #designerclothing #thietke #hanoi", {name: "Thời trang thiết kế Fashion#", 
    description: "Giá tốt nhất Hà Nội", link: "https://fathang.com"})
    if fb_post["id"].present?
      post_ids << fb_post["id"]
    end
  end
  
  def fb_purchase_item
  end
  
  def fb_delete (post_id)
    facebook.delete_object(post_id)
  end
  
end
