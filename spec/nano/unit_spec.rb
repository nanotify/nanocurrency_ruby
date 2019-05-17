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

RSpec.describe Nano::Unit do
  it "should validate the correct units" do
    valid = [:hex, :raw, :nano, :knano, :Nano, :NANO, :KNano, :MNano]

    valid.each do |unit|
      expect(Nano::Unit.valid_unit? unit).to be true
    end
  end

  it "should have only valid units for the zeroes" do
    Nano::Unit.unit_zeros.each do |key, value|
      expect(Nano::Unit.valid_unit? key).to be true
    end
  end

  it "should convert between NANO and MNano correctly" do
    res = Nano::Unit.convert "2000000", :NANO, :MNano
    expect(res).to eq "2"
  end

  it "should convert between NANO and MNano correctly with decimals" do
    res = Nano::Unit.convert "29876540", :NANO, :MNano
    expect(res).to eq "29.87654"
  end

  it "should convert between raw and Nano correctly" do
    res = Nano::Unit.convert "29876540043535443345445645643", :raw, :Nano
    expect(res).to eq "0.029876540043535443345445645643"
  end

  it "should convert between Nano and hex correctly" do
    res = Nano::Unit.convert "205", :Nano, :hex
    expect(res).to eq "00000a1b76b992c86ba2849540000000"
  end

  it "should convert between hex and Nano correctly" do
    res = Nano::Unit.convert "00000a2124c0d9595823efa510000000", :hex, :Nano
    expect(res).to eq "205.45"
  end

  it "should convert between Nano and raw correctly" do
    res = Nano::Unit.convert "12345.879809", :Nano, :raw
    expect(res).to eq "12345879809000000000000000000000000"
  end
end
