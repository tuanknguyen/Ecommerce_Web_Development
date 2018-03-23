json.array!(@products) do |product|
  json.extract! product, :id, :title, :image_url, :quantity, :description, :origin, :admin_id
  json.url product_url(product, format: :json)
end
