module wasmer

import strings

pub struct Val {
pub mut:
	inner C.wasm_val_t
}

pub fn val_i32(v int) Val {
	return Val{wasm_i32_val(v)}
}

pub fn val_i64(v i64) Val {
	return Val{wasm_i64_val(v)}
}

pub fn val_f64(v f64) Val {
	return Val{wasm_f64_val(v)}
}

pub fn val_f32(v f32) Val {
	return Val{wasm_f32_val(v)}
}

pub fn val_ref(v voidptr) Val {
	return Val{wasm_ref_val(v)}
}

pub fn val_null() Val {
	return val_ref(voidptr(0))
}

pub fn (val Val) kind() WasmValKind {
	return val.inner.kind
}

pub fn (val Val) i32() i32 {
	return unsafe {
		val.inner.of.i32
	}
}

pub fn (val Val) str() string {
	unsafe {
		match val.inner.kind {
			.wasm_i32 {
				return '$val.inner.of.i32'
			}
			.wasm_i64 {
				return '$val.inner.of.i64'
			}
			.wasm_f64 {
				return '$val.inner.of.f64'
			}
			.wasm_f32 {
				return '$val.inner.of.f32'
			}
			.wasm_anyref {
				return '${voidptr(val.inner.of.ref)}'
			}
			else {
				return 'unknown value'
			}
		}
	}
}

pub struct ValVec {
mut:
	inner C.wasm_val_vec_t
}

pub fn val_vec(x []Val) ValVec {
	mut b := C.wasm_val_vec_t{}
	C.wasm_val_vec_new(&b, usize(x.len), x.data)
	return ValVec{b}
}

pub fn val_vec_uninitialized(size usize) ValVec {
	mut b := C.wasm_val_vec_t{}
	C.wasm_val_vec_new_uninitialized(&b, size)
	return ValVec{b}
}

pub fn (v ValVec) at(i int) Val {
	unsafe {
		return Val{v.inner.data[i]}
	}
}

pub fn (v ValVec) set_at(i int, val Val) {
	unsafe {
		v.inner.data[i] = val.inner
	}
}

pub fn (v ValVec) delete() {
	C.wasm_val_vec_delete(&v.inner)
}

pub fn (v ValVec) str() string {
	mut builder := strings.new_builder(40)
	builder.write_string('ValVec{')
	for i in 0 .. v.inner.size {
		unsafe {
			val := Val{v.inner.data[i]}
			builder.write_string('$val')
			if i != v.inner.size - 1 {
				builder.write_string(',')
			}
		}
	}
	builder.write_string('}')
	return builder.str()
}

pub struct ByteVec {
mut:
	inner C.wasm_byte_vec_t
}

pub fn byte_vec(x []byte) ByteVec {
	mut b := C.wasm_byte_vec_t{}
	C.wasm_byte_vec_new(&b, usize(x.len), x.data)
	return ByteVec{b}
}

pub fn (v ByteVec) at(i int) u8 {
	unsafe {
		return v.inner.data[i]
	}
}

pub fn (v ByteVec) set_at(i int, val u8) {
	unsafe {
		v.inner.data[i] = val
	}
}

pub fn (v ByteVec) to_string() string {
	unsafe {
		return v.inner.data.vbytes(int(v.inner.size)).bytestr()
	}
}

pub fn (v ByteVec) delete() {
	C.wasm_byte_vec_delete(&v.inner)
}

pub fn (v ByteVec) str() string {
	mut builder := strings.new_builder(40)
	builder.write_string('ByteVec{')
	for i in 0 .. v.inner.size {
		unsafe {
			builder.write_string('${v.inner.data[i]}')
			if i != v.inner.size - 1 {
				builder.write_string(',')
			}
		}
	}
	builder.write_string('}')
	return builder.str()
}

pub struct ExternVec {
mut:
	inner C.wasm_extern_vec_t
}

pub struct Extern {
	inner &C.wasm_extern_t
}

pub struct Func {
	inner &C.wasm_func_t
}

pub fn (f Func) as_extern() Extern {
	return Extern{C.wasm_func_as_extern(f.inner)}
}

pub fn (f Func) param_arity() usize {
	return C.wasm_func_param_arity(f.inner)
}

pub fn (f Func) result_arity() usize {
	return C.wasm_func_result_arity(f.inner)
}

pub fn (f Func) call(args []Val, mut results []Val) Trap {
	real_args := val_vec(args)

	mut out := val_vec_uninitialized(usize(results.len))
	trap := Trap{C.wasm_func_call(f.inner, &real_args.inner, &out.inner)}
	for i in 0 .. out.inner.size {
		unsafe {
			results[i] = Val{out.inner.data[i]}
		}
	}
	out.delete()
	real_args.delete()
	return trap
}

pub fn (e Extern) as_func() ?Func {
	x := C.wasm_extern_as_func(e.inner)
	if isnil(x) {
		return none
	}
	return Func{x}
}

pub fn extern_vec(externs []Extern) ExternVec {
	mut v := C.wasm_extern_vec_t{}
	C.wasm_extern_vec_new(&v, usize(externs.len), externs.data)
	return ExternVec{v}
}

pub fn extern_vec_empty() ExternVec {
	mut v := C.wasm_extern_vec_t{}
	C.wasm_extern_vec_new_empty(&v)
	return ExternVec{v}
}

pub fn (v ExternVec) delete() {
	C.wasm_extern_vec_delete(&v.inner)
}

pub fn (v ExternVec) at(i int) Extern {
	unsafe {
		return Extern{v.inner.data[i]}
	}
}

pub fn (v ExternVec) set_at(i int, val Extern) {
	unsafe {
		v.inner.data[i] = val.inner
	}
}

pub fn wat2wasm(source string) ?ByteVec {
	mut out := ByteVec{}
	src := byte_vec(source.bytes())
	C.wat2wasm(&src.inner, &out.inner)
	src.delete()
	err := get_wasmer_error() or { return out }
	out.delete()
	return error(err)
}

pub struct Engine {
	inner &C.wasm_engine_t
}

pub fn engine() Engine {
	return Engine{C.wasm_engine_new()}
}

// engine_with_config will construct Wasmer engine with config from `c`.
// Note: Config will be deallocated aftetr this call automatically
pub fn engine_with_config(c Config) Engine {
	e := Engine{C.wasm_engine_new_with_config(c.inner)}
	c.delete()
	return e
}

pub fn config() Config {
	return Config{C.wasm_config_new()}
}

pub struct Config {
	inner &C.wasm_config_t
}

pub fn (mut config Config) set_compiler(cc WasmerCompiler) {
	C.wasm_config_set_compiler(config.inner, cc)
}

pub fn (mut config Config) set_engine(engine WasmerEngine) {
	C.wasm_config_set_engine(config.inner, engine)
}

pub fn (engine Engine) delete() {
	C.wasm_engine_delete(engine.inner)
}

pub fn (config Config) delete() {
	C.wasm_config_delete(config.inner)
}

pub struct Store {
	inner &C.wasm_store_t
}

pub fn (store Store) delete() {
	C.wasm_store_delete(store.inner)
}

pub fn store(engine Engine) Store {
	return Store{C.wasm_store_new(engine.inner)}
}

pub struct Module {
	inner &C.wasm_module_t
}

pub fn get_wasmer_error() ?string {
	if C.wasmer_last_error_length() == 0 {
		return none
	}

	buf := []byte{len: C.wasmer_last_error_length(), cap: C.wasmer_last_error_length(), init: 0}
	C.wasmer_last_error_message(buf.data, C.wasmer_last_error_length())
	return buf.bytestr()
}

pub fn compile(store Store, wasm ByteVec) ?Module {
	mod := C.wasm_module_new(store.inner, &wasm.inner)
	err := get_wasmer_error() or { return Module{mod} }

	return error(err)
}

pub struct Instance {
	inner &C.wasm_instance_t
}

pub struct Trap {
	inner &C.wasm_trap_t = 0
}

pub fn (t Trap) is_set() bool {
	return !isnil(t.inner)
}

pub fn (t Trap) delete() {
	if t.is_set() {
		C.wasm_trap_delete(t.inner)
	}
}

pub fn (t Trap) message() ?string {
	if !t.is_set() {
		return none
	}

	mut bytes := ByteVec{}
	C.wasm_trap_message(t.inner, &bytes.inner)

	return bytes.to_string()
}

pub fn null_trap() Trap {
	return Trap{}
}

pub fn instance(store Store, mod Module, imports ExternVec, mut trap Trap) Instance {
	return Instance{C.wasm_instance_new(store.inner, mod.inner, &imports.inner, &trap.inner)}
}

pub fn (instance Instance) exports() ExternVec {
	mut x := extern_vec_empty()
	C.wasm_instance_exports(instance.inner, &x.inner)
	return x
}
