import { toUint8Array } from "https://deno.land/x/base64/mod.ts";

export interface Wasm {
  buffer: Uint8Array;
  exports: { [key: string]: any };
  memview: Uint32Array;
  mempush: (state: Uint32Array, offset: number) => void;
  mempull: (state: Uint32Array, offset: number) => void;
}

export function loadWasm(): Wasm {
  const wasm: Wasm = {} as Wasm;
  
  wasm.buffer = toUint8Array(
    "AGFzbQEAAAABBQFgAX8AAhEBB2ltcG9ydHMFcHJpbnQAAAMCAQAFBAEBAQEHEgIGbWVtb3J5AgAFZ2ltbGkAAQrCBAG/BAEQfyAAKAIAIQEgACgCBCECIAAoAgghAyAAKAIMIQQgACgCECEFIAAoAhQhBiAAKAIYIQcgACgCHCEIIAAoAiAhCSAAKAIkIQogACgCKCELIAAoAiwhDCABEAAgAhAAIAMQACAEEAAgBRAAAEEYIQ0CQANAIA1FDQEgAUEYdyEOIAVBCXchDyAJIRAgDiAQQQF0cyAPIBBxQQJ0cyEJIA8gDnMgDiAPckEBdHMhBSAQIA9zIA4gD3FBA3RzIQEgAkEYdyEOIAZBCXchDyAKIRAgDiAQQQF0cyAPIBBxQQJ0cyEKIA8gDnMgDiAPckEBdHMhBiAQIA9zIA4gD3FBA3RzIQIgA0EYdyEOIAdBCXchDyALIRAgDiAQQQF0cyAPIBBxQQJ0cyELIA8gDnMgDiAPckEBdHMhByAQIA9zIA4gD3FBA3RzIQMgBEEYdyEOIAhBCXchDyAMIRAgDiAQQQF0cyAPIBBxQQJ0cyEMIA8gDnMgDiAPckEBdHMhCCAQIA9zIA4gD3FBA3RzIQQgDUEDcUUEQCABIQ4gAiEBIA4hAiADIQ4gBCEDIA4hBCABQYDy3fF5IA1xcyEBCyANQQNxQQJGBEAgASEOIAMhASAOIQMgAiEOIAQhAiAOIQQLIA1BAWshDQwACwsgACABNgIAIAAgAjYCBCAAIAM2AgggACAENgIMIAAgBTYCECAAIAY2AhQgACAHNgIYIAAgCDYCHCAAIAk2AiAgACAKNgIkIAAgCzYCKCAAIAw2AiwL"
  );
  
  wasm.exports = new WebAssembly.Instance(new WebAssembly.Module(wasm.buffer), {
    imports: {
      print: console.log
    }
  }).exports;
  
  wasm.memview = new Uint32Array(wasm.exports.memory.buffer);
  
  wasm.mempush = (state: Uint32Array, offset: number): void => {
    wasm.memview.set(state, offset);
  };
  
  wasm.mempull = (state: Uint32Array, offset: number): void => {
    state.set(wasm.memview.subarray(0, 12), offset);
  };
  
  return wasm;
}
