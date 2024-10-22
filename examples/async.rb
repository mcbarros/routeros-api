# frozen_string_literal: true

require "bundler/setup"
require "routeros/api"

api = RouterOS::API.new("192.168.1.1", 8728, ssl: false)
response = api.login("test", "test")
puts(response) # (OK) []

if response.ok?
  if RouterOS::API.async_enabled?
    response = api.async_command("ip/route/getall")
    puts(response) # Async::Task
    puts(response.wait.data) # [{ ... }]
  else
    warn('asyn gem could not be loaded')
  end
end

api.close
