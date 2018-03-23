json.array!(@orders) do |order|
  json.extract! order, :id, :method_of_payment, :status, :user_id
  json.url order_url(order, format: :json)
end
