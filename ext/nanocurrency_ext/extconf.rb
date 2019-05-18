require 'mkmf'
$CFLAGS += ' -DED25519_CUSTOMHASH -Wall -Wextra -std=c99 -pedantic -Wno-long-long -Wunused-parameter'
create_makefile('nanocurrency_ext')
