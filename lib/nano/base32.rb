require_relative './utils'

module Nano
  ##
  # This module performs encoding and decoding of Base32 as specified by
  # the Nano protocol.
  module Base32
    extend self

    ##
    # The Base32 alphabet of characters.
    ALPHABET = "13456789abcdefghijkmnopqrstuwxyz".freeze

    ##
    # Encode an array of bytes into Base32 string.
    #
    # @param bytes [Array<Int8>] The byte array to encode.
    # 
    # @return [String] The base32 encoded representation of the bytes
    def encode(bytes)
      length = bytes.length
      leftover = (length * 8) % 5
      offset = leftover == 0 ? 0 : 5 - leftover
      value = 0
      output = ""
      bits = 0

      length.times do |i|
        value = (value << 8) | bytes[i]
        bits += 8

        while bits >= 5
          output += ALPHABET[(value >> bits + offset - 5) & 31]
          bits -= 5
        end
      end

      if bits > 0
        output += ALPHABET[(value << (5 - (bits + offset))) & 31]
      end

      output
    end

    ##
    # Decodes a Base32 encoded string into a hex string
    #
    # @param str [String] The base32 encoded string
    #
    # @returns [String] The hexadecimal decoded base32 string
    def decode(str)
      length = str.length
      leftover = (length * 5) % 8
      offset = leftover == 0 ? 0 : 8 - leftover

      bits = 0
      value = 0

      output = Array.new

      length.times do |i|
        value = (value << 5) | read_char(str[i])
        bits += 5

        if bits >= 8
          output.push((value >> (bits + offset - 8)) & 255)
          bits -= 8
        end
      end

      if bits > 0
        output.push((value << (bits + offset - 8)) & 255)
      end

      output = output.drop(1) unless leftover == 0
      Nano::Utils.bytes_to_hex(output)
    end

    def read_char(chr)
      idx = ALPHABET.index(chr)
      raise ArgumentError, "Character #{chr} not base32 compliant" if idx.nil? 
      idx
    end

    module_function :read_char
  end
end
