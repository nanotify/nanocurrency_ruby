require "securerandom"
require "blake2b"
require "nanocurrency_ext"
require_relative "./account"
require_relative "./check"

module Nano
  ##
  # The key module is responsible for handling the key and seed based
  # operations in the Nano module.
  module Key
    extend self

    ##
    # Generates a 32 byte seed as a hexidecimal string. Cryptographically
    # secure.
    # return [String] A 64 length string of hexidecimal.
    def generate_seed
      SecureRandom.hex(32)
    end

    ##
    # Derive a secret key from a seed, given an index.
    # @param seed [String] The seed to generate the secret key from,
    #   in hexadecimal format
    # @param index [Integer] The index to generate the secret key from
    def derive_secret_key(seed, index)
      raise(
        ArgumentError, "Seed is invalid"
      ) unless Nano::Check.is_seed_valid?(seed)
      raise(
        ArgumentError, "Index is invalid"
      ) unless Nano::Check.is_index_valid?(index)

      seed_bin = Nano::Utils.hex_to_bin(seed)
      Blake2b.hex(seed_bin + [index].pack('L>'), Blake2b::Key.none, 32).upcase
    end

    def derive_public_key(input)
      is_secret_key = Nano::Check.is_key?(input)
      account = Nano::Account.from_address(input)
      is_address = !account.nil?
      raise ArgumentError, "Incorrect input" unless is_secret_key || is_address

      if is_secret_key
        res = NanocurrencyExt.public_key(Nano::Utils.hex_to_bin(input))
        Nano::Utils.bin_to_hex(res).upcase
      else
        account.public_key
      end
    end

    def derive_address(public_key, prefix = "nano_")
      is_public_key = Nano::Check.is_key?(public_key)
      raise ArgumentError, "Incorrect key type" unless is_public_key

      is_valid_prefix = prefix == "nano_" || prefix == "xrb_"
      raise ArgumentError, "Invalid prefix" unless is_valid_prefix

      public_key_bytes = Nano::Utils.hex_to_bytes public_key
      public_key_enc = Nano::Base32.encode public_key_bytes
      pk_bin = Nano::Utils.hex_to_bin(public_key)
      checksum = Blake2b.hex(pk_bin, Blake2b::Key.none, 5)
      checksum_bytes = Nano::Utils.hex_to_bytes(checksum).reverse
      enc_chk = Nano::Base32.encode(checksum_bytes)
      "#{prefix}#{public_key_enc}#{enc_chk}"
    end
  end
end
