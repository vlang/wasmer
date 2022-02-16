# wasmer
`wasmer` is a wrapper over Wasmer C API. This module not only provides access to the C API but it also strives to provide easy to use wrappers over the C API.

# Example usage

```v
import wasmer

fn main() {
    engine := wasmer.engine()
    store := wasmer.store(engine)

    wasm := wasmer.wat2wasm('(module
        (func \$add (param \$lhs i32) (param \$rhs i32) (result i32)
            local.get \$lhs
            local.get \$rhs
            i32.add)
        (export "add" (func \$add))
    
    )')?

    mod := wasmer.compile(store,wasm)?
    imports := wasmer.extern_vec_empty()
    mut trap := wasmer.Trap{}
    instance := wasmer.instance(store,mod,imports,mut trap)

    func := instance.exports().at(0).as_func()?
    mut results := [wasmer.val_i32(0)]
    trap = func.call([wasmer.val_i32(2),wasmer.val_i32(3)],mut results)
    if trap.is_set() {
        println(trap.message()?)
    } else {
        println(results[0])
    }

    engine.delete()
    trap.delete()
    store.delete()
}

```