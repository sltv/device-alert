json.array!(@devices) do |device|
  json.extract! device, :id, :host, :port, :last_seen
  json.url device_url(device, format: :json)
end
