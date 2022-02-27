module wasmer

import strings

// An engine drives the compilation and the runtime.
pub struct Engine {
	inner &C.wasm_engine_t
}

struct ValVec {
mut:
	inner C.wasm_val_vec_t
}

struct ByteVec {
mut:
	inner C.wasm_byte_vec_t
}

struct ExternVec {
mut:
	inner C.wasm_extern_vec_t
}

pub struct Val {
pub mut:
	inner C.wasm_val_t
}

pub struct Extern {
	inner &C.wasm_extern_t
}

pub struct Func {
	inner &C.wasm_func_t
}

pub struct Global {
	inner &C.wasm_global_t
}

pub struct Memory {
	inner &C.wasm_memory_t
}

pub struct Table {
	inner &C.wasm_table_t
}

pub struct ValType {
	inner &C.wasm_valtype_t
}

pub struct ExternType {
	inner &C.wasm_externtype_t
}

pub struct FuncType {
	inner &C.wasm_functype_t
}

pub struct GlobalType {
	inner &C.wasm_globaltype_t
}

pub struct MemoryType {
	inner &C.wasm_memorytype_t
}

pub struct TableType {
	inner &C.wasm_tabletype_t
}

pub struct ExportType {
	inner &C.wasm_exporttype_t
}

// A WebAssembly module contains stateless WebAssembly code that has already been compiled and can be instantiated multiple times.
pub struct Module {
	inner &C.wasm_module_t
}

// A WebAssembly instance is a stateful, executable instance of a WebAssembly module.
//
// Instance objects contain all the exported WebAssembly functions, memories, tables and globals that allow interacting with WebAssembly.
pub struct Instance {
	inner &C.wasm_instance_t
}

// A trap represents an error which stores trace message with backtrace
pub struct Trap {
	inner &C.wasm_trap_t = 0
}

// A configuration holds the compiler and the engine used by the store.
pub struct Config {
	inner &C.wasm_config_t
}

// A store represents all global state that can be manipulated by WebAssembly programs. It consists of the runtime representation of all instances of functions, tables, memories, and globals that have been allocated during the lifetime of the abstract machine.
//
// The store holds the engine (that is —amonst many things— used to compile the Wasm bytes into a valid module artifact), in addition to extra private types.
pub struct Store {
	inner &C.wasm_store_t
}

pub struct Frame {
	inner &C.wasm_frame_t
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

pub fn (val Val) i64() i64 {
	return unsafe {
		val.inner.of.i64
	}
}

pub fn (val Val) f32() f32 {
	return unsafe {
		val.inner.of.f32
	}
}

pub fn (val Val) f64() f64 {
	return unsafe {
		val.inner.of.f64
	}
}

pub fn (val Val) ref() voidptr {
	return unsafe {
		val.inner.of.ref
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

fn byte_vec(x []byte) ByteVec {
	mut b := C.wasm_byte_vec_t{}
	C.wasm_byte_vec_new(&b, usize(x.len), x.data)
	return ByteVec{b}
}

fn (v ByteVec) at(i int) u8 {
	unsafe {
		return v.inner.data[i]
	}
}

fn (v ByteVec) set_at(i int, val u8) {
	unsafe {
		v.inner.data[i] = val
	}
}

fn (v ByteVec) to_string() string {
	unsafe {
		return v.inner.data.vbytes(int(v.inner.size)).bytestr()
	}
}

fn (v ByteVec) delete() {
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

pub fn (f Func) as_extern() Extern {
	return Extern{C.wasm_func_as_extern(f.inner)}
}

// returns the number of parameters that this function takes.
pub fn (f Func) param_arity() usize {
	return C.wasm_func_param_arity(f.inner)
}

// result_arity returns the number of results this function produces.
pub fn (f Func) result_arity() usize {
	return C.wasm_func_result_arity(f.inner)
}

// call invokes function with `args` as arguments and puts function returns to `results` array. Note that
// results array must already be initialized to the size of `Func.result_arity()` so it can hold return values.
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

pub fn (f Func) typ() FuncType {
	return FuncType{C.wasm_func_type(f.inner)}
}

pub fn func_raw(store Store, ftype FuncType, callback CWasmFuncCallback) Func {
	return Func{C.wasm_func_new(store.inner, ftype.inner, callback)}
}

pub fn func_raw_with_env(store Store, ftype FuncType, callback CWasmFuncCallbackWithEnv, env voidptr, env_finalizer fn (voidptr)) Func {
	return Func{C.wasm_func_new_with_env(store.inner, ftype.inner, callback, env, voidptr(0))}
}

pub struct Arguments {
	args &C.wasm_val_vec_t
	env  voidptr
mut:
	results &C.wasm_val_vec_t
}

pub fn (args Arguments) arg(i int) ?Val {
	if i < 0 || i >= int(args.args.size) {
		return none
	}
	return unsafe {
		Val{args.args.data[i]}
	}
}

pub fn (args Arguments) env() voidptr {
	return args.env
}

pub fn (mut args Arguments) set_result(i int, val Val) ? {
	if i < 0 || i >= int(args.results.size) {
		return error('out of bounds while setting result value')
	}
	unsafe {
		args.results.data[i] = val.inner
	}
}

struct WasmVEnv {
mut:
	callback WasmCallback
	store    &C.wasm_store_t

	additional_env voidptr
	env_finalizer  voidptr
}

pub type WasmFinalizer = fn (voidptr)

pub type WasmCallback = fn (mut Arguments) ?

fn invoke_v_func(env_ voidptr, args &C.wasm_val_vec_t, results &C.wasm_val_vec_t) &C.wasm_trap_t {
	unsafe {
		env := &WasmVEnv(env_)
		callback := env.callback

		store := env.store
		mut arguments := Arguments{args, env.additional_env, results}
		callback(mut arguments) or {
			env_finalizer(env_)
			bvec := byte_vec(err.msg.bytes())
			trap := C.wasm_trap_new(store, &bvec.inner)
			return trap
		}
		env_finalizer(env_)
	}
	return &C.wasm_trap_t(0)
}

fn env_finalizer(env voidptr) {
	venv := &WasmVEnv(env)
	if !isnil(venv.additional_env) {
		if !isnil(venv.env_finalizer) {
			fin := WasmFinalizer(venv.env_finalizer)
			fin(venv.additional_env)
		}
	}
	C.free(venv)
}

pub fn func(store Store, ftype FuncType, callback WasmCallback) Func {
	unsafe {
		mut env := &WasmVEnv(C.malloc(sizeof(WasmVEnv)))
		env.callback = callback
		env.store = store.inner
		env.additional_env = voidptr(0)
		return func_raw_with_env(store, ftype, invoke_v_func, voidptr(env), env_finalizer)
	}
}

pub fn func_with_env(store Store, ftype FuncType, callback WasmCallback, env_ voidptr, env_finalizer_ WasmFinalizer) Func {
	unsafe {
		mut env := &WasmVEnv(C.malloc(sizeof(WasmVEnv)))
		env.callback = callback
		env.store = store.inner
		env.additional_env = env_
		env.env_finalizer = voidptr(env_finalizer_)

		return func_raw_with_env(store, ftype, invoke_v_func, voidptr(env), env_finalizer)
	}
}

pub fn (f Func) delete() {
	C.wasm_func_delete(f.inner)
}

pub fn (g Global) as_extern() Extern {
	return Extern{C.wasm_global_as_extern(g.inner)}
}

pub fn (m Memory) as_extern() Extern {
	return Extern{C.wasm_memory_as_extern(m.inner)}
}

pub fn (t Table) as_extern() Extern {
	return Extern{C.wasm_table_as_extern(t.inner)}
}

pub fn (g Global) copy() Global {
	return Global{C.wasm_global_copy(g.inner)}
}

pub fn (g Global) delete() {
	C.wasm_global_delete(g.inner)
}

pub fn (g Global) get() Val {
	mut out := val_null()
	C.wasm_global_get(g.inner, &out.inner)
	return out
}

pub fn (g Global) set(val Val) {
	C.wasm_global_set(g.inner, &val.inner)
}

pub fn (g Global) same(y Global) bool {
	return C.wasm_global_same(g.inner, y.inner)
}

pub fn (g Global) typ() GlobalType {
	return GlobalType{C.wasm_global_type(g.inner)}
}

pub fn global(store Store, typ GlobalType, val Val) Global {
	return Global{C.wasm_global_new(store.inner, typ.inner, &val.inner)}
}

pub fn (m Memory) copy() Memory {
	return Memory{C.wasm_memory_copy(m.inner)}
}

pub fn (m Memory) delete() {
	C.wasm_memory_delete(m.inner)
}

pub fn (m Memory) data() voidptr {
	return C.wasm_memory_data(m.inner)
}

pub fn (m Memory) data_size() usize {
	return C.wasm_memory_data_size(m.inner)
}

pub fn (m Memory) grow(delta u32) bool {
	return C.wasm_memory_grow(m.inner, delta)
}

pub fn (m Memory) memory_same(y Memory) bool {
	return C.wasm_memory_same(m.inner, y.inner)
}

pub fn (m Memory) size() u32 {
	return C.wasm_memory_size(m.inner)
}

pub fn (t Table) copy() Table {
	return Table{C.wasm_table_copy(t.inner)}
}

pub fn (t Table) delete() {
	C.wasm_table_delete(t.inner)
}

pub fn (t Table) grow(delta u32, init voidptr) bool {
	return C.wasm_table_grow(t.inner, delta, init)
}

pub fn (t Table) same(y Table) bool {
	return C.wasm_table_same(t.inner, y.inner)
}

pub fn (t Table) size() usize {
	return C.wasm_table_size(t.inner)
}

pub fn table(store Store, typ TableType, init voidptr) Table {
	return Table{C.wasm_table_new(store.inner, typ.inner, init)}
}

pub fn (m Memory) typ() MemoryType {
	return MemoryType{C.wasm_memory_type(m.inner)}
}

pub fn (e Extern) kind() u8 {
	return C.wasm_extern_kind(e.inner)
}

pub fn (e Extern) typ() ExternType {
	return ExternType{C.wasm_extern_type(e.inner)}
}

pub fn (e Extern) as_func() ?Func {
	x := C.wasm_extern_as_func(e.inner)
	if isnil(x) {
		return none
	}
	return Func{x}
}

pub fn (e Extern) as_global() ?Global {
	x := C.wasm_extern_as_global(e.inner)
	if isnil(x) {
		return none
	}
	return Global{x}
}

pub fn (e Extern) as_memory() ?Memory {
	x := C.wasm_extern_as_memory(e.inner)
	if isnil(x) {
		return none
	}
	return Memory{x}
}

pub fn (e Extern) as_table() ?Table {
	x := C.wasm_extern_as_table(e.inner)
	if isnil(x) {
		return none
	}
	return Table{x}
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

// wat2wasm converts WAT to WASM bytecode. This function returns error
// if source code is not valid WAT.
pub fn wat2wasm(source string) ?[]byte {
	mut out := ByteVec{}
	src := byte_vec(source.bytes())
	C.wat2wasm(&src.inner, &out.inner)
	src.delete()
	err := get_wasmer_error() or {
		mut bytes := []byte{}
		for i in 0 .. out.inner.size {
			unsafe {
				bytes << out.inner.data[i]
			}
		}

		out.delete()
		return bytes
	}
	out.delete()
	return error(err)
}

// engine creates new Wasmer engine
pub fn engine() Engine {
	return Engine{C.wasm_engine_new()}
}

// engine_with_config will construct Wasmer engine with config from `c`.
// Note: Config will be deallocated after this call automatically
pub fn engine_with_config(c Config) Engine {
	e := Engine{C.wasm_engine_new_with_config(c.inner)}
	return e
}

// config creates new Config instance
pub fn config() Config {
	return Config{C.wasm_config_new()}
}

pub fn (mut config Config) set_features(f Features) {
	C.wasm_config_set_features(config.inner, f.inner)
}

// set_compiler updates the configuration to specify a particular compiler to use.
pub fn (mut config Config) set_compiler(cc WasmerCompiler) {
	C.wasm_config_set_compiler(config.inner, cc)
}

// set_engine updates the configuration to specify a particular engine to use.
pub fn (mut config Config) set_engine(engine WasmerEngine) {
	C.wasm_config_set_engine(config.inner, engine)
}

pub fn (engine Engine) delete() {
	C.wasm_engine_delete(engine.inner)
}

pub fn (config Config) delete() {
	C.wasm_config_delete(config.inner)
}

pub fn (store Store) delete() {
	C.wasm_store_delete(store.inner)
}

// store creates a new WebAssembly store given a specific engine.
pub fn store(engine Engine) Store {
	return Store{C.wasm_store_new(engine.inner)}
}

pub fn get_wasmer_error() ?string {
	if C.wasmer_last_error_length() == 0 {
		return none
	}

	buf := []byte{len: C.wasmer_last_error_length(), cap: C.wasmer_last_error_length(), init: 0}
	C.wasmer_last_error_message(buf.data, C.wasmer_last_error_length())
	return buf.bytestr()
}

pub fn compile(store Store, wasm []byte) ?Module {
	wasm_ := byte_vec(wasm)
	mod := C.wasm_module_new(store.inner, &wasm_.inner)

	err := get_wasmer_error() or { return Module{mod} }

	return error(err)
}

pub fn (t Trap) is_set() bool {
	return !isnil(t.inner)
}

pub fn (t Trap) delete() {
	if t.is_set() {
		C.wasm_trap_delete(t.inner)
	}
}

pub fn (t Trap) origin() ?Frame {
	if !t.is_set() {
		return none
	}

	frame := C.wasm_trap_origin(t.inner)
	if isnil(frame) {
		return none
	}
	return Frame{frame}
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

pub fn instance(store Store, mod Module, imports []Extern, mut trap Trap) Instance {
	rimports := extern_vec(imports)
	instance := Instance{C.wasm_instance_new(store.inner, mod.inner, &rimports.inner,
		&trap.inner)}
	rimports.delete()
	return instance
}

pub fn (instance Instance) exports() []Extern {
	mut x := extern_vec_empty()
	mut exports := []Extern{}
	C.wasm_instance_exports(instance.inner, &x.inner)

	for i in 0 .. x.inner.size {
		unsafe {
			exports << Extern{x.inner.data[i]}
			println(exports[int(i)])
		}
	}

	return exports
}

pub fn (ty FuncType) params() []ValType {
	params := C.wasm_functype_params(ty.inner)
	mut out := []ValType{}
	for i in 0 .. params.size {
		out << unsafe { ValType{params.data[i]} }
	}
	return out
}

pub fn (ty FuncType) results() []ValType {
	params := C.wasm_functype_results(ty.inner)
	mut out := []ValType{}
	for i in 0 .. params.size {
		out << unsafe { ValType{params.data[i]} }
	}
	return out
}

pub fn (ty FuncType) copy() FuncType {
	return FuncType{C.wasm_functype_copy(ty.inner)}
}

pub fn (ty FuncType) delete() {
	C.wasm_functype_delete(ty.inner)
}

pub fn func_type(params []ValType, results []ValType) FuncType {
	params_ := C.wasm_valtype_vec_t{}
	results_ := C.wasm_valtype_vec_t{}
	C.wasm_valtype_vec_new(&params_, usize(params.len), params.data)
	C.wasm_valtype_vec_new(&results_, usize(results.len), results.data)
	f := FuncType{C.wasm_functype_new(&params_, &results_)}
	C.wasm_valtype_vec_delete(&params_)
	C.wasm_valtype_vec_delete(&results_)
	return f
}

pub fn global_type(valtype ValType, mutability bool) GlobalType {
	return GlobalType{C.wasm_globaltype_new(valtype.inner, u8(mutability))}
}

pub fn val_type(kind WasmValKind) ValType {
	return ValType{C.wasm_valtype_new(kind)}
}

pub fn (v ValType) str() string {
	return '$v.kind()'
}

pub fn (v ValType) kind() WasmValKind {
	return C.wasm_valtype_kind(v.inner)
}

pub fn (g GlobalType) delete() {
	C.wasm_globaltype_delete(g.inner)
}

pub fn (g GlobalType) mutability() bool {
	return C.wasm_globaltype_mutability(g.inner) != 0
}

pub fn (g GlobalType) content() ValType {
	return ValType{C.wasm_globaltype_content(g.inner)}
}

pub fn (g GlobalType) as_extern_type() ExternType {
	return ExternType{C.wasm_globaltype_as_externtype(g.inner)}
}

pub fn new(min u32, max u32) MemoryType {
	limits := C.wasm_limits_t{min, max}
	return MemoryType{C.wasm_memorytype_new(&limits)}
}

pub fn (m MemoryType) limits() (u32, u32) {
	limits := C.wasm_memorytype_limits(m.inner)
	return limits.min, limits.max
}

pub fn (m MemoryType) delete() {
	C.wasm_memorytype_delete(m.inner)
}

pub fn (m MemoryType) as_extern_type() ExternType {
	return ExternType{C.wasm_memorytype_as_externtype(m.inner)}
}

pub fn (t TableType) limits() (u32, u32) {
	limits := C.wasm_tabletype_limits(t.inner)
	return limits.min, limits.max
}

pub fn (t TableType) element() ValType {
	return ValType{C.wasm_tabletype_element(t.inner)}
}

pub fn (t TableType) delete() {
	C.wasm_tabletype_delete(t.inner)
}

pub fn (t TableType) as_extern_type() ExternType {
	return ExternType{C.wasm_tabletype_as_externtype(t.inner)}
}

pub fn table_type(valtype ValType, min u32, max u32) TableType {
	limits := C.wasm_limits_t{min, max}
	return TableType{C.wasm_tabletype_new(valtype.inner, &limits)}
}

pub fn (e ExportType) copy() ExportType {
	return ExportType{C.wasm_exporttype_copy(e.inner)}
}

pub fn (e ExportType) delete() {
	C.wasm_exporttype_delete(e.inner)
}

pub fn (e ExportType) name() string {
	bvec := C.wasm_exporttype_name(e.inner)
	return unsafe {
		bvec.data.vbytes(int(bvec.size)).bytestr()
	}
}

pub fn (e ExportType) typ() ExternType {
	return ExternType{C.wasm_exporttype_type(e.inner)}
}

pub fn export_type(name string, extern_type ExternType) ExportType {
	name_bvec := byte_vec(name.bytes())
	t := C.wasm_exporttype_new(&name_bvec.inner, extern_type.inner)
	name_bvec.delete()
	return ExportType{t}
}

pub fn (e ExternType) kind() u8 {
	return C.wasm_externtype_kind(e.inner)
}

pub fn (e ExternType) delete() {
	C.wasm_externtype_delete(e.inner)
}

pub fn (e ExternType) copy() ExternType {
	return ExternType{C.wasm_externtype_copy(e.inner)}
}

pub fn (e ExternType) as_global_type() ?GlobalType {
	t := C.wasm_externtype_as_globaltype(e.inner)
	if isnil(t) {
		return none
	}
	return GlobalType{t}
}

pub fn (e ExternType) as_func_type() ?FuncType {
	t := C.wasm_externtype_as_functype(e.inner)
	if isnil(t) {
		return none
	}
	return FuncType{t}
}

pub fn (e ExternType) as_memory_type() ?MemoryType {
	t := C.wasm_externtype_as_memorytype(e.inner)
	if isnil(t) {
		return none
	}
	return MemoryType{t}
}

pub fn (e ExternType) as_table_type() ?TableType {
	t := C.wasm_externtype_as_tabletype(e.inner)
	if isnil(t) {
		return none
	}
	return TableType{t}
}

pub fn (f Frame) delete() {
	C.wasm_frame_delete(f.inner)
}

pub fn (f Frame) copy() Frame {
	return Frame{C.wasm_frame_copy(f.inner)}
}

pub fn (f Frame) func_index() u32 {
	return C.wasm_frame_func_index(f.inner)
}

pub fn (f Frame) func_offset() usize {
	return C.wasm_frame_func_offset(f.inner)
}

pub fn (f Frame) instance() Instance {
	return Instance{C.wasm_frame_instance(f.inner)}
}

pub fn (f Frame) module_offset() usize {
	return C.wasm_frame_module_offset(f.inner)
}

pub struct Features {
	inner &C.wasmer_features_t
}

pub fn features() Features {
	return Features{C.wasmer_features_new()}
}

pub fn (mut f Features) module_linking(enable bool) bool {
	return C.wasmer_features_module_linking(f.inner, enable)
}

pub fn (mut f Features) bulk_memory(enable bool) bool {
	return C.wasmer_features_bulk_memory(f.inner, enable)
}

pub fn (mut f Features) tail_call(enable bool) bool {
	return C.wasmer_features_tail_call(f.inner, enable)
}

pub fn (mut f Features) memory64(enable bool) bool {
	return C.wasmer_features_memory64(f.inner, enable)
}

pub fn (mut f Features) multi_memory(enable bool) bool {
	return C.wasmer_features_multi_memory(f.inner, enable)
}

pub fn (mut f Features) multi_value(enable bool) bool {
	return C.wasmer_features_multi_value(f.inner, enable)
}

pub fn (mut f Features) simd(enable bool) bool {
	return C.wasmer_features_simd(f.inner, enable)
}

pub fn (mut f Features) threads(enable bool) bool {
	return C.wasmer_features_threads(f.inner, enable)
}

pub fn (mut f Features) reference_types(enable bool) bool {
	return C.wasmer_features_reference_types(f.inner, enable)
}

pub fn (e Extern) str() string {
	return 'Extern{}'
}

pub struct WasmPtr<T> {
	offset u32
}

pub fn wasm_ptr<T>(offset u32) WasmPtr<T> {
	return WasmPtr<T>{offset}
}

pub fn (p WasmPtr<T>) deref(memory &Memory) ?&T {
	end := p.offset + sizeof(T)
	if end > memory.size() || sizeof(T) == 0 {
		return none
	}

	ptr := memory.data() + p.offset
	return &T(ptr)
}

pub fn (p WasmPtr<T>) get_offset() u32 {
	return p.offset
}
