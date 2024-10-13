# frozen_string_literal: true

RSpec.describe RouterOS::API do
  it "has a version number" do
    expect(RouterOS::API::VERSION).not_to be nil
  end
end
