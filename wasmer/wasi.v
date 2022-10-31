module wasmer

pub fn (m &Module) wasi_version() WasiVersion {
	return wasi_version_from_int(C.wasi_get_wasi_version(m.inner))
}

pub struct WasiConfig {
pub:
	config &C.wasi_config_t
}

pub fn (c WasiConfig) arg(arg string) {
	C.wasi_config_arg(c.config, arg.str)
}

pub fn (c WasiConfig) capture_stderr() {
	C.wasi_config_capture_stderr(c.config)
}

pub fn (c WasiConfig) capture_stdout() {
	C.wasi_config_capture_stdout(c.config)
}

pub fn (c WasiConfig) env(key string, value string) {
	C.wasi_config_env(c.config, key.str, value.str)
}

pub fn (c WasiConfig) inherit_stdin() {
	C.wasi_config_inherit_stdin(c.config)
}

pub fn (c WasiConfig) inherit_stdout() {
	C.wasi_config_inherit_stdout(c.config)
}

pub fn (c WasiConfig) inherit_stderr() {
	C.wasi_config_inherit_stderr(c.config)
}

pub fn (c WasiConfig) mapdir(host_dir string, guest_dir string) {
	C.wasi_config_mapdir(c.config, host_dir.str, guest_dir.str)
}

pub fn (c WasiConfig) preopen_dir(dir string) {
	C.wasi_config_preopen_dir(c.config, dir.str)
}

pub fn wasi_config(program_name string) WasiConfig {
	return WasiConfig{
		config: C.wasi_config_new(program_name.str)
	}
}

struct NamedExternVec {
mut:
	inner C.wasmer_named_extern_vec_t
}

pub struct NamedExtern {
mut:
	inner &C.wasmer_named_extern_t
}

fn named_extern_vec(x []NamedExtern) NamedExternVec {
	mut b := C.wasmer_named_extern_vec_t{}
	C.wasmer_named_extern_vec_new(&b, usize(x.len), x.data)
	return NamedExternVec{b}
}

fn (v NamedExternVec) at(i int) NamedExtern {
	unsafe {
		return NamedExtern{v.inner.data[i]}
	}
}

fn (v NamedExternVec) set_at(i int, val NamedExtern) {
	unsafe {
		v.inner.data[i] = val.inner
	}
}

fn (v NamedExternVec) delete() {
	C.wasmer_named_extern_vec_delete(&v.inner)
}

fn (v NamedExternVec) copy() NamedExternVec {
	mut new := NamedExternVec{}
	C.wasmer_named_extern_vec_copy(&v.inner, &new.inner)
	return new
}

pub struct WasiEnv {
pub:
	env &C.wasi_env_t
}

pub fn wasi_env(store Store, config WasiConfig) ?WasiEnv {
	p := C.wasi_env_new(store.inner, config.config)

	if p == unsafe { nil } {
		return none
	}
	return WasiEnv{
		env: p
	}
}

/// Reads the stderr of the WASI process into `buf`. Returns
/// number of bytes successfully read, returns -1 if read failed
pub fn (c WasiEnv) read_stderr(mut buf []u8) isize {
	return C.wasi_env_read_stderr(c.env, buf.data, buf.len)
}

/// Reads the stdout of the WASI process into `buf`. Returns
/// number of bytes successfully read, returns -1 if read failed
pub fn (c WasiEnv) read_stdout(mut buf []u8) isize {
	return C.wasi_env_read_stdout(c.env, buf.data, buf.len)
}

pub fn (c WasiEnv) initialize_instance(store Store, instance Instance) ! {
	if !C.wasi_env_initialize_instance(c.env, store.inner, instance.inner) {
		return error('Failed to initialize WASI instance')
	}
}

pub fn (c WasiEnv) delete() {
	C.wasi_env_delete(c.env)
}

pub fn (s Store) get_imports(mod &Module, env WasiEnv) ?[]Extern {
	mut raw := ExternVec{}

	result := C.wasi_get_imports(s.inner, env.env, mod.inner, &raw.inner)
	if !result {
		return none
	}

	mut result_vec := []Extern{}

	for i in 0 .. raw.inner.size {
		result_vec << raw.at(int(i))
	}
	return result_vec
}

pub fn (i Instance) get_start_function() ?Func {
	f := C.wasi_get_start_function(i.inner)
	if f == unsafe { nil } {
		return none
	}
	return Func{f}
}

pub fn (n NamedExtern) mod() string {
	bvec := C.wasmer_named_extern_module(n.inner)
	return unsafe {
		bvec.data.vbytes(int(bvec.size)).bytestr()
	}
}

pub fn (n NamedExtern) name() string {
	bvec := C.wasmer_named_extern_name(n.inner)
	return unsafe {
		bvec.data.vbytes(int(bvec.size)).bytestr()
	}
}

pub fn (n NamedExtern) unwrap() Extern {
	return Extern{C.wasmer_named_extern_unwrap(n.inner)}
}
