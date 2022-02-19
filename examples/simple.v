import wasmer

fn main() {
	engine := wasmer.engine()
	store := wasmer.store(engine)
	defer {
		store.delete()
		engine.delete()
	}

	wasm := wasmer.wat2wasm('(module
        (func \$add (param \$lhs i32) (param \$rhs i32) (result i32)
            local.get \$lhs
            local.get \$rhs
            i32.add)
        (export "add" (func \$add))
    )') ?

	mod := wasmer.compile(store, wasm) ?
	imports := []wasmer.Extern{}
	mut trap := wasmer.Trap{}
	defer {
		trap.delete()
	}
	instance := wasmer.instance(store, mod, imports, mut trap)

	func := instance.exports()[0].as_func() ?
	mut results := [wasmer.val_i32(0)]
	trap = func.call([wasmer.val_i32(2), wasmer.val_i32(3)], mut results)
	if trap.is_set() {
		println(trap.message() ?)
	} else {
		println(results[0])
	}
}
