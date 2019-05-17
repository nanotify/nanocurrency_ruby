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
