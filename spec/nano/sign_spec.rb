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

RSpec.describe Nano::Sign do
  let(:seed) { Nano::Key.generate_seed }
  let(:secret_key) { Nano::Key.derive_secret_key(seed, 0) }
  let(:public_key) { Nano::Key.derive_public_key(secret_key) }
  let(:message) { 'some cool message' }
  let(:signature) { Nano::Sign.sign(secret_key, message) }

  it 'should properly validate a self generated signature' do
    valid = Nano::Sign.signature_valid?(public_key, message, signature)
    expect(valid).to eq(true)
  end

  context 'when dealing with other signatures' do
    let(:message) { 'abc' }
    let(:public_key) { '96f33ed854b1241b889d655cdb86456d261fb8ad18c66e98284952c34a4a0799' }
    let(:signature) { 'd6fdf7308e868b7d318aa70c8c2114365f47ece1b966c80db5e96f7f84c9e86090161ed339fef8c031cbf126204b0e53ed4458b81aa49f0ec2b376f9a2bb830b' }

    it 'should properly validate the signature' do
      valid = Nano::Sign.signature_valid?(public_key, message, signature)
      expect(valid).to eq(true)
    end
  end

  context 'when signature is for different message' do
    let(:other_message) { 'not the same message' }

    it 'should not validate' do
      valid = Nano::Sign.signature_valid?(public_key, other_message, signature)
      expect(valid).to eq(false)
    end
  end
end

