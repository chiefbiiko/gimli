#!/usr/bin/env bash

set -Eeuo pipefail

# cleaning
rm -f ./gimli.wasm

# compiling
wat2wasm ./gimli.wat -o ./gimli.wasm

# b64 encoding
b64_wasm=$(base64 ./gimli.wasm | tr -d '\t\r\n')

# counting
b64_line=$(cat ./loadWasm.ts | grep -n AGFzbQ | cut -f1 -d:)

# heading
load_wasm_head=$(head -n $(($b64_line - 1)) ./loadWasm.ts)

# tailing
load_wasm_tail=$(tail -n +$(($b64_line + 1)) ./loadWasm.ts)

# assembling
load_wasm="$load_wasm_head\n    \"$b64_wasm\"\n$load_wasm_tail"

# writing
echo -e "$load_wasm" > ./loadWasm.ts

# testing
$HOME/.deno/bin/deno run --allow-read --reload ./test.ts
