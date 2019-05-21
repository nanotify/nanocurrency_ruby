require "set"
require "bigdecimal"
require_relative "./check"

module Nano

  module Unit
    extend self

    UNIT_SET = [:hex, :raw, :nano, :knano, :Nano, :NANO, :KNano, :MNano].to_set

    UNIT_ZEROS = {
      :hex => 0,
      :raw => 0,
      :nano => 20,
      :knano => 24,
      :Nano => 30,
      :NANO => 30,
      :KNano => 33,
      :MNano => 36
    }

    def valid_unit?(unit)
      UNIT_SET === unit
    end

    def convert(value, from, to)
      raise ArgumentError, "Invalid from unit type" unless Unit.valid_unit?(from)
      raise ArgumentError, "Invalid to unit type" unless Unit.valid_unit?(to)

      from_zeros = zeros_for_unit(from)
      to_zeros = zeros_for_unit(to)

      raise ArgumentError, "Value must be a string" unless value.is_a? String

      if from == :hex
        is_hex = Nano::Check.is_valid_hex? value
        raise ArgumentError, "Invalid hex value string" unless is_hex
      else
        is_number = Nano::Check.is_numerical? value
        raise ArgumentError, "Invalid number value string" unless is_number
      end

      zero_difference = from_zeros - to_zeros

      big_number = 0
      if from == :hex
        big_number = BigDecimal.new(value.to_i(16))
      else
        big_number = BigDecimal.new(value)
      end

      is_increase = zero_difference > 0
      zero_difference.abs.times do |i|
        if is_increase
          big_number = big_number * 10
        else
          big_number = big_number / 10
        end
      end

      if to == :hex
        big_number.to_i.to_s(16).rjust(32, "0")
      else
        if big_number.to_i == big_number
          big_number.to_i.to_s
        else
          big_number.to_s("F")
        end
      end
    end


    def unit_zeros
      UNIT_ZEROS
    end

    def zeros_for_unit(unit)
      raise ArgumentError, "Invalid unit" unless valid_unit? unit
      UNIT_ZEROS[unit]
    end
  end
end
