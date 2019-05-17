# MIT License
#
# Copyright (c) 2019 Nanotify
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require "securerandom"
require "blake2b"
require "ed25519_blake2b"
require_relative "./account"

module Nano
  module Key
    extend self

    MIN_INDEX = 0
    MAX_INDEX = 2 ** 32 - 1

    def generate_seed
      SecureRandom.hex(32)
    end

    def derive_secret_key(seed, index)
      raise ArgumentError, "Seed is invalid" unless is_seed_valid?(seed)
      raise ArgumentError, "Index is invalid" unless is_index_valid?(index)

      seed_bin = Nano::Utils.hex_to_bin(seed)
      Blake2b.hex(seed_bin + [index].pack('L>'), Blake2b::Key.none, 32).upcase
    end

    def derive_public_key(input)
      is_secret_key = is_key? input
      account = Nano::Account.from_address(input)
      is_address = !account.nil?
      raise ArgumentError, "Incorrect input" unless is_secret_key || is_address

      if is_secret_key
        res = Ed25519Blake2b.public_key(Nano::Utils.hex_to_bin(input))
        Nano::Utils.bin_to_hex(res).upcase
      else
        account.public_key
      end
    end

    def derive_address(public_key, prefix = "nano_")
      is_public_key = is_key? public_key
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

    def is_seed_valid?(seed)
      seed.is_a?(String) && seed.match?(/^[0-9a-fA-F]{64}$/)
    end

    def is_index_valid?(index)
      index.is_a?(Integer) && index >= MIN_INDEX && index <= MAX_INDEX
    end

    def is_key?(input)
      input.is_a?(String) && input.match?(/^[0-9a-fA-F]{64}$/)
    end
  end
end
