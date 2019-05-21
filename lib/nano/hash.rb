require "blake2b"
require_relative "./conversion"
require_relative "./utils"

module Nano
  ##
  # The Hash module is responsible for producing a block hash given a
  # Block object.
  module Hash
    extend self

    STATE_BLOCK_PREAMBLE_BITS = Nano::Utils.bytes_to_bin(
      Array.new(32) {|i| i == 31 ? 6 : 0}
    ).freeze

    ##
    # This method will produce a hash for the given block
    #
    # @param block [Nano::Block] The block to derive a hash from
    #
    # @return [String] The hash in a hexadecimal formatted string.
    def hash_block(block)
      account_bits = Nano::Utils.hex_to_bin(
        Nano::Key.derive_public_key(block.account)
      )
      previous_bits = Nano::Utils.hex_to_bin(
        block.previous
      )
      representative_bits = Nano::Utils.hex_to_bin(
        Nano::Key.derive_public_key(block.representative)
      )
      balance_bits = Nano::Utils.hex_to_bin(
        Nano::Unit.convert(block.balance, :raw, :hex)
      )
      link_bits = Nano::Utils.hex_to_bin(
        block.link
      )
      bits = STATE_BLOCK_PREAMBLE_BITS + account_bits + previous_bits +
             representative_bits + balance_bits + link_bits;
      Blake2b.hex(bits).upcase
    end
  end
end
