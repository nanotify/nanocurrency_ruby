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

require_relative './utils'

module Nano
  module Base32
    extend self

    ALPHABET = "13456789abcdefghijkmnopqrstuwxyz".freeze

    def encode(bytes)
      length = bytes.length
      leftover = (length * 8) % 5
      offset = leftover == 0 ? 0 : 5 - leftover
      value = 0
      output = ""
      bits = 0

      length.times do |i|
        value = (value << 8) | bytes[i]
        bits += 8

        while bits >= 5
          output += ALPHABET[(value >> bits + offset - 5) & 31]
          bits -= 5
        end
      end

      if bits > 0
        output += ALPHABET[(value << (5 - (bits + offset))) & 31]
      end

      output
    end

    def decode(str)
      length = str.length
      leftover = (length * 5) % 8
      offset = leftover == 0 ? 0 : 8 - leftover

      bits = 0
      value = 0

      output = Array.new

      length.times do |i|
        value = (value << 5) | read_char!(str[i])
        bits += 5

        if bits >= 8
          output.push((value >> (bits + offset - 8)) & 255)
          bits -= 8
        end
      end

      if bits > 0
        output.push((value << (bits + offset - 8)) & 255)
      end

      output = output.drop(1) unless leftover == 0
      Nano::Utils.bytes_to_hex(output)
    end

    def read_char!(chr)
      idx = ALPHABET.index(chr)
      raise ArgumentError, "Character #{chr} not base32 compliant" if idx.nil? 
      idx
    end

    module_function :read_char!
  end
end
