# frozen_string_literal: true

module RouterOS
  # Class used for the communication with the RouterOS device.
  # This class abstracts the encoding and decoding of words.
  # See more on: https://help.mikrotik.com/docs/display/ROS/API#API-APIwords
  class WordStream
    def initialize(stream)
      @stream = stream
    end

    # writes an encoded word to the underlying stream
    def write_word(word)
      @stream.write(WordStream.encode_length(word.size) + word)
    end

    # reads a decodes a word from the underlying stream
    def read_word
      @stream.read(read_length)
    end

    def close
      @stream.close
    end

    # utility to encode the length
    def self.encode_length(length)
      case length
      when 0..0x7F
        lowest_bytes(length, 1)
      when 0x80..0x3FFF
        lowest_bytes(length | 0x8000, 2)
      when 0x4000..0x1FFFFF
        lowest_bytes(length | 0xC00000, 3)
      when 0x200000..0xFFFFFFF
        lowest_bytes(length | 0xE0000000, 4)
      else
        0xF0.chr + lowest_bytes(length, 4)
      end
    end

    # utility to get only the lowest bytes of a given number
    def self.lowest_bytes(num, size)
      r = String.new

      while r.length != size
        shift = num >> (r.length * 8)
        r = (shift & 0xFF).chr + r
      end

      r
    end

    private

    def readbyte
      bytes = @stream.read(1).bytes
      bytes[0]
    end

    # reads the length from the underlying stream
    def read_length
      length = readbyte
      mask = 0xFF

      if length & 0x80 == 0x00 # first bit is 0
        byte_amount = 1
      elsif length & 0xC0 == 0x80 # first bit is 1, second bit is 0
        byte_amount = 2
        mask = 0x7F
      elsif length & 0xE0 == 0xC0 # first and second bits are 1, third bit is 0
        byte_amount = 3
        mask = 0x3F
      elsif length & 0xF0 == 0xE0 # first, second and third bits are 1, fourth bit is 0
        byte_amount = 4
        mask = 0x1F
      elsif length & 0xF8 == 0xF0 # first, second, third and fourth bits are 1, fifth is 0
        length = readbyte
        byte_amount = 3
      end

      length &= mask

      (byte_amount - 1).times do
        length <<= 8
        length += readbyte
      end

      length
    end
  end
end
