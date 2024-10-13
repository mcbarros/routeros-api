# frozen_string_literal: true

module RouterOS
  # Class used to create a request to be sent to RouterOS
  class Request
    attr_reader :sentence

    def initialize(cmd, args, tag = nil)
      args = args.map { |k, v| Request.attr_word(k, v) } if args.is_a?(Hash)
      args = args.reject { |v| v.start_with?(".tag") }

      @tag = tag
      @sentence = [
        cmd.start_with?("/") ? cmd : "/#{cmd}",
        *args
      ]

      @sentence << ".tag=#{@tag}" unless @tag.nil?
      @sentence.freeze
    end

    def each(&block)
      @sentence.each(&block)
    end

    def to_s
      @sentence.join(" ")
    end

    def self.attr_word(key, value)
      "=#{key}=#{value.nil? ? "" : value}"
    end
  end
end
