import wasmer

fn test_add() {
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
    )')?

	mod := wasmer.compile(store, wasm)?
	imports := []wasmer.Extern{}
	mut trap := wasmer.Trap{}
	defer {
		trap.delete()
	}
	instance := wasmer.instance(store, mod, imports, mut trap)

	func := instance.exports()[0].as_func()?
	mut results := [wasmer.val_i32(0)]
	trap = func.call([wasmer.val_i32(2), wasmer.val_i32(3)], mut results)

	assert !trap.is_set()
	assert results[0].i32() == 5
}

fn callback(mut args wasmer.Arguments) ? {
	println('Hello from WASM! Argument 0: ${args.arg(0)}')
	args.set_result(0, wasmer.val_i32(42))?
	return
}

fn test_callback() {
	mut config := wasmer.config()
	config.set_compiler(.cranelift)
	engine := wasmer.engine_with_config(config)
	defer {
		engine.delete()
	}

	store := wasmer.store(engine)
	defer {
		store.delete()
	}

	wasm := wasmer.wat2wasm('
        (module 
			(func \$host_function (import "" "host_function") (param i32) (result i32))
			(func \$f (param \$arg i32) (result i32)
				(call \$host_function (local.get \$arg)))

			(export "f" (func \$f))
		)')?

	mod := wasmer.compile(store, wasm)?

	ty := wasmer.func_type([wasmer.val_type(.wasm_i32)], [wasmer.val_type(.wasm_i32)])
	defer {
		ty.delete()
	}
	func := wasmer.func(store, ty, callback)
	mut trap := wasmer.Trap{}
	defer {
		trap.delete()
	}
	instance := wasmer.instance(store, mod, [func.as_extern()], mut trap)
	exports := instance.exports()
	wasm_func := exports[0].as_func()?
	mut results := [wasmer.val_i32(0)]
	trap = wasm_func.call([wasmer.val_i32(44)], mut results)
	assert !trap.is_set()
	assert results[0].i32() == 42
}

fn test_memory() {
	mut config := wasmer.config()
	config.set_compiler(.cranelift)
	engine := wasmer.engine_with_config(config)
	defer {
		engine.delete()
	}

	store := wasmer.store(engine)
	defer {
		store.delete()
	}

	wasm := wasmer.wat2wasm('
		(module 
			(type \$mem_size_t (func (result i32)))
			(type \$get_at_t (func (param i32) (result i32)))
			(type \$set_at_t (func (param i32) (param i32)))
			(memory \$mem 1)
			(func \$get_at (type \$get_at_t) (param \$idx i32) (result i32)
				(i32.load (local.get \$idx)))
			(func \$set_at (type \$set_at_t) (param \$idx i32) (param \$val i32)
				(i32.store (local.get \$idx) (local.get \$val)))
			(func \$mem_size (type \$mem_size_t) (result i32)
				(memory.size))
			(export "get_at" (func \$get_at))
			(export "set_at" (func \$set_at))
			(export "mem_size" (func \$mem_size))
			(export "memory" (memory \$mem)))')?

	mod := wasmer.compile(store, wasm)?

	mut trap := wasmer.Trap{}
	defer {
		trap.delete()
	}
	instance := wasmer.instance(store, mod, [], mut trap)

	exports := instance.exports()

	get_at := exports[0].as_func()?
	set_at := exports[1].as_func()?
	mem_size := exports[2].as_func()?
	memory := exports[3].as_memory()?

	mem_addr := int(0x2220)
	ptr := wasmer.wasm_ptr<int>(u32(mem_addr))
	val := 0xFEFEFFE
	mut results := []wasmer.Val{}
	trap = set_at.call([wasmer.val_i32(mem_addr), wasmer.val_i32(val)], mut results)
	results.clear()
	assert !trap.is_set()
	assert *ptr.deref(memory)? == val

	results << wasmer.val_i32(0)
	trap = get_at.call([wasmer.val_i32(mem_addr)], mut results)

	assert !trap.is_set()
	assert results[0].i32() == val
}
