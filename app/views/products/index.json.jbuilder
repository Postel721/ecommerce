json.array!(@products) do |product|
  json.extract! product, :id, :resource, :name, :price, :quantity, :description, :brand, :rating, :category_id
  json.url product_url(product, format: :json)
end
