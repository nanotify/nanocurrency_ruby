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

      is_balance_valid?(number_without_dot)
    end

    def is_balance_valid?(value)
      value.match?(/^[0-9]*$/)
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

    def is_valid_account?(input)
      !Nano::Account.from_address(input).nil?
    end
  end
end
