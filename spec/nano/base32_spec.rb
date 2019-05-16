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

RSpec.describe Nano::Base32 do
  it "should encode correctly" do
    key = "00D12634450C3B481F2A73150B55B5AE4B744A6028B61133FCAAF9224A1555A6"
    expected = "118j6rt6c53ub1hknwro3fcuddkdgj781c7p46szscqs6b73cof8"
    bytes = key.scan(/../).map(&:hex)
    expect(Nano::Base32.encode(bytes)).to eq expected
  end

  it "should decode correctly" do
    address = "118j6rt6c53ub1hknwro3fcuddkdgj781c7p46szscqs6b73cof8"
    exp = "00D12634450C3B481F2A73150B55B5AE4B744A6028B61133FCAAF9224A1555A6"
    expect(Nano::Base32.decode(address)).to eq exp
  end
end
