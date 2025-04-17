require 'httparty'
require 'base64' # standard ruby library
require 'json' # standard ruby library

require_relative "basic_utils" # loading env variables
require_relative "la_metric_client" # talk to the clock

# Optional: still load from .env if you want
BasicUtils.load_env_file

ip = ENV["LAMETRIC_IP"]
token = ENV["LAMETRIC_API_TOKEN"]

if ip.nil? || token.nil?
  puts "❌ Please set LAMETRIC_IP and LAMETRIC_API_TOKEN"
  exit 1
end

lametric = LaMetricClient.new(ip: ip, api_token: token)
lametric.send_message("Now we're clean and modular! 🧼💎")
  
response = lametric.device_info
lametric.send_message("Hello")

puts "Status: #{response.code}"
puts "Body: #{response.parsed_response}"