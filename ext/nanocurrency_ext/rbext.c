#include <ruby/ruby.h>
#include <ruby/encoding.h>
#include "ed25519.h"
#include "blake2.h"

VALUE cNanocurrency;

const uint8_t WORK_HASH_LENGTH = 8;
const uint64_t WORK_THRESHOLD = 0xffffffc000000000;
const uint8_t BLOCK_HASH_LENGTH = 32;
const uint8_t WORK_LENGTH = 8;

void hex_to_bytes(const char* const hex, uint8_t* const dst) {
  int byte_index = 0;
  for (unsigned int i = 0; i < strlen(hex); i += 2) {
    char byte_string[3];
    memcpy(byte_string, hex + i, 2);
    byte_string[2] = '\0';
    const uint8_t byte = (uint8_t) strtol(byte_string, NULL, 16);
    dst[byte_index++] = byte;
  }
}

void uint64_to_bytes(const uint64_t src, uint8_t* const dst) {
  memcpy(dst, &src, sizeof(src));
}

uint64_t bytes_to_uint64(const uint8_t* const src) {
  uint64_t ret = 0;

  memcpy(&ret, src, sizeof(ret));

  return ret;
}

const uint8_t HEX_MAP[] = {'0', '1', '2', '3', '4', '5', '6', '7',
                           '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
void bytes_to_hex(const uint8_t* const src, const uint8_t length, char* const dst) {
  for (unsigned int i = 0; i < length; ++i) {
    dst[2 * i] = HEX_MAP[(src[i] & 0xF0) >> 4];
    dst[(2 * i) + 1] = HEX_MAP[src[i] & 0x0F];
  }

  dst[2 * length] = '\0';
}


void reverse_bytes(uint8_t* const src, const uint8_t length) {
  for (unsigned int i = 0; i < (length / 2); i++) {
    const uint8_t temp = src[i];
    src[i] = src[(length - 1) - i];
    src[(length - 1) - i] = temp;
  }
}

uint8_t validate_work(const uint8_t* const block_hash, uint8_t* const work) {
  blake2b_state hash;
  uint8_t output[WORK_HASH_LENGTH];

  blake2b_init(&hash, WORK_HASH_LENGTH);
  blake2b_update(&hash, work, WORK_LENGTH);
  blake2b_update(&hash, block_hash, BLOCK_HASH_LENGTH);
  blake2b_final(&hash, output, WORK_HASH_LENGTH);

  const uint64_t output_int = bytes_to_uint64(output);

  return output_int >= WORK_THRESHOLD;
}

const uint64_t MIN_UINT64 = 0x0000000000000000;
const uint64_t MAX_UINT64 = 0xffffffffffffffff;

int work(const uint8_t* const block_hash, const uint8_t worker_index, const uint8_t worker_count, uint8_t* const dst) {
  const uint64_t interval = (MAX_UINT64 - MIN_UINT64) / worker_count;

  const uint64_t lower_bound = MIN_UINT64 + (worker_index * interval);
  const uint64_t upper_bound = (worker_index != worker_count - 1) ? lower_bound + interval : MAX_UINT64;

  uint64_t work = lower_bound;
  uint8_t work_bytes[WORK_LENGTH];

  for (;;) {
    if (work == upper_bound) return -1;

    uint64_to_bytes(work, work_bytes);

    if (validate_work(block_hash, work_bytes)) {
      reverse_bytes(work_bytes, WORK_LENGTH);
      memcpy(dst, work_bytes, WORK_LENGTH);
      return 0;
    }

    work++;
  }

  return -1;
}

VALUE nanocurrency_public_key(VALUE self, VALUE rbSecret_key) {
  Check_Type(rbSecret_key, T_STRING);
  if (RSTRING_LEN(rbSecret_key) != 32) {
    rb_raise(rb_eArgError, "The secret key must be 32 bytes in length");
    return Qnil;
  }

  unsigned char *secret_key = RSTRING_PTR(rbSecret_key);

  ed25519_public_key public_key;
  ed25519_publickey(secret_key, public_key);

  return rb_str_new(public_key, 32);
}

VALUE nanocurrency_sign(VALUE self, VALUE rbHash, VALUE rbSecret_key) {
  Check_Type(rbSecret_key, T_STRING);
  Check_Type(rbHash, T_STRING);

  if (RSTRING_LEN(rbSecret_key) != 32) {
    rb_raise(rb_eArgError, "The secret key must be 32 bytes in length");
    return Qnil;
  }

  if (RSTRING_LEN(rbHash) != 32) {
    rb_raise(rb_eArgError, "The hash must be 32 bytes in length");
    return Qnil;
  }

  unsigned char *secret_key = RSTRING_PTR(rbSecret_key);
  unsigned char *message = RSTRING_PTR(rbHash);
  ed25519_public_key public_key;
  ed25519_publickey(secret_key, public_key);
  size_t message_len = 32;

  ed25519_signature sig;
  ed25519_sign(message, message_len, secret_key, public_key, sig);

  return rb_str_new(sig, 64);
}

VALUE nanocurrency_compute_work(VALUE self, VALUE rbHash) {

  Check_Type(rbHash, T_STRING);
  uint8_t block_hash_bytes[BLOCK_HASH_LENGTH];
  const char *hex = RSTRING_PTR(rbHash);
  hex_to_bytes(hex, block_hash_bytes);

  char stack_string[WORK_LENGTH * 2];
  uint8_t work_[WORK_LENGTH];
  int res = work(block_hash_bytes, 0, 1, work_);
  bytes_to_hex(work_, WORK_LENGTH, stack_string);

  if (res == 0) {
    return rb_str_new(stack_string, WORK_LENGTH * 2);
  } else {
    return Qnil;
  }
}

void Init_nanocurrency_ext() {
  cNanocurrency = rb_define_module("NanocurrencyExt");
  rb_define_singleton_method(cNanocurrency, "public_key", nanocurrency_public_key, 1);
  rb_define_singleton_method(cNanocurrency, "sign", nanocurrency_sign, 2);
  rb_define_singleton_method(cNanocurrency, "compute_work", nanocurrency_compute_work, 1);
}
