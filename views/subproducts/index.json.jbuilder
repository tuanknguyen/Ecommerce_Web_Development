json.array!(@subproducts) do |subproduct|
  json.extract! subproduct, :id
  json.url subproduct_url(subproduct, format: :json)
end
