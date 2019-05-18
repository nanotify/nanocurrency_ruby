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

require "blake2b"
require_relative "./conversion"
require_relative "./utils"

module Nano
  module Hash
    extend self

    STATE_BLOCK_PREAMBLE_BITS = Nano::Utils.bytes_to_bin(
      Array.new(32) {|i| i == 31 ? 6 : 0}
    )

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
