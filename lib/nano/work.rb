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
require "nanocurrency_ext"
require_relative "./check"

module Nano
  module Work
    extend self

    MAX_NONCE = 0xffffffffffffffff
    WORK_THRESHOLD = Integer(0xffffffc000000000)

    def compute_work(hash)
      NanocurrencyExt.compute_work(hash)
    end

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
