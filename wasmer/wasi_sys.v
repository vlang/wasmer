module wasmer

#flag -L $env('WASMER_DIR')/lib
#flag -lwasmer
#flag -I @VMODROOT
#flag -I $env('WASMER_DIR')/include
#flag -rpath $env('WASMER_DIR')/lib
#include "wasmer/include/wasmer.h"

pub enum WasiVersion {
	invalid
	latest
	snapshot0
	snapshot1
}

pub fn wasi_version_from_int(v int) WasiVersion {
	res := match v {
		-1 {
			WasiVersion.invalid
		}
		0 {
			WasiVersion.latest
		}
		1 {
			WasiVersion.snapshot0
		}
		2 {
			WasiVersion.snapshot1
		}
		else {
			WasiVersion.invalid
		}
	}

	return res
}

pub fn wasi_version_to_int(v WasiVersion) int {
	res := match v {
		.invalid {
			-1
		}
		.latest {
			0
		}
		.snapshot0 {
			1
		}
		.snapshot1 {
			2
		}
	}

	return res
}

pub struct C.wasi_config_t {}

pub struct C.wasi_env_t {}

pub struct C.wasmer_named_extern_t {}

pub struct C.wasmer_named_extern_vec_t {
pub mut:
	size usize
	data &&C.wasmer_named_extern_t = unsafe { 0 }
}

pub fn C.wasi_config_arg(config &C.wasi_config_t, arg &char)
pub fn C.wasi_config_capture_stderr(config &C.wasi_config_t)
pub fn C.wasi_config_capture_stdout(config &C.wasi_config_t)
pub fn C.wasi_config_env(config &C.wasi_config_t, key &char, value &char)
pub fn C.wasi_config_inherit_stderr(config &C.wasi_config_t)
pub fn C.wasi_config_inherit_stdin(config &C.wasi_config_t)
pub fn C.wasi_config_inherit_stdout(config &C.wasi_config_t)
pub fn C.wasi_config_mapdir(config &C.wasi_config_t, alias &char, dir &char)
pub fn C.wasi_config_new(program_name &char) &C.wasi_config_t
pub fn C.wasi_config_preopen_dir(config &C.wasi_config_t, dir &char)
pub fn C.wasi_env_delete(env &C.wasi_env_t)
pub fn C.wasi_env_new(store &C.wasm_store_t, config &C.wasi_config_t) &C.wasi_env_t
pub fn C.wasi_env_read_stderr(env &C.wasi_env_t, buf &byte, buf_len usize) isize
pub fn C.wasi_env_read_stdout(env &C.wasi_env_t, buf &byte, buf_len usize) isize
pub fn C.wasi_env_initialize_instance(env &C.wasi_env_t, store &C.wasm_store_t, instance &C.wasm_instance_t) bool
pub fn C.wasi_get_imports(store &C.wasm_store_t, wasi_env &C.wasi_env_t, mod &C.wasm_module_t, imports &C.wasm_extern_vec_t) bool
pub fn C.wasi_get_start_function(instance &C.wasm_instance_t) &C.wasm_func_t
pub fn C.wasi_get_unordered_imports(store &C.wasm_store_t, mod &C.wasm_module_t, wasi_env &C.wasi_env_t, imports &C.wasmer_named_extern_t) bool
pub fn C.wasi_get_wasi_version(mod &C.wasm_module_t) int

pub fn C.wasmer_named_extern_module(named_extern &C.wasmer_named_extern_t) &C.wasm_byte_vec_t
pub fn C.wasmer_named_extern_name(named_extern &C.wasmer_named_extern_t) &C.wasm_byte_vec_t
pub fn C.wasmer_named_extern_unwrap(named_extern &C.wasmer_named_extern_t) &C.wasm_extern_t
pub fn C.wasmer_named_extern_vec_copy(dst &C.wasmer_named_extern_vec_t, src &C.wasmer_named_extern_vec_t)
pub fn C.wasmer_named_extern_vec_delete(vec &C.wasmer_named_extern_vec_t)
pub fn C.wasmer_named_extern_vec_new(out &C.wasmer_named_extern_vec_t, len usize, init &&C.wasmer_named_extern_t)
pub fn C.wasmer_named_extern_vec_new_empty(out &C.wasmer_named_extern_vec_t)
pub fn C.wasmer_named_extern_vec_new_uninitialized(out &C.wasmer_named_extern_vec_t, len usize)
