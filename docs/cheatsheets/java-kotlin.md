# Java y Kotlin

Filetypes: `java`, `kotlin`. Comparten las mismas acciones (Gradle o Maven).

## Herramientas

| Qué | Con |
|---|---|
| Treesitter | `java`, `kotlin` |
| LSP / formatter / linter | **no hay declarados** en el registro; los menús corren las tareas de build |

> Para jdtls / kotlin-language-server, añádelos en `lua/languages/java.lua` y `kotlin.lua` (`lsp`, `mason`).

## Menús: `<leader>j` (Java) y `<leader>k` (Kotlin)

Detecta el proyecto por `gradlew`, `build.gradle(.kts)`, `settings.gradle(.kts)` o `pom.xml`.
Usa los wrappers (`./gradlew`, `./mvnw`) si existen; si no, `gradle` / `mvn`.

| Tecla (Java / Kotlin) | Gradle | Maven |
|---|---|---|
| `jr` / `kr` run | `run` | `spring-boot:run` si el `pom` usa Spring Boot; si no `compile exec:java` |
| `jb` / `kb` build | `build` | `package` |
| `jm` / `km` test | `test` | `test` |
| `jv` / `kv` check / verify | `check` | `verify` |
| `jc` / `kc` clean | `clean` | `clean` |

Si no hay proyecto Gradle/Maven, avisa en vez de fallar.

## Útiles generales aquí

| Tecla | Acción |
|---|---|
| `daf` / `dif` | borrar método entero / su cuerpo |
| `dac` | borrar clase completa |
| `]f` / `[f` | siguiente / anterior método |
| `di{` / `da{` | interior / bloque `{}` completo |
