# frozen_string_literal: true

require "bundler/setup"
require "routeros/api"

api = RouterOS::API.new("192.168.1.1", 8728, ssl: false)
response = api.login("test", "test")
puts(response) # (OK) []

if response.ok?
  response = api.command("ip/route/getall")
  puts(response.data) # (OK) [{ ... }]
end

api.close
