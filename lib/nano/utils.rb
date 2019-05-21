module Nano
  module Utils
    extend self

    def bytes_to_hex(bytes)
      bytes.map { |x| "%02X" % x }.join
    end

    def hex_to_bytes(hex)
      hex.scan(/../).map { |x| x.hex }
    end

    def hex_to_bin(hex)
      bytes_to_bin(hex_to_bytes(hex))
    end

    def bin_to_hex(bin)
      bin.unpack('H*').first
    end

    def bytes_to_bin(bytes)
      bytes.pack("C*")
    end
  end
end
