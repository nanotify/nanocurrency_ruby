require_relative "./hash"
require_relative "./work"
require_relative "./check"
require "nanocurrency_ext"
require "json"

module Nano
  ##
  # A class representing a state block in the Nano network.
  # Can be initialized as an existing block, with a work and signature
  # or as an incomplete block.
  class Block

    # @return [String] The type of the block, locked to 'state' currently
    attr_reader :type

    # @return [String] The account associated with the block.
    attr_reader :account

    # @return [String] The account representative as set by the block
    attr_reader :representative

    # @return [String] The previous block to this block
    attr_reader :previous

    # @return [String] The link for this block
    attr_reader :link

    # @return [String] The balance for the account at this block
    attr_reader :balance

    # @return [String?] The proof of work computed for this block
    attr_reader :work

    # @return [String?] The signature for the block
    attr_reader :signature

    ##
    # The block initializer, requires certain parameters to be valid.
    # @param params [Hash] The block parameters to construct the block with.\n
    #   `:previous` - The previous block hash as a string\n
    #   `:account` - The associated account address as a string\n
    #   `:representative` - The account representative as a string\n
    #   `:balance` - The account balance after this block in raw unit\n
    #   `:link` - The link hash associated with this block.\n
    #   `:work` - The proof of work for the block (optional)\n
    #   `:signature` - The signature for this block (optional)
    def initialize(params)
      @type = "state"

      @previous = params[:previous]

      raise ArgumentError, "Missing data for previous" if @previous.nil?
      raise(
        ArgumentError, "Invalid previous hash #{@previous}"
      ) unless Nano::Check.is_valid_hash? @previous

      @account = params[:account]
      raise ArgumentError, "Missing data for account" if @account.nil?
      raise(
        ArgumentError, "Invalid account #{@account}"
      ) unless Nano::Check.is_valid_account? @account

      @representative = params[:representative]
      raise(
        ArgumentError, "Missing data for representative"
      ) if @representative.nil?
      raise(
        ArgumentError, "Invalid representative #{@representative}"
      ) unless Nano::Check.is_valid_account? @representative

      @balance = params[:balance]
      raise(
        ArgumentError, "Missing data for balance"
      ) if @balance.nil?
      raise(
        ArgumentError, "Invalid balance #{@balance}"
      ) unless Nano::Check.is_balance_valid? @balance

      @link = params[:link]
      raise(
        ArgumentError, "Missing data for link"
      ) if @link.nil?
      raise(
        ArgumentError, "Invalid link #{@link}"
      ) unless Nano::Check.is_hash_valid? @link

      @work = params[:work]
      @signature = params[:signature]
    end

    # @return The link for the account converted to an address. 
    #   May not be valid in the case the link is a block hash
    def link_as_account
      Nano::Key.derive_address(@link)
    end

    ##
    # This method signs the block using the secret key given. This method
    # will fail if the key is incorrect. If this method succeeds, the block
    # may still be invalid if the key does not belong to the block account.
    # This method modifies the block's existing signature.
    #
    # @param secret_key [String] The hexidecimal representation of the 
    #   secret key. Should match the account but does not perform a check,
    #   currently.
    #
    # @return [String] Returns the signature for the block, whilst also
    #   setting the signature internally.
    def sign!(secret_key)
      throw ArgumentError, "Invalid key" unless Nano::Check.is_key?(secret_key)

      hash_bin = Nano::Utils.hex_to_bin(hash)
      secret_bin = Nano::Utils.hex_to_bin(secret_key)

      @signature = Nano::Utils.bin_to_hex(
        NanocurrencyExt.sign(hash_bin, secret_bin)
      ).upcase

      @signature
    end

    ##
    # Computes the proof of work for the block, setting the internal work
    # value and overwriting the existing value. The method uses a native
    # extension to improve the performance.
    #
    # @return [String] The computed work value, also setting it internally.
    def compute_work!
      base_prev = "".rjust(64, "0")
      is_first = previous == base_prev
      hash = is_first ? Nano::Key.derive_public_key(@account) : previous
      @work = Nano::Work.compute_work(hash)
      @work
    end

    ##
    # @return [String] The computed hash for the block.
    def hash
      Nano::Hash.hash_block(self)
    end

    def to_json(options = nil)
      {
        type: type,
        account: account,
        previous: previous,
        representative: representative,
        balance: balance,
        link: link,
        link_as_account: link_as_account,
        signature: signature,
        work: work
      }.to_json(options)
    end
  end
end
