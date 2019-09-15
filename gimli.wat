(module
  (func $print (import "imports" "print") (param i32))

  (memory (export "memory") 1 1)

  (func (export "gimli") (param $ptr i32)
    (local $a i32)
    (local $b i32)
    (local $c i32)
    (local $d i32)
    (local $e i32)
    (local $f i32)
    (local $g i32)
    (local $h i32)
    (local $i i32)
    (local $j i32)
    (local $k i32)
    (local $l i32)

    (local $r i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)

    ;; BUG: every other load yields a wrong int
    (set_local $a (i32.load offset=0 (get_local $ptr)))
    (set_local $b (i32.load offset=4 (get_local $ptr)))
    (set_local $c (i32.load offset=8 (get_local $ptr)))
    (set_local $d (i32.load offset=12 (get_local $ptr)))
    (set_local $e (i32.load offset=16 (get_local $ptr)))
    (set_local $f (i32.load offset=20 (get_local $ptr)))
    (set_local $g (i32.load offset=24 (get_local $ptr)))
    (set_local $h (i32.load offset=28 (get_local $ptr)))
    (set_local $i (i32.load offset=32 (get_local $ptr)))
    (set_local $j (i32.load offset=36 (get_local $ptr)))
    (set_local $k (i32.load offset=40 (get_local $ptr)))
    (set_local $l (i32.load offset=44 (get_local $ptr)))

    ;; TRY

    (call $print (get_local $a))
    (call $print (get_local $b))
    (call $print (get_local $c))
    (call $print (get_local $d))
    (call $print (get_local $e))
    (unreachable)

    ;; 24 rounds
    (set_local $r (i32.const 24))

    (block $end_loop
      (loop $start_loop
        (br_if $end_loop (i32.eqz (get_local $r)))

        ;; non-linear layer, 96-bit SP-box applied to each column
        (set_local $x (i32.rotl (get_local $a) (i32.const 24)))
        (set_local $y (i32.rotl (get_local $e) (i32.const 9)))
        (set_local $z (get_local $i))

        (set_local $i
          (i32.xor
            (i32.xor (get_local $x) (i32.shl (get_local $z) (i32.const 1)))
            (i32.shl (i32.and (get_local $y) (get_local $z)) (i32.const 2))
          )
        )
        (set_local $e
          (i32.xor
            (i32.xor (get_local $y) (get_local $x))
            (i32.shl (i32.or (get_local $x) (get_local $y)) (i32.const 1))
          )
        )
        (set_local $a
          (i32.xor
            (i32.xor (get_local $z) (get_local $y))
            (i32.shl (i32.and (get_local $x) (get_local $y)) (i32.const 3))
          )
        )

        (set_local $x (i32.rotl (get_local $b) (i32.const 24)))
        (set_local $y (i32.rotl (get_local $f) (i32.const 9)))
        (set_local $z (get_local $j))

        (set_local $j
          (i32.xor
            (i32.xor (get_local $x) (i32.shl (get_local $z) (i32.const 1)))
            (i32.shl (i32.and (get_local $y) (get_local $z)) (i32.const 2))
          )
        )
        (set_local $f
          (i32.xor
            (i32.xor (get_local $y) (get_local $x))
            (i32.shl (i32.or (get_local $x) (get_local $y)) (i32.const 1))
          )
        )
        (set_local $b
          (i32.xor
            (i32.xor (get_local $z) (get_local $y))
            (i32.shl (i32.and (get_local $x) (get_local $y)) (i32.const 3))
          )
        )

        (set_local $x (i32.rotl (get_local $c) (i32.const 24)))
        (set_local $y (i32.rotl (get_local $g) (i32.const 9)))
        (set_local $z (get_local $k))

        (set_local $k
          (i32.xor
            (i32.xor (get_local $x) (i32.shl (get_local $z) (i32.const 1)))
            (i32.shl (i32.and (get_local $y) (get_local $z)) (i32.const 2))
          )
        )
        (set_local $g
          (i32.xor
            (i32.xor (get_local $y) (get_local $x))
            (i32.shl (i32.or (get_local $x) (get_local $y)) (i32.const 1))
          )
        )
        (set_local $c
          (i32.xor
            (i32.xor (get_local $z) (get_local $y))
            (i32.shl (i32.and (get_local $x) (get_local $y)) (i32.const 3))
          )
        )

        (set_local $x (i32.rotl (get_local $d) (i32.const 24)))
        (set_local $y (i32.rotl (get_local $h) (i32.const 9)))
        (set_local $z (get_local $l))

        (set_local $l
          (i32.xor
            (i32.xor (get_local $x) (i32.shl (get_local $z) (i32.const 1)))
            (i32.shl (i32.and (get_local $y) (get_local $z)) (i32.const 2))
          )
        )
        (set_local $h
          (i32.xor
            (i32.xor (get_local $y) (get_local $x))
            (i32.shl (i32.or (get_local $x) (get_local $y)) (i32.const 1))
          )
        )
        (set_local $d
          (i32.xor
            (i32.xor (get_local $z) (get_local $y))
            (i32.shl (i32.and (get_local $x) (get_local $y)) (i32.const 3))
          )
        )

        ;; linear layer
        (if (i32.eqz (i32.and (get_local $r) (i32.const 3)))
          (then
            ;; Small-Swap
            (set_local $x (get_local $a))
            (set_local $a (get_local $b))
            (set_local $b (get_local $x))
            (set_local $x (get_local $c))
            (set_local $c (get_local $d))
            (set_local $d (get_local $x))
            (set_local $a
              (i32.xor
                (get_local $a)
                (i32.and (i32.const 0x9e377900) (get_local $r))
              )
            )
          )
        )

        (if (i32.eq (i32.and (get_local $r) (i32.const 3)) (i32.const 2))
          (then
            ;; Big-Swap
            (set_local $x (get_local $a))
            (set_local $a (get_local $c))
            (set_local $c (get_local $x))
            (set_local $x (get_local $b))
            (set_local $b (get_local $d))
            (set_local $d (get_local $x))
          )
        )

        (set_local $r (i32.sub (get_local $r) (i32.const 1)))
        (br $start_loop)
      )
    )

    (i32.store offset=0 (get_local $ptr) (get_local $a))
    (i32.store offset=4 (get_local $ptr) (get_local $b))
    (i32.store offset=8 (get_local $ptr) (get_local $c))
    (i32.store offset=12 (get_local $ptr) (get_local $d))
    (i32.store offset=16 (get_local $ptr) (get_local $e))
    (i32.store offset=20 (get_local $ptr) (get_local $f))
    (i32.store offset=24 (get_local $ptr) (get_local $g))
    (i32.store offset=28 (get_local $ptr) (get_local $h))
    (i32.store offset=32 (get_local $ptr) (get_local $i))
    (i32.store offset=36 (get_local $ptr) (get_local $j))
    (i32.store offset=40 (get_local $ptr) (get_local $k))
    (i32.store offset=44 (get_local $ptr) (get_local $l))
  )
)
