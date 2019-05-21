module Nano
  class Account
    def initialize(val)
      if val[:address]
        @address = val[:address]
      end

      if val[:public_key]
        @public_key = val[:public_key]
      end
    end

    def address
      @address
    end

    def public_key
      @public_key
    end

    def self.from_address(input)
      return nil unless input.is_a? String

      prefix_length = nil

      if input.start_with? "nano_"
        prefix_length = 5
      elsif input.start_with? "xrb_"
        prefix_length = 4
      end

      return nil if prefix_length.nil?

      public_key_bytes = Nano::Base32.decode(input[prefix_length, 52])
      checksum = Nano::Base32.decode(input[(prefix_length + 52)..-1])
      public_key_bin = Nano::Utils.hex_to_bin public_key_bytes
      computed_check = Blake2b.hex(
        public_key_bin, Blake2b::Key.none, 5
      ).reverse.upcase

      return nil if computed_check == checksum

      Account.new(:address => input, :public_key => public_key_bytes)
    end
  end
end
