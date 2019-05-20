import { toUint8Array } from "https://deno.land/x/base64/mod.ts";

export interface Wasm {
  buffer: Uint8Array;
  exports: { [key: string]: any };
  memview: Uint32Array;
  mempush: (state: Uint32Array, offset: number) => void;
  mempull: (state: Uint32Array, offset: number) => void;
}

export function loadWasm(): Wasm {
  const mod: Wasm = {} as Wasm;
  // const memory: WebAssembly.Memory = new WebAssembly.Memory({
  //   initial: 1,
  //   maximum: 1
  // });
  mod.buffer = toUint8Array(
    "AGFzbQEAAAABCAJgAX8AYAAAAiECB2ltcG9ydHMFcHJpbnQAAAdpbXBvcnRzBXNwYWNlAAEDAgEABQQBAQEBBxICBm1lbW9yeQIABWdpbWxpAAIKygQBxwQBEH8gACgCACEBIAAoAgQhAiAAKAIIIQMgACgCDCEEIAAoAhAhBSAAKAIUIQYgACgCGCEHIAAoAhwhCCAAKAIgIQkgACgCJCEKIAAoAighCyAAKAIsIQwgARAAEAEgAhAAEAEgAxAAEAEgBBAAEAEgBRAAAEEYIQ0CQANAIA1FDQEgAUEYdyEOIAVBCXchDyAJIRAgDiAQQQF0cyAPIBBxQQJ0cyEJIA8gDnMgDiAPckEBdHMhBSAQIA9zIA4gD3FBA3RzIQEgAkEYdyEOIAZBCXchDyAKIRAgDiAQQQF0cyAPIBBxQQJ0cyEKIA8gDnMgDiAPckEBdHMhBiAQIA9zIA4gD3FBA3RzIQIgA0EYdyEOIAdBCXchDyALIRAgDiAQQQF0cyAPIBBxQQJ0cyELIA8gDnMgDiAPckEBdHMhByAQIA9zIA4gD3FBA3RzIQMgBEEYdyEOIAhBCXchDyAMIRAgDiAQQQF0cyAPIBBxQQJ0cyEMIA8gDnMgDiAPckEBdHMhCCAQIA9zIA4gD3FBA3RzIQQgDUEDcUUEQCABIQ4gAiEBIA4hAiADIQ4gBCEDIA4hBCABQYDy3fF5IA1xcyEBCyANQQNxQQJGBEAgASEOIAMhASAOIQMgAiEOIAQhAiAOIQQLIA1BAWshDQwACwsgACABNgIAIAAgAjYCBCAAIAM2AgggACAENgIMIAAgBTYCECAAIAY2AhQgACAHNgIYIAAgCDYCHCAAIAk2AiAgACAKNgIkIAAgCzYCKCAAIAw2AiwL"
  );
  mod.exports = new WebAssembly.Instance(new WebAssembly.Module(mod.buffer), {
    imports: {
      // memory,
      print(arg: number): void {
        console.log(arg);
      },
      space(): void {
        console.log(" ");
      }
    }
  }).exports;
  mod.memview = new Uint32Array(mod.exports.memory.buffer);
  // mod.memview = new Uint32Array(memory.buffer, 0, 12);
  mod.mempush = (state: Uint32Array, offset: number): void => {
    mod.memview.set(state, offset);
  };
  mod.mempull = (state: Uint32Array, offset: number): void => {
    state.set(mod.memview.subarray(0, 12), offset);
  };
  return mod;
}
