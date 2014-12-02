json.array!(@items) do |item|
  json.extract! item, :id, :code, :name, :category
  json.url item_url(item, format: :json)
end
