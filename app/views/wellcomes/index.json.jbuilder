json.array!(@wellcomes) do |wellcome|
  json.extract! wellcome, 
  json.url wellcome_url(wellcome, format: :json)
end
