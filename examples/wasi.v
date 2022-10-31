import wasmer
import os

fn print_wasmer_error() {
	err := wasmer.get_wasmer_error() or { return }

	println('error: $err')
}

fn main() {
	println('Initializing...')
	engine := wasmer.engine()
	store := wasmer.store(engine)
	defer {
		store.delete()
		engine.delete()
	}

	println('Setting up WASI...')
	mut config := wasmer.wasi_config('example_program')

	config.arg('--eval')
	config.arg('function greet(name) { return JSON.stringify("Hello, " + name); }; print(greet("World"));')
	config.inherit_stdout()
	println('Compiling module...')

	file := os.read_bytes('examples/qjs.wasm')!
	mod := wasmer.compile(store, file)?

	wasi_env := wasmer.wasi_env(store, config)?

	imports := store.get_imports(mod, wasi_env)?

	mut trap := wasmer.null_trap()

	instance := wasmer.instance(store, mod, imports, mut trap)

	wasi_env.initialize_instance(store, instance)!

	exports := instance.exports()

	println('found $exports.len exports')

	run_func := instance.get_start_function()?

	println('Calling export\nEvaluating "function greet(name) { return JSON.stringify("Hello, " + name); }; print(greet("World"));"')
	mut results := []wasmer.Val{}
	_ = run_func.call([], mut results)

	println('Call completed')
}
