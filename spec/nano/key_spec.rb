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

RSpec.describe Nano::Key do
  it "should verify a seed" do
    seed = "14533b83ed06401015a449ca8d1cf22e042b870bf619beef24d4ef77090a5b5b"
    expect(Nano::Check.is_seed_valid?(seed)).to be true
  end

  it "should not verify an invalid seed" do
    seed = "abcde"
    expect(Nano::Check.is_seed_valid?(seed)).to_not be true
  end

  it "should generate a valid seed" do
    seed = Nano::Key.generate_seed
    expect(Nano::Check.is_seed_valid?(seed)).to be true
  end

  it "should not generate the same seed in a row" do
    seed_a = Nano::Key.generate_seed
    seed_b = Nano::Key.generate_seed

    expect(seed_a).to_not eq seed_b
  end

  it "should verify an index" do
    expect(Nano::Check.is_index_valid?(0)).to be true
  end

  it "should not verify an invalid index" do
    expect(Nano::Check.is_index_valid?(-1)).to be false
    expect(Nano::Check.is_index_valid?("hello")).to be false
  end

  it "should derive the correct secret key for index 0" do
    seed = "14533b83ed06401015a449ca8d1cf22e042b870bf619beef24d4ef77090a5b5b"
    secret = Nano::Key.derive_secret_key(seed, 0)
    expected = "A63B1AB484A611DB447D4D40388031B8A37A7CC9ADAD63E0D5F089BC7A203FC4"
    expect(secret).to eq expected
  end

  it "should derive the correct public key for secret key" do
    secret = "A63B1AB484A611DB447D4D40388031B8A37A7CC9ADAD63E0D5F089BC7A203FC4"
    public_key = Nano::Key.derive_public_key(secret)
    expected = "A5D062EEF33FCC666EF42112959CD3B6EA4E5AC8C360C8AE9A11BFE077BBFEDE"
    expect(public_key).to eq expected
  end

  it "should derive the correct public key for xrb address" do
    address = "xrb_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9"
    public_key = Nano::Key.derive_public_key(address)
    expected = "A5D062EEF33FCC666EF42112959CD3B6EA4E5AC8C360C8AE9A11BFE077BBFEDE"
    expect(public_key).to eq expected
  end

  it "should derive the correct public key for nano address" do
    add = "nano_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9"
    public_key = Nano::Key.derive_public_key(add)
    expected = "A5D062EEF33FCC666EF42112959CD3B6EA4E5AC8C360C8AE9A11BFE077BBFEDE"
    expect(public_key).to eq expected
  end

  it "should derive the address for the public key" do
    pk = "A5D062EEF33FCC666EF42112959CD3B6EA4E5AC8C360C8AE9A11BFE077BBFEDE"
    address = Nano::Key.derive_address(pk)
    exp = "nano_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9"
    expect(address).to eq exp
  end

  it "should derive the address for the public key with xrb prefix" do
    pk = "A5D062EEF33FCC666EF42112959CD3B6EA4E5AC8C360C8AE9A11BFE077BBFEDE"
    address = Nano::Key.derive_address(pk, "xrb_")
    exp = "xrb_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9"
    expect(address).to eq exp
  end
end
