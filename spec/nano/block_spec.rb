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
require "json"

RSpec.describe Nano::Block do

  context "a standard historical block" do
    before do
      @block = Nano::Block.new(
        account: "xrb_13okhm9junjik3cct9os7gsxhwjfzggrfjqpmhna91jucsqqfincr1h616kd",
        previous: "483656785A048633A0FDAC8461BB224E0BBDAACFE0EB4EE63737ADB743BB029C",
        representative: "xrb_1oenixj4qtpfcembga9kqwggkb87wooicfy5df8nhdywrjrrqxk7or4gz15b",
        balance: "417328526500000000000000000000",
        link: "2B85C658C8557064432D2890D7F3CC3969BA8648B6D63BA8B223003D32BB6350",
        signature: "4F51A5B0ED0345491DB0A5EE65C4FF6C10BC86DF09DC284AF0692DE50C9C7DA31399DB4992D01F578A04ECFF619390D6989D63D7B8B69D158932432D5E0E0D02",
        work: "d79297006b48681b"
      )
    end

    it "should have the correct type" do
      expect(@block.type).to eq "state"
    end

    it "should have the correct account" do
      expect(@block.account).to eq "xrb_13okhm9junjik3cct9os7gsxhwjfzggrfjqpmhna91jucsqqfincr1h616kd"
    end

    it "should have the correct previous" do
      expect(@block.previous).to eq "483656785A048633A0FDAC8461BB224E0BBDAACFE0EB4EE63737ADB743BB029C"
    end

    it "should have the correct balance" do
      expect(@block.balance).to eq "417328526500000000000000000000"
    end

    it "should have the correct representative" do
      expect(@block.representative).to eq "xrb_1oenixj4qtpfcembga9kqwggkb87wooicfy5df8nhdywrjrrqxk7or4gz15b"
    end

    it "should have the correct signature" do
      expected = "4F51A5B0ED0345491DB0A5EE65C4FF6C10BC86DF09DC284AF0692DE50C9C7DA31399DB4992D01F578A04ECFF619390D6989D63D7B8B69D158932432D5E0E0D02"
      expect(@block.signature).to eq expected
    end

    it "should have the correct work" do
      expect(@block.work).to eq "d79297006b48681b"
    end

    it "should have valid work" do
      expect(Nano::Work.is_work_valid?(@block.previous, @block.work)).to eq true
    end

    it "should have the correct hash" do
      expect(@block.hash).to eq "19DBEB265A660AF17863F3A8933686D27B82ACE99F46EE70261DA1E7D350CE20"
    end

    it "should have the correct link as account" do
      expect(@block.link_as_account).to eq "nano_1cw7rseeiodiej3ktc6itzswrgdbqc56jfpp9gnd6ar19nsdprtioh31wsh9"
    end

    it "should convert to json correctly" do
      json = {
        type: "state",
        account: "xrb_13okhm9junjik3cct9os7gsxhwjfzggrfjqpmhna91jucsqqfincr1h616kd",
        previous: "483656785A048633A0FDAC8461BB224E0BBDAACFE0EB4EE63737ADB743BB029C",
        representative: "xrb_1oenixj4qtpfcembga9kqwggkb87wooicfy5df8nhdywrjrrqxk7or4gz15b",
        balance: "417328526500000000000000000000",
        link: "2B85C658C8557064432D2890D7F3CC3969BA8648B6D63BA8B223003D32BB6350",
        link_as_account: "nano_1cw7rseeiodiej3ktc6itzswrgdbqc56jfpp9gnd6ar19nsdprtioh31wsh9",
        signature: "4F51A5B0ED0345491DB0A5EE65C4FF6C10BC86DF09DC284AF0692DE50C9C7DA31399DB4992D01F578A04ECFF619390D6989D63D7B8B69D158932432D5E0E0D02",
        work: "d79297006b48681b"
      }.to_json
      expect(@block.to_json).to eq json
    end
  end

  context "a new block with a previous" do
    before do
      @block = Nano::Block.new(
        account: "xrb_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9",
        previous: "965F24A7B994126FCE39E0B9EEEF9B5D2840607F107B69CED2742511089CDD2D",
        representative: "xrb_1oenixj4qtpfcembga9kqwggkb87wooicfy5df8nhdywrjrrqxk7or4gz15b",
        balance: Nano::Unit.convert("200", :Nano, :raw),
        link: "4A51754D5D4F5F3BA7447ACBEADB359DEE69BA44F118585A007E87F06E167AC1"
      )
    end

    it "should have the correct hash" do
      expected = "72C81213940EE7130324694A174DE3BC5E3B41D51820F3B49143A6F9CD2F22E1"
      expect(@block.hash).to eq expected
    end

    it "should sign correctly" do
      secret_key = "A63B1AB484A611DB447D4D40388031B8A37A7CC9ADAD63E0D5F089BC7A203FC4"
      @block.sign!(secret_key)
      expected = "26500E160EC22366CCB99E502159F93EEE564BFE150E88AB0A9457CFE666ECD7124CC33170DE6E55321F771EFF80761A0F4B10DAE41769786242A7E45D643408"
      expect(@block.signature).to eq expected
    end

    it "should produce the correct work" do
      work = @block.compute_work!
      expect(Nano::Work.is_work_valid?(@block.previous, work)).to eq true
      expect(work).to eq @block.work
    end
  end

  context "a new block without a previous" do
    before do
      @block = Nano::Block.new(
        account: "xrb_3bgiedqh8hyeesqhaaakkpgf9fqcbsfejiu1s4qbn6fzw3uuqzpy7iinzxa9",
        previous: "".rjust(64, "0"),
        representative: "xrb_1oenixj4qtpfcembga9kqwggkb87wooicfy5df8nhdywrjrrqxk7or4gz15b",
        balance: Nano::Unit.convert("200", :Nano, :raw),
        link: "4A51754D5D4F5F3BA7447ACBEADB359DEE69BA44F118585A007E87F06E167AC1"
      )
    end

    it "should have the correct hash" do
      expected = "B915B8E73E638C4CE23B37F64FC8E5187083129F036FAA95DBD749828CDD98EC"
      expect(@block.hash).to eq expected
    end

    it "should sign correctly" do
      secret_key = "A63B1AB484A611DB447D4D40388031B8A37A7CC9ADAD63E0D5F089BC7A203FC4"
      @block.sign!(secret_key)
      expected = "D1DF704573D26EBB792FB76C38F4D72AE4726A8E3B0902041EE14B3B15C84322A9F60A2624752B1C79340219EE663E6EB68CA69E3E3439A6C859BF7AAE88D005"
      expect(@block.signature).to eq expected
    end

    it "should produce the correct work" do
      work = @block.compute_work!
      hash = Nano::Key.derive_public_key(@block.account)
      expect(Nano::Work.is_work_valid?(hash, work)).to eq true
      expect(work).to eq @block.work
    end

  end
end
