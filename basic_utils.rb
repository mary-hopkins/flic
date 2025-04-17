require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class BasicUtils
  def self.load_env_file(file = ".env")
    return unless File.exist?(file)

    File.readlines(file).each do |line|
      next if line.strip.empty? || line.strip.start_with?('#')
      key, value = line.strip.split('=', 2)
      ENV[key] = value.gsub(/(^['"]|['"]$)/, '') if key && value
    end
  end

  def self.get(uri, headers:)
    https = build_https(uri)
    request = Net::HTTP::Get.new(uri, headers)
    response = https.request(request)
    parse_response(response)
  end

  def self.post(uri, headers:, body:)
    https = build_https(uri)
    request = Net::HTTP::Post.new(uri, headers)
    request.body = JSON.generate(body)
    response = https.request(request)
    parse_response(response)
  end

  def self.build_https(uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE # ⚠️ Local trusted connection only
    https
  end

  def self.parse_response(response)
    puts "Status: #{response.code}"
    return nil if response.body.nil? || response.body.empty?

    JSON.parse(response.body)
  rescue JSON::ParserError
    puts "Failed to parse JSON: #{response.body}"
    response.body
  end
end