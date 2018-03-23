json.array!(@coupons) do |coupon|
  json.extract! coupon, :id, :name, :value, :type_value, :type_user
  json.url coupon_url(coupon, format: :json)
end
