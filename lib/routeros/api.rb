# frozen_string_literal: true

require "socket"
require "openssl"
require_relative "request"
require_relative "response"
require_relative "word_stream"

module RouterOS
  # Main abstraction to connect to RouterOS
  class API
    VERSION = "0.3.0"

    class Error < StandardError; end

    def initialize(host, port, ssl: false, ssl_ctx: nil)
      raw_socket = TCPSocket.new(host, port)

      if ssl
        ssl_socket = OpenSSL::SSL::SSLSocket.new(raw_socket, ssl_ctx || OpenSSL::SSL::SSLContext.new)
        ssl_socket.connect
        socket = ssl_socket
      else
        socket = raw_socket
      end

      @ssl = ssl
      @stream = RouterOS::WordStream.new(socket)
      @tag = 0
    end

    def command(cmd, args = [])
      send_request(create_request(cmd, args))
      read_response
    end

    def login(name, password)
      warn("non encrypted connection, be careful") unless @ssl
      command("/login", { name:, password: })
    end

    def close
      @stream.close
    end

    private

    def create_request(cmd, args)
      @tag += 1
      RouterOS::Request.new(cmd, args, @tag)
    end

    def send_request(request)
      request.each do |word|
        @stream.write_word(word)
      end

      @stream.write_word("")
    end

    def read_response
      response = []

      loop do
        sentence = read_sentence

        response << sentence

        break if sentence.include?("!done")
      end

      RouterOS::Response.new(response)
    end

    def read_sentence
      sentence = []

      loop do
        word = @stream.read_word

        break if word.size.zero?

        sentence << word
      end

      sentence
    end
  end
end
