import wasmer

fn callback(mut args wasmer.Arguments) ? {
	println('Hello from WASM! Argument 0: ${args.arg(0)}')
	args.set_result(0, wasmer.val_i32(42)) ?
	return
}

fn main() {
	mut config := wasmer.config()
	config.set_compiler(.cranelift)
	engine := wasmer.engine_with_config(config)

	store := wasmer.store(engine)

	wasm := wasmer.wat2wasm('
        (module 
			(func \$host_function (import "" "host_function") (param i32) (result i32))
			(func \$f (param \$arg i32) (result i32)
				(call \$host_function (local.get \$arg)))

			(export "f" (func \$f))
		)') ?

	mod := wasmer.compile(store, wasm) ?

	ty := wasmer.func_type([wasmer.val_type(.wasm_i32)], [wasmer.val_type(.wasm_i32)])
	func := wasmer.func(store, ty, callback)
	ty.delete()
	mut trap := wasmer.Trap{}
	instance := wasmer.instance(store, mod, [func.as_extern()], mut trap)

	wasm_func := instance.exports().at(0).as_func() ?
	mut results := [wasmer.val_i32(0)]
	trap = wasm_func.call([wasmer.val_i32(44)], mut results)
	if trap.is_set() {
		panic(trap.message() ?)
	} else {
		println(results[0])
	}

	engine.delete()
	trap.delete()
	store.delete()
}
