require "blake2b"
require "nanocurrency_ext"
require_relative "./check"

module Nano

  ##
  # This module is responsible for generating and validating the proof
  # of work for a block hash
  module Work
    extend self

    ##
    # The maximum value a nonce can be
    MAX_NONCE = 0xffffffffffffffff

    ##
    # The minimum threshold a proof of work needs to meet to be valid.
    WORK_THRESHOLD = Integer(0xffffffc000000000)

    ##
    # Compute the proof of work for the hash.
    # @param hash [String] the previous block hash to compute the work for.
    # @return [String] the computed work as an 8 byte hex string.
    def compute_work(hash)
      NanocurrencyExt.compute_work(hash)
    end

    ##
    # Checks if a proof of work is valid for the hash
    # @param hash [String] The block hash the work was calculated for.
    # @param work [String] The block work that was calculated for the hash.
    # @return [Boolean] true if the work is valid and fits for the block hash.
    def is_work_valid?(hash, work)
      hash_valid = Nano::Check.is_hash_valid?(hash)
      work_valid = Nano::Check.is_work_valid?(work)
      throw ArgumentError, "Invalid block hash" unless hash_valid
      throw ArgumentError, "Invalid work" unless work_valid

      hash_bin = Nano::Utils.hex_to_bin(hash)
      work_bin = Nano::Utils.hex_to_bin(work).reverse

      input = work_bin + hash_bin
      output_hex = Nano::Utils.bytes_to_hex(
        Blake2b.bytes(input, Blake2b::Key.none, 8).reverse
      )

      output_hex.to_i(16) >= WORK_THRESHOLD
    end
  end
end
