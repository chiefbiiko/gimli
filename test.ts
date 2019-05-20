import { test, runIfMain } from "https://deno.land/x/testing/mod.ts";
import { assertEquals } from "https://deno.land/x/testing/asserts.ts";
import { gimli } from "./mod.ts";

interface TestVector {
  pre_permutation_state: Uint32Array;
  post_permutation_state: Uint32Array;
}

const testVectors: TestVector[] = JSON.parse(
  new TextDecoder().decode(Deno.readFileSync("./test_vectors.json"))
).map(({ pre_permutation_state, post_permutation_state }): TestVector => ({
  pre_permutation_state: Uint32Array.from(pre_permutation_state),
  post_permutation_state: Uint32Array.from(post_permutation_state)
}));

test(function gimliPermutation() {
  const state = new Uint32Array(12);
  for (const { pre_permutation_state, post_permutation_state } of testVectors) {
    state.set(pre_permutation_state);
    gimli(state);
    assertEquals(state, post_permutation_state);
  }
});

runIfMain(import.meta);
