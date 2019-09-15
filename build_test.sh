#!/usr/bin/env bash

set -Eeuo pipefail

# cleaning
rm -f ./gimli.wasm

# compiling
wat2wasm ./gimli.wat -o ./gimli.wasm

# b64 encoding
b64wasm=$(base64 ./gimli.wasm | tr -d '\t\r\n')

# counting
b64line=$(cat loadWasm.ts | grep -n AGFzbQ | cut -f1 -d:)

# heading
loadHead=$(head -n $(($b64line - 1)) loadWasm.ts)

# tailing
loadTail=$(tail -n +$(($b64line + 1)) loadWasm.ts)

# assembling
loadWasm="$loadHead\n    \"$b64wasm\"\n$loadTail"

# writing
echo -e "$loadWasm" > ./loadWasm.ts

# testing
deno run --allow-read --reload ./test.ts
