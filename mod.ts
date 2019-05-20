import { assert } from "https://deno.land/x/testing/asserts.ts";
import { Wasm, loadWasm } from "./loadWasm.ts";

const wasm: Wasm = loadWasm();

export const STATE_BYTES: number = 48;
export const WASM: Uint8Array = wasm.buffer;

export function gimli(state: Uint32Array): void {
  assert(state.byteLength === STATE_BYTES);
  wasm.mempush(state, 0);

  console.log("memview", wasm.memview.subarray(0, 12))

  wasm.exports.gimli(0);
  wasm.mempull(state, 0);
}
