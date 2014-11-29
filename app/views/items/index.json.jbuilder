json.array!(@items) do |item|
  json.extract! item, :id, :name, :catgory
  json.url item_url(item, format: :json)
end
