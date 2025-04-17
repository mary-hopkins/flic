require_relative 'basic_utils'
require 'base64'

class LaMetricClient
  def initialize(ip:, api_token:)
    raise "Missing IP or token!" if ip.nil? || api_token.nil?

    @ip = ip
    @api_token = api_token
    @auth_token = Base64.strict_encode64("dev:#{api_token}")
    @base_url = "https://#{ip}:4343"
    @headers = {
      "Authorization" => "Basic #{@auth_token}",
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end

  def send_message(text, icon: 2951, sound_id: "positive1", priority: "info")
    payload = {
      model: {
        frames: [{ text: text, icon: icon }],
        sound: { category: "notifications", id: sound_id, repeat: 1 }
      },
      priority: priority
    }

    uri = URI.join(@base_url, "/api/v2/device/notifications")
    BasicUtils.post(uri, headers: @headers, body: payload)
  end

  def device_info
    uri = URI.join(@base_url, "/api/v2/device")
    BasicUtils.get(uri, headers: @headers)
  end
end