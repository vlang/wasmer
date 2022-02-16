module wasmer

#flag -L $env('WASMER_DIR')/lib
#flag -lwasmer
#flag -I @VMODROOT
#flag -rpath $env('WASMER_DIR')/lib
#include "wasmer/include/wasm.h"
#include "wasmer/include/wasmer_wasm.h"
#include "wasmer/include/wasmer.h"

struct C.wasm_engine_t {}

struct C.wasm_config_t {}

struct C.wasmer_features_t {}

struct C.wasm_instance_t {}

struct C.wasm_store_t {}

struct C.wasm_byte_vec_t {
pub mut:
	size usize
	data &u8 = 0
}

struct C.wasm_exporttype_t {}

struct C.wasm_exporttype_vec_t {
pub mut:
	size usize
	data &&C.wasm_export_type_t = 0
}

struct C.wasm_externtype_t {}

struct C.wasm_externtype_vec_t {
pub mut:
	size usize
	data &&C.wasm_externtype_t = 0
}

struct C.wasm_frame_t {}

struct C.wasm_frame_vec_t {
pub mut:
	size usize
	data &&C.wasm_frame_t = 0
}

struct C.wasm_functype_t {}

struct C.wasm_functype_vec_t {
pub mut:
	size usize
	data &&C.wasm_functype_t = 0
}

struct C.wasm_globaltype_t {}

struct C.wasm_globaltype_vec_t {
pub mut:
	size usize
	data &&C.wasm_globaltype_vec_t = 0
}

struct C.wasm_importtype_t {}

struct C.wasm_importtype_vec_t {
pub mut:
	size usize
	data &&C.wasm_importtype_vec_t = 0
}

struct C.wasm_limits_t {}

struct C.wasm_memorytype_t {}

struct C.wasm_memorytype_t_vec {
pub mut:
	size usize
	data &&C.wasm_memorytype_t = 0
}

struct C.wasm_ref_t {}

struct C.wasm_tabletype_t {}

struct C.wasm_tabletype_vec_t {
pub mut:
	size usize
	data &&C.wasm_tabletype_t = 0
}

pub struct C.wasm_valtype_t {}

struct C.wasm_valtype_vec_t {
pub mut:
	size usize
	data &&C.wasm_valtype_t = 0
}

pub enum WasmerCompiler {
	cranelift = 0
	llvm
	singlepass
}

pub enum WasmerEngine {
	universal = 0
	dylib
	staticlib
}

pub enum WasmValKind {
	wasm_i32 = 0
	wasm_i64
	wasm_f32
	wasm_f64
	wasm_anyref
	wasm_funcref
}

fn C.wasm_config_delete(config &C.wasm_config_t)
fn C.wasm_config_new() &C.wasm_config_t
fn C.wasm_config_set_compiler(config &C.wasm_config_t, compiler WasmerCompiler)
fn C.wasm_config_set_engine(config &C.wasm_config_t, engine WasmerEngine)
fn C.wasm_config_set_features(config &C.wasm_config_t, features &C.wasmer_features_t)
fn C.wasm_engine_new() &C.wasm_engine_t
fn C.wasm_engine_new_with_config(config &C.wasm_config_t) &C.wasm_engine_t
fn C.wasm_engine_delete(engien &C.wasm_engine_t)
fn C.wasmer_is_compiler_available(compiler WasmerCompiler) bool
fn C.wasmer_features_new() &C.wasmer_features_t
fn C.wasmer_features_bulk_memory(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_delete(f &C.wasmer_features_t)
fn C.wasmer_features_memory64(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_module_linking(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_multi_memory(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_multi_value(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_tail_call(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_simd(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_threads(f &C.wasmer_features_t, enable bool) bool
fn C.wasmer_features_reference_types(f &C.wasmer_features_t, enable bool) bool
fn C.wasm_store_new(&C.wasm_engine_t) &C.wasm_store_t
fn C.wasm_store_delete(&C.wasm_store_t)

fn C.wasm_byte_vec_new(out &C.wasm_byte_vec_t, size usize, ptr &u8)
fn C.wasm_byte_vec_delete(out &C.wasm_byte_vec_t)
fn C.wasm_byte_vec_new_empty(out &C.wasm_byte_vec_t)
fn C.wasm_byte_vec_new_uninitialized(out &C.wasm_byte_vec_t, size usize)
fn C.wasm_byte_vec_copy(out &C.wasm_byte_vec_t, src &C.wasm_byte_vec_t)

fn C.wasm_exporttype_vec_new(out &C.wasm_exporttype_vec_t, size usize, ptr &&C.wasm_exporttype_t)
fn C.wasm_exporttype_vec_delete(out &C.wasm_exporttype_vec_t)
fn C.wasm_exporttype_vec_new_empty(out &C.wasm_exporttype_vec_t)
fn C.wasm_exporttype_vec_new_uninitialized(out &C.wasm_exporttype_vec_t, size usize)
fn C.wasm_exporttype_vec_copy(out &C.wasm_exporttype_vec_t, src &C.wasm_exporttype_vec_t)

fn C.wasm_externtype_vec_new(out &C.wasm_externtype_vec_t, size usize, ptr &&C.wasm_externtype_t)
fn C.wasm_externtype_vec_delete(out &C.wasm_externtype_vec_t)
fn C.wasm_externtype_vec_new_empty(out &C.wasm_externtype_vec_t)
fn C.wasm_externtype_vec_new_uninitialized(out &C.wasm_externtype_vec_t, size usize)
fn C.wasm_externtype_vec_copy(out &C.wasm_externtype_vec_t, src &C.wasm_externtype_vec_t)

fn C.wasm_functype_vec_new(out &C.wasm_functype_vec_t, size usize, ptr &&C.wasm_functype_t)
fn C.wasm_functype_vec_delete(out &C.wasm_functype_vec_t)
fn C.wasm_functype_vec_new_empty(out &C.wasm_functype_vec_t)
fn C.wasm_functype_vec_new_uninitialized(out &C.wasm_functype_vec_t, size usize)
fn C.wasm_functype_vec_copy(out &C.wasm_functype_vec_t, src &C.wasm_functype_vec_t)

fn C.wasm_globaltype_vec_new(out &C.wasm_globaltype_vec_t, size usize, ptr &&C.wasm_globaltype_t)
fn C.wasm_globaltype_vec_delete(out &C.wasm_globaltype_vec_t)
fn C.wasm_globaltype_vec_new_empty(out &C.wasm_globaltype_vec_t)
fn C.wasm_globaltype_vec_new_uninitialized(out &C.wasm_globaltype_vec_t, size usize)
fn C.wasm_globaltype_vec_copy(out &C.wasm_globaltype_vec_t, src &C.wasm_globaltype_vec_t)

fn C.wasm_importtype_vec_new(out &C.wasm_importtype_vec_t, size usize, ptr &&C.wasm_importtype_t)
fn C.wasm_importtype_vec_delete(out &C.wasm_importtype_vec_t)
fn C.wasm_importtype_vec_new_empty(out &C.wasm_importtype_vec_t)
fn C.wasm_importtype_vec_new_uninitialized(out &C.wasm_importtype_vec_t, size usize)
fn C.wasm_importtype_vec_copy(out &C.wasm_importtype_vec_t, src &C.wasm_importtype_vec_t)

fn C.wasm_memorytype_vec_new(out &C.wasm_memorytype_vec_t, size usize, ptr &&C.wasm_memorytype_t)
fn C.wasm_memorytype_vec_delete(out &C.wasm_memorytype_vec_t)
fn C.wasm_memorytype_vec_new_empty(out &C.wasm_memorytype_vec_t)
fn C.wasm_memorytype_vec_new_uninitialized(out &C.wasm_memorytype_vec_t, size usize)
fn C.wasm_memorytype_vec_copy(out &C.wasm_memorytype_vec_t, src &C.wasm_memorytype_vec_t)

fn C.wasm_tabletype_vec_new(out &C.wasm_tabletype_vec_t, size usize, ptr &&C.wasm_tabletype_t)
fn C.wasm_tabletype_vec_delete(out &C.wasm_tabletype_vec_t)
fn C.wasm_tabletype_vec_new_empty(out &C.wasm_tabletype_vec_t)
fn C.wasm_tabletype_vec_new_uninitialized(out &C.wasm_tabletype_vec_t, size usize)
fn C.wasm_tabletype_vec_copy(out &C.wasm_tabletype_vec_t, src &C.wasm_tabletype_vec_t)

fn C.wasm_valtype_vec_new(out &C.wasm_valtype_vec_t, size usize, ptr &&C.wasm_valtype_t)
fn C.wasm_valtype_vec_delete(out &C.wasm_valtype_vec_t)
fn C.wasm_valtype_vec_new_empty(out &C.wasm_valtype_vec_t)
fn C.wasm_valtype_vec_new_uninitialized(out &C.wasm_valtype_vec_t, size usize)
fn C.wasm_valtype_vec_copy(out &C.wasm_valtype_vec_t, src &C.wasm_valtype_vec_t)

fn C.wasm_valtype_new(kind WasmValKind) &C.wasm_valtype_t
fn C.wasm_valtype_kind(valtype &C.wasm_valtype_t) WasmValKind

struct C.wasm_trap_t {}

fn C.wasm_trap_new(store &C.wasm_store_t, message &C.wasm_byte_vec_t) C.wasm_trap
fn C.wasm_trap_delete(trap &C.wasm_trap_t)
fn C.wasm_trap_origin(trap &C.wasm_trap_t) &C.wasm_frame_t
fn C.wasm_trap_message(trap &C.wasm_trap_t, out &C.wasm_byte_vec_t)
fn C.wasm_trap_trace(trap &C.wasm_trap_t, out &C.wasm_frame_vec_t)

pub struct C.wasm_val_t {
pub mut:
	kind WasmValKind
	of   C.wasm_val_inner
}

pub struct C.wasm_val_vec_t {
pub mut:
	size usize
	data &C.wasm_val_t = 0
}

pub union C.wasm_val_inner {
pub mut:
	i32 int
	i64 i64
	f64 f64
	f32 f32
	ref &C.wasm_ref_t = 0
}

pub fn wasm_i32_val(x int) C.wasm_val_t {
	mut val := C.wasm_val_t{}
	val.of.i32 = x
	val.kind = .wasm_i32
	return val
}

pub fn wasm_i64_val(x i64) C.wasm_val_t {
	mut val := C.wasm_val_t{}
	val.of.i64 = x
	val.kind = .wasm_i64
	return val
}

pub fn wasm_f32_val(x f32) C.wasm_val_t {
	mut val := C.wasm_val_t{}
	val.of.f32 = x
	val.kind = .wasm_f32
	return val
}

pub fn wasm_f64_val(x f64) C.wasm_val_t {
	mut val := C.wasm_val_t{}
	val.of.f64 = x
	val.kind = .wasm_f64
	return val
}

pub fn wasm_ref_val(x &C.wasm_ref_t) C.wasm_val_t {
	mut val := C.wasm_val_t{}
	unsafe {
		val.of.ref = x
	}
	val.kind = .wasm_anyref
	return val
}

pub fn wasm_init_val() C.wasm_val_t {
	mut val := C.wasm_val_t{}
	unsafe {
		val.of.ref = &C.wasm_ref_t(0)
	}
	val.kind = .wasm_anyref
	return val
}

fn C.wasm_val_vec_new(out &C.wasm_val_vec_t, size usize, ptr &C.wasm_val_t)
fn C.wasm_val_vec_delete(out &C.wasm_val_vec_t)
fn C.wasm_val_vec_new_empty(out &C.wasm_val_vec_t)
fn C.wasm_val_vec_new_uninitialized(out &C.wasm_val_vec_t, size usize)
fn C.wasm_val_vec_copy(out &C.wasm_val_vec_t, src &C.wasm_val_vec_t)

struct C.wasm_module_t {}

fn C.wasm_module_new(store &C.wasm_store_t, bytes &C.wasm_byte_vec_t) &C.wasm_module_t
fn C.wasm_module_delete(mod &C.wasm_module_t)
fn C.wasm_module_imports(mod &C.wasm_module_t, out &C.wasm_importtype_vec_t)
fn C.wasm_module_exports(mod &C.wasm_module_t, out &C.wasm_exporttype_vec_t)
fn C.wasm_module_serialize(mod &C.wasm_module_t, out &C.wasm_byte_vec_t)
fn C.wasm_module_deserialize(store &C.wasm_store_t, bytes &C.wasm_byte_vec_t) &C.wasm_module_t

struct C.wasm_extern_t {}

struct C.wasm_extern_vec_t {
pub mut:
	size usize
	data &&C.wasm_extern_t = 0
}

fn C.wasm_extern_vec_new(out &C.wasm_extern_vec_t, size usize, ptr &C.wasm_extern_t)
fn C.wasm_extern_vec_delete(out &C.wasm_extern_vec_t)
fn C.wasm_extern_vec_new_empty(out &C.wasm_extern_vec_t)
fn C.wasm_extern_vec_new_uninitialized(out &C.wasm_extern_vec_t, size usize)
fn C.wasm_extern_vec_copy(out &C.wasm_extern_vec_t, src &C.wasm_extern_vec_t)

struct C.wasm_func_t {}

struct C.wasm_global_t {}

struct C.wasm_memory_t {}

struct C.wasm_table_t {}

pub type CWasmFuncCallback = fn (args &C.wasm_val_vec_t, mut results C.wasm_val_vec_t) &C.wasm_trap_t

pub type CWasmFuncCallbackWithEnv = fn (env voidptr, args &C.wasm_val_vec_t, mut results C.wasm_val_vec_t) &C.wasm_trap_t

fn C.wasm_extern_as_func(extern &C.wasm_extern_t) &C.wasm_func_t
fn C.wasm_extern_as_global(extern &C.wasm_extern_t) &C.wasm_global_t
fn C.wasm_extern_as_memory(extern &C.wasm_extern_t) &C.wasm_memory_t
fn C.wasm_extern_as_table(extern &C.wasm_extern_t) &C.wasm_table_t
fn C.wasm_func_as_extern(f &C.wasm_func_t) &C.wasm_extern_t
fn C.wasm_global_as_extern(g &C.wasm_global_t) &C.wasm_extern_t
fn C.wasm_memory_as_extern(m &C.wasm_memory_t) &C.wasm_extern_t
fn C.wasm_table_as_extern(t &C.wasm_table_t) &C.wasm_extern_t
fn C.wasm_func_call(func &C.wasm_func_t, args &C.wasm_val_vec_t, results &C.wasm_val_vec_t) &C.wasm_trap_t
fn C.wasm_func_copy(func &C.wasm_func) &C.wasm_func
fn C.wasm_func_delete(func &C.wasm_func_t)
fn C.wasm_func_new(store &C.wasm_store_t, ftype &C.wasm_functype_t, callback CWasmFuncCallback) &C.wasm_func_t
fn C.wasm_func_new_with_env(store &C.wasm_store_t, ftype &C.wasm_functype_t, callback CWasmFuncCallback, env voidptr, env_finalizer fn (voidptr)) &C.wasm_func_t
fn C.wasm_func_param_arity(func &C.wasm_func_t) usize
fn C.wasm_func_result_arity(func &C.wasm_func_t) usize
fn C.wasm_func_type(func &C.wasm_func_t) &C.wasm_functype_t

fn C.wasm_global_copy(g &C.wasm_global_t) &C.wasm_global_t
fn C.wasm_global_delete(g &C.wasm_global_t)
fn C.wasm_global_get(g &C.wasm_global_t, out &C.wasm_val_t)
fn C.wasm_global_new(store &C.wasm_store_t, global_type &C.wasm_globaltype_t, val &C.wasm_val_t) &C.wasm_global_t
fn C.wasm_global_set(g &C.wasm_global_t, val &C.wasm_val_t)
fn C.wasm_global_same(x &C.wasm_global_t, y C.wasm_val_t) bool
fn C.wasm_global_type(g &C.wasm_global_t) &C.wasm_globaltype_t

fn C.wasm_memory_copy(m &C.wasm_memory_t) &C.wasm_memory_t
fn C.wasm_memory_delete(m &C.wasm_memory_t)
fn C.wasm_memory_data(m &C.wasm_memory_t) voidptr
fn C.wasm_memory_data_size(m &C.wasm_memory_t) usize
fn C.wasm_memory_grow(m &C.wasm_memory_t, delta u32) bool
fn C.wasm_memory_new(store &C.wasm_store_t, memory_type &C.wasm_memorytype_t) &C.wasm_memory_t
fn C.wasm_memory_same(x &C.wasm_memory_t, y &C.wasm_memory_t) bool
fn C.wasm_memory_size(m &C.wasm_memory_t) u32
fn C.wasm_memory_type(m &C.wasm_memory_t) &C.wasm_memorytype_t

fn C.wasm_table_copy(g &C.wasm_table_t) &C.wasm_table_t
fn C.wasm_table_delete(g &C.wasm_table_t)
fn C.wasm_table_grow(t &C.wasm_table_t, delta u32, init &C.wasm_ref_t) bool
fn C.wasm_table_new(t &C.wasm_store_t, table_type &C.wasm_tabletype_t, init &C.wasm_ref_t) &C.wasm_table_t
fn C.wasm_table_same(x &C.wasm_table_t, y &C.wasm_table_t) bool
fn C.wasm_table_size(t &C.wasm_table_t) usize

fn C.wasm_instance_new(store &C.wasm_store_t, mod &C.wasm_module_t, imports &C.wasm_extern_vec_t, trap &&C.wasm_trap_t) &C.wasm_instance_new
fn C.wasm_instance_exports(instance &C.wasm_instance_t, out &C.wasm_extern_vec_t)
fn C.wasm_instance_delete(instance &C.wasm_instance_t)

fn C.wat2wasm(wat &C.wasm_byte_vec_t, out &C.wasm_byte_vec_t)

fn C.wasmer_last_error_length() int
fn C.wasmer_last_error_message(buffer voidptr, length int) int

fn C.wasm_functype_new(params &C.wasm_valtype_vec_t, results &C.wasm_valtype_vec_t) &C.wasm_functype_t
fn C.wasm_functype_params(f &C.wasm_functype_t) &C.wasm_valtype_vec_t
fn C.wasm_functype_result(f &C.wasm_functype_t) &C.wasm_valtype_vec_t
fn C.wasm_functype_copy(f &C.wasm_functype_t) &C.wasm_functype_t
fn C.wasm_functype_delete(f &C.wasm_functype_t)
fn C.wasm_functype_as_externtype(f &C.wasm_functype_t) &C.wasm_externtype_t
