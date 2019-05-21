require_relative "./hash"
require_relative "./work"
require_relative "./check"
require "nanocurrency_ext"

module Nano
  class Block
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

    def type
      @type
    end

    def account
      @account
    end

    def account=(value)
      @account = value
    end

    def previous
      @previous
    end

    def previous=(value)
      @previous = value
    end

    def representative
      @representative
    end

    def representative=(value)
      @representative = value
    end

    def balance
      @balance
    end

    def balance=(value)
      @balance = balue
    end

    def link
      @link
    end

    def link=(value)
      @link = value
    end

    def work
      @work
    end

    def signature
      @signature
    end

    def link_as_account
      Nano::Key.derive_address(@link)
    end

    def sign!(secret_key)
      throw ArgumentError, "Invalid key" unless Nano::Check.is_key?(secret_key)

      hash_bin = Nano::Utils.hex_to_bin(hash)
      secret_bin = Nano::Utils.hex_to_bin(secret_key)

      @signature = Nano::Utils.bin_to_hex(
        NanocurrencyExt.sign(hash_bin, secret_bin)
      ).upcase

      @signature
    end

    def compute_work
      base_prev = "".rjust(64, "0")
      is_first = previous == base_prev
      hash = is_first ? Nano::Key.derive_public_key(@account) : previous
      @work = Nano::Work.compute_work(hash)
      @work
    end

    def hash
      Nano::Hash.hash_block(self)
    end
  end
end
