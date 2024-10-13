# frozen_string_literal: true

require_relative "../lib/routeros/api"

api = RouterOS::API.new("192.168.1.1", 8728)
response = api.login("admin", "my-secret-password")
puts(response) # (OK) []

if response.ok?
  response = api.command("ip/route/getall")
  puts(response.data) # [{ ... }]
end
