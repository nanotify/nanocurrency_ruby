module Nano
  ##
  # The Sign module does signing messages with private keys and validating
  # them with public keys.
  module Sign
    module_function

    def signature_valid?(public_key, message, signature)
      hash = Blake2b.hex(message)
      NanocurrencyExt.sign_open(
        Nano::Utils.hex_to_bin(hash),
        Nano::Utils.hex_to_bin(public_key),
        Nano::Utils.hex_to_bin(signature)
      )
    end

    def sign(secret_key, message)
      hash = Blake2b.hex(message)
      hash_bin = Nano::Utils.hex_to_bin(hash)
      secret_bin = Nano::Utils.hex_to_bin(secret_key)
      signature_bin = NanocurrencyExt.sign(hash_bin, secret_bin)
      Nano::Utils.bin_to_hex(signature_bin).upcase
    end
  end
end
