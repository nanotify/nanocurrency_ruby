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

require_relative "./hash"
require_relative "./work"
require "nanocurrency_ext"

module Nano
  class Block
      def initialize(params)
        @type = "state"
        @previous = params[:previous]
        @account = params[:account]
        @representative = params[:representative]
        @balance = params[:balance]
        @link = params[:link]
        @work = params[:work]
        @signature = params[:signature]
      end

    def type
      @type
    end

    def account
      @account
    end

    def account=(value)
      @account = value
    end

    def previous
      @previous
    end

    def previous=(value)
      @previous = value
    end

    def representative
      @representative
    end

    def representative=(value)
      @representative = value
    end

    def balance
      @balance
    end

    def balance=(value)
      @balance = balue
    end

    def link
      @link
    end

    def link=(value)
      @link = value
    end

    def work
      @work
    end

    def signature
      @signature
    end

    def link_as_account
      Nano::Key.derive_address(@link)
    end

    def sign!(secret_key)
      throw ArgumentError, "Invalid key" unless Nano::Check.is_key?(secret_key)

      hash_bin = Nano::Utils.hex_to_bin(hash)
      secret_bin = Nano::Utils.hex_to_bin(secret_key)

      @signature = Nano::Utils.bin_to_hex(
        NanocurrencyExt.sign(hash_bin, secret_bin)
      ).upcase

      @signature
    end

    def compute_work
      base_prev = "".rjust(64, "0")
      is_first = previous == base_prev
      hash = is_first ? Nano::Key.derive_public_key(@account) : previous
      @work = Nano::Work.compute_work(hash)
      @work
    end

    def hash
      Nano::Hash.hash_block(self)
    end
  end
end
