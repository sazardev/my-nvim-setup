# Dart / Flutter

Filetype: `dart`.

## Herramientas

| Qué | Con |
|---|---|
| LSP | `dartls`, gestionado por **flutter-tools.nvim** (no por `vim.lsp.enable`) |
| Formato (al guardar y `<leader>fm`) | `dart_format` |
| Treesitter | `dart` |
| Snippets | los de Flutter de friendly-snippets (el language id `flutter` se pide explícito para filetype `dart`) |

## Menú `<leader>d` (solo en `*.dart`)

| Tecla | Acción |
|---|---|
| `dr` | `FlutterRun` |
| `dd` | `FlutterDebug` |
| `dh` | hot reload |
| `dR` | hot restart |
| `dq` | cerrar la app |
| `dD` | dispositivos |
| `de` | emuladores |
| `do` | outline de widgets |
| `dl` | alternar el log |
| `dt` | DevTools |
| `dp` | `pub get` |
| `dm` | test (`flutter test` o `dart test` según el proyecto) |
| `dv` | analyze |
| `dx` | `dart fix --apply` |
| `df` | formatear |

Necesita `pubspec.yaml`: detecta si es Flutter (bloque `flutter:`) o Dart puro y usa el comando correcto.

## Útiles generales aquí

| Tecla | Acción |
|---|---|
| `daf` / `dif` | borrar método entero / su cuerpo |
| `dac` | borrar clase completa |
| `]f` / `[f` | siguiente / anterior método |
| `gd` / `grr` | definición / dónde se usa |
| `<leader>ca` | code actions (envolver en widget, extraer, etc.) |
