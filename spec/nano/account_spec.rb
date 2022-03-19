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

require "nanocurrency"

RSpec.describe Nano::Account do
  describe "#from_address" do
    subject { account }
    let(:account) { Nano::Account.from_address(address) }
    let(:address) { "nano_1khw4jm4yk8jxkbdanw9ioyo5twuxa9mrz3cs1akisz3xnt77nc8rx9oicnk" }

    it { should_not be_nil }

    context "when address is empty" do
      let(:address) { "" }

      it { should be_nil }
    end

    context "when address is invalid" do
      let(:address) { "garbagioaddress" }

      it { should be_nil }
    end

    context "when address has invalid checksum" do
      let(:address) {"nano_1khw4jm4yk8jxkbdanw9ioyo5twuxa9mrz3cs1akisz3xnt77nc8rx9oic88" }

      it { should be_nil }
    end
  end
end

