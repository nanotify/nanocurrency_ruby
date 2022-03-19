module Nano
  ##
  # The Account class is used to simplify conversion from account to
  # public key
  class Account

    # @return [String] The base32 encoded account address
    attr_reader :address

    # @return [String] The public key for the account encoded in hexadecimal
    attr_reader :public_key

    ##
    # The Account intiailizer.
    # @param value [Hash] This hash can contain the keys `:account` and
    #   `:public_key` which will be stored within the object
    def initialize(val)
      if val[:address]
        @address = val[:address]
      end

      if val[:public_key]
        @public_key = val[:public_key]
      end
    end

    ##
    # A class initializer to create an Account object from the account
    # base32 address.
    #
    # @param input [String] The base32 account address
    #
    # @return [Account] Returns a created account given a valid account address
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
      computed_check_bytes = Blake2b.bytes(public_key_bin, Blake2b::Key.none, 5).reverse
      computed_check = Nano::Utils.bytes_to_hex(computed_check_bytes)

      return nil if computed_check != checksum

      Account.new(:address => input, :public_key => public_key_bytes)
    end
  end
end
