module Nano
  module Utils
    extend self

    ##
    # Converts a byte array into hexidecimal string
    # @param bytes [Array<Int8>] An array of integers representing bytes.
    # @return [String] A hexidecimal byte string.
    def bytes_to_hex(bytes)
      bytes.map { |x| "%02X" % x }.join
    end

    ##
    # Converts a hexidecimal string into a byte array.
    # @param hex [String] A hexidecimal string of arbitrary length.
    # @return [Array<Int8>] An array of integers representing the hex string.
    def hex_to_bytes(hex)
      hex.scan(/../).map { |x| x.hex }
    end

    ##
    # Converts a hex string into a binary.
    # @param hex [String] A hexidecimal string of arbitrary length.
    # @return [Binary] A binary representing the hex string
    def hex_to_bin(hex)
      bytes_to_bin(hex_to_bytes(hex))
    end

    ##
    # Converts a binary into a hexidecimal string
    # @param bin [Binary] The binary value.
    # @return [String] The hexidecimal string representing the binary value.
    def bin_to_hex(bin)
      bin.unpack('H*').first
    end

    ##
    # Converts a byte array into a binary value.
    # @param bytes [Array<Int8>] The byte array of integers.
    # @return [Binary] The binary value representing the byte array.
    def bytes_to_bin(bytes)
      bytes.pack("C*")
    end
  end
end
