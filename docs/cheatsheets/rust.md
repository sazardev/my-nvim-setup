# Rust

Filetype: `rust`.

## Herramientas

| Qué | Con |
|---|---|
| Treesitter | `rust` |
| LSP / formatter / linter | **no hay declarados** en el registro; el formato y clippy corren con `cargo` desde el menú |

> Para rust-analyzer o formato al guardar, añádelo en `lua/languages/rust.lua` (`lsp`, `mason`, `formatters`).

## Menú `<leader>r` (solo en `*.rs`)

Corre en la raíz del proyecto (donde está `Cargo.toml`) y avisa si `cargo` no está instalado.

| Tecla | Acción |
|---|---|
| `rr` | `cargo run` |
| `rb` | `cargo build` |
| `rm` | `cargo test` |
| `rc` | `cargo check` |
| `rv` | `cargo clippy` |
| `rx` | `cargo clippy --fix --allow-dirty` |
| `rf` | `cargo fmt` |

## Útiles generales aquí

| Tecla | Acción |
|---|---|
| `daf` / `dif` | borrar `fn` entera / su cuerpo |
| `dac` | borrar `struct`/`impl` completo |
| `]f` / `[f` | siguiente / anterior función |
| `di{` / `da{` | interior / bloque `{}` completo |
