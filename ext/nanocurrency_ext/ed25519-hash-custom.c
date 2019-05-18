#include <stdlib.h>
#include "ed25519-hash-custom.h"
#include "blake2.h"

void ed25519_hash_init (ed25519_hash_context * ctx)
{
  ctx->blake2 = (blake2b_state *) malloc(sizeof(blake2b_state));
  blake2b_init(ctx->blake2, 64);
}

void ed25519_hash_update (ed25519_hash_context * ctx, uint8_t const * in, size_t inlen)
{
  blake2b_update(ctx->blake2, in, inlen);
}

void ed25519_hash_final (ed25519_hash_context * ctx, uint8_t * out)
{
  blake2b_final (ctx->blake2, out, 64);
  free(ctx->blake2);
}

void ed25519_hash (uint8_t * out, uint8_t const * in, size_t inlen)
{
  ed25519_hash_context ctx;
  ed25519_hash_init (&ctx);
  ed25519_hash_update (&ctx, in, inlen);
  ed25519_hash_final (&ctx, out);
}
