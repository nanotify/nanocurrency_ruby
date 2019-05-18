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
  module Check

    MIN_INDEX = 0
    MAX_INDEX = 2 ** 32 - 1

    extend self
    def is_valid_hex?(value)
      value.is_a?(String) && value.match?(/^[0-9a-fA-F]{32}$/)
    end

    def is_numerical?(value)
      return false unless value.is_a?(String)
      return false if value.start_with?(".")
      return false if value.end_with?(".")

      number_without_dot = value.sub(".", "")

      # More than one '.' in the number.
      return false unless number_without_dot.count(".") == 0

      number_without_dot.match?(/^[0-9]*$/)
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

    def is_hash_valid?(hash)
      is_seed_valid?(hash)
    end

    def is_work_valid?(input)
      input.is_a?(String) && input.match?(/^[0-9a-fA-F]{16}$/)
    end
  end
end
