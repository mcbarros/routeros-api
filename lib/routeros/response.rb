# frozen_string_literal: true

module RouterOS
  # Represents a parsed RouterOS response
  class Response
    attr_reader :raw_sentences, :data, :tag

    def initialize(sentences)
      @raw_sentences = sentences
      @tag = nil
      @error = nil
      @data = []

      sentences.each do |sentence|
        if sentence.include?("!re")
          @data << Response.parse_data_sentence(sentence)
        elsif sentence.include?("!done")
          @tag = Response.parse_done_sentence(sentence)
        elsif sentence.include?("!trap")
          @error = Response.parse_error_sentence(sentence)
        end
      end
    end

    def ok?
      @error.nil?
    end

    def error?
      !ok?
    end

    def error_message
      @error
    end

    def to_s
      "(#{ok? ? "OK" : "ERROR"}) #{ok? ? data : error_message}"
    end

    def self.parse_data_sentence(sentence)
      data_words = sentence[1..].reject { |word| word.start_with?(".") }
      data_fields = data_words.map { |word| Response.parse_field(word) }
      Hash[*data_fields.flatten]
    end

    def self.parse_done_sentence(sentence)
      return nil unless sentence.size > 1

      parsed = Response.parse_field(sentence.last)
      parsed[1]
    end

    def self.parse_error_sentence(sentence)
      parsed = Response.parse_field(sentence.last)
      parsed[1]
    end

    def self.parse_field(word)
      key, value = word[1..].split("=", 2)
      [key.to_sym, value]
    end
  end
end
