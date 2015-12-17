json.array!(@categories) do |category|
  json.extract! category, :id, :resource, :name
  json.url category_url(category, format: :json)
end
