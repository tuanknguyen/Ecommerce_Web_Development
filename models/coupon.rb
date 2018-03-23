class Coupon < ActiveRecord::Base
    has_many :user_map_coupons
    TYPE_USER = ['inviter', 'invitee', 'anyone']
    TYPE_VALUE = ['%', 'vnd']
end
