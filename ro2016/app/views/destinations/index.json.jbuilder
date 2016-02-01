json.array!(@destinations) do |destination|
  json.extract! destination, :id, :name, :description, :picture
  json.url destination_url(destination, format: :json)
end
