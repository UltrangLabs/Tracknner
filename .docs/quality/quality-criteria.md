# Criterios de Calidad de Código para Flutter & Dart 🟦

## Base

### Objetivos Principales

- **Seguridad nula (Null Safety):** El código debe aprovechar al máximo el sistema de tipos de Dart. No deben existir errores de tipo `NullPointerException` en tiempo de ejecución.
- **Rendimiento (60/120 FPS):** La interfaz de usuario no debe bloquearse. Las operaciones pesadas deben moverse a _Isolates_ o manejarse de forma asíncrona, y se debe maximizar el uso de constructores `const`.

### Nomenclatura

- **camelCase:** Los nombres de variables, parámetros, propiedades y métodos comienzan con minúscula y usan notación `lowerCamelCase` (`non_constant_identifier_names`).
- **Constantes en camelCase:** A diferencia de otros lenguajes, en Dart las constantes **no** usan mayúsculas. Deben escribirse en `lowerCamelCase` (ej. `const maxRetries = 3;`).
- **Inglés:** Se utilizan sustantivos en inglés para variables y propiedades.
- **Sin tipo de dato en el nombre:** No incluir el tipo de dato en el nombre de la variable (ej. usar `user` en lugar de `userMap` o `userList`).
- **Plurales para colecciones:** Los `List`, `Set` o `Map` deben nombrarse con sustantivos en plural (ej. `users`).
- **Booleanos:** Las variables booleanas deben comenzar con prefijos de afirmación (ej. `isLoggedIn`, `hasFriends`, `canUpdate`).
- **Clases y Enums:** Se nombran utilizando `PascalCase` (`camel_case_types`). Si incluyen acrónimos, solo la primera letra va en mayúscula (ej. `HttpService`, no `HTTPService`).
- **Valores de Enums:** Los valores dentro de un enum deben escribirse en `lowerCamelCase` (ej. `enum UserRole { admin, guest }`).
- **Archivos y Carpetas:** Se utiliza **estrictamente `snake_case`** (letras minúsculas separadas por guiones bajos) para todos los archivos `.dart` e imágenes (ej. `user_profile_screen.dart`, no `UserProfile.dart`).
- **Modificadores de Acceso (Privacidad):** En Dart no existen `private` o `public`. Para hacer que una variable, clase o método sea privado para su archivo, se debe anteponer un guion bajo `_` (ej. `_calculateTotal()`, `class _CustomButton`).

**Ejemplos de Nomenclatura:**

```dart
// ❌ Mal
const MAX_RETRIES = 3; // En Dart no se usa UPPER_SNAKE_CASE
List<User> userList = [];
class HTTPRequest {}
enum Status { ACTIVE, INACTIVE } // Valores en mayúsculas
// Archivo: UserProfile.dart

// ✅ Bien
const maxRetries = 3;
List<User> users = [];
class HttpRequest {}
enum Status { active, inactive }
// Archivo: user_profile.dart
```

### Formato, Imports y Estructura

- **Linter Oficial:** El proyecto debe usar `flutter_lints` configurado en el archivo `analysis_options.yaml`. No debe haber advertencias (warnings) ni infos en el editor (`dart analyze --fatal-infos --fatal-warnings`).
- **La coma final (Trailing Comma):** Todo constructor, función o colección multilínea debe terminar con una coma `,` final antes del cierre (`require_trailing_commas: true`). Esto fuerza al formateador a colocar los parámetros en cascada limpia de múltiples líneas.
- **Importaciones Relativas y Ordenadas:** Dentro de `lib/`, se prefieren importaciones relativas (`prefer_relative_imports: true`) y ordenadas alfabéticamente por categorías (`directives_ordering: true`: Dart SDK -> Packages externos -> Rutas relativas del proyecto).
- **Control de Flujo con Llaves:** Siempre usar llaves `{}` en todas las estructuras de control (`if`, `else`, `for`, `while`), incluso en sentencias de una sola línea (`curly_braces_in_flow_control_structures: true`).
- **Sin valores mágicos:** No se deben utilizar strings, colores o números quemados directamente en la UI. Deben extraerse a constantes o manejarse mediante el `Theme` de la aplicación.

**Ejemplos de Formato:**

```dart
// ❌ Mal (Sin comas finales, sin llaves)
if (isValid) return;

Column(children: [Text('Hola'), Icon(Icons.add)])

// ✅ Bien (Con comas finales, llaves siempre presentes)
if (isValid) {
  return;
}

Column(
  children: [
    const Text('Hola'),
    const Icon(Icons.add),
  ],
)
```

### Constructores y Clases

- **Inicialización Formal en Constructores:** Inicializar los campos directamente en los parámetros formales (`this.campo` o `this._campo`) en vez de asignarlos en el cuerpo del constructor (`prefer_initializing_formals: true`).
- **Orden de Constructores:** El constructor principal sin nombre debe ubicarse siempre antes que los constructores nombrados (`sort_unnamed_constructors_first: true`, ej. `MyClass(...)` antes de `MyClass.fromJson(...)`).
- **Evitar clases de solo estáticos:** En Dart está desaconsejado crear clases contenedoras puramente estáticas (`avoid_classes_with_only_static_members: true`). Se prefieren funciones top-level, extensiones o constantes según corresponda.
- **Prohibido `print()`:** Prohibido el uso de `print()` en producción (`avoid_print: true`). Utilizar el logger configurado o adaptadores del sistema.

### Criterios Específicos de Flutter (Arquitectura UI)

- **Uso exhaustivo de const:** Cualquier Widget u objeto inmutable debe instanciarse con `const` (`prefer_const_constructors: error`, `prefer_const_declarations: error`).
- **Widgets en Clases, no en Métodos:** Si un árbol de Widgets crece demasiado, debe extraerse en una nueva clase `StatelessWidget`. Está prohibido extraer Widgets complejos en métodos que retornen `Widget` (ej. `Widget _buildHeader() { ... }`).
- **Controladores y Memoria:** Todo Widget que instancie un objeto que maneje hardware o escuchas (`TextEditingController`, `FocusNode`, `ScrollController`, `AnimationController`) debe ser un `StatefulWidget` para destruirlos explícitamente en el método `dispose()` con `super.dispose()` al final.
- **Instanciación en build:** Nunca se deben instanciar controladores, streams o configuraciones estáticas que no dependan del `BuildContext` dentro de `build()`.

## Avanzado

### Sintaxis y Modernidad

- **Null-aware operators:** Se debe preferir el uso de sintaxis moderna (`?.`, `??`, `??=`) para manejar nulos en lugar de bloques `if` extensos.
- **Tipado Fuerte y Prohibido `dynamic`:** El tipo `dynamic` está estrictamente prohibido (`avoid_dynamic_calls: error`), con tipado estricto habilitado (`strict-casts`, `strict-inference`, `strict-raw-types`). Si un tipo es desconocido, usar `Unknown` o `Object?` con validación explícita.
- **Retornos Explícitos:** Toda función, método y getter debe declarar explícitamente su tipo de retorno (`always_declare_return_types: error`, ej. `Future<void>`, `int`, `Widget`).
- **Inmutabilidad de Variables:** Siempre usar `final` para variables locales y bucles en lugar de variables reasignables innecesarias (`prefer_final_locals: true`, `prefer_final_in_for_each: true`).
- **Abstracciones:** Para crear interfaces o contratos, se debe utilizar `abstract class` o `abstract interface class`.

**Ejemplos de Sintaxis:**

```dart
// ❌ Mal
String cityName = 'Unknown';
if (user != null && user.address != null) {
  cityName = user.address.city;
}

// ✅ Bien
final cityName = user?.address?.city ?? 'Unknown';
```

### Redundancia y Modularidad

- **Operador ternario:** Cuando sea posible y no se aniden, se debe usar el operador ternario o `if` collection en lugar de bloques `if/else` tradicionales.
- **Condicionales en UI (if collection):** Dart permite usar `if` directamente dentro de listas (como `children`). Se debe preferir esto antes que usar ternarios que devuelvan `SizedBox.shrink()` o nulos.

**Ejemplos de Redundancia en UI:**

```dart
// ❌ Mal (Ternario devolviendo un widget vacío)
Column(
  children: [
    isAdmin ? AdminPanel() : SizedBox.shrink(),
  ],
)

// ✅ Bien (Colección If nativa de Dart)
Column(
  children: [
    if (isAdmin) const AdminPanel(),
  ],
)
```

### Iteraciones y Funciones

- **Iteradores Funcionales:** Para transformaciones de colecciones, se deben utilizar métodos como `.map()`, `.where()` y `.fold()` en lugar de bucles `for` clásicos.
- **Comprobación de Colecciones:** Usar getters nativos `isEmpty` e `isNotEmpty` (`prefer_is_empty`, `prefer_is_not_empty`) y filtros tipados (`prefer_iterable_whereType`).
- **Métodos en cascada (..):** Aprovechar el operador de cascada de Dart para configurar múltiples propiedades de un mismo objeto sin repetir su nombre.

```dart
// ✅ Bien (Uso del operador en cascada)
final paint = Paint()
  ..color = Colors.black
  ..strokeWidth = 5.0
  ..style = PaintingStyle.stroke;
```

### Firmas y Parámetros de Métodos y Funciones

Para garantizar la legibilidad del código, evitar confusiones en los sitios de llamada y prevenir errores humanos al ordenar variables, las firmas de funciones y métodos deben adherirse estrictamente a las siguientes reglas durante los Pull Requests:

- **Argumento único (Posicional):** Si una función o método recibe **exactamente un parámetro** que no sea booleano (por ejemplo, un DTO de entrada en un Caso de Uso o servicio), este debe ser **posicional**. Esto reduce la verbosidad innecesaria en firmas simples.
- **Múltiples argumentos (Nombrados):** Si una función o método requiere **dos o más parámetros**, todos deben ser **nombrados** (`{required ...}`). Esto previene errores comunes de inversión de argumentos y auto-documenta el punto de invocación.
- **Excepción estricta para booleanos (Siempre Nombrados):** Cualquier parámetro de tipo `bool` debe ser **nombrado**, sin excepción, incluso si es el único parámetro de la función. Esto evita el antipatrón de valores booleanos misteriosos en la llamada (`avoid_positional_boolean_parameters: true`).

**Ejemplos de Firmas y Parámetros:**

```dart
// ❌ Mal
// Argumento único innecesariamente nombrado
Future<void> execute({required CreateUserDto dto});

// Múltiples argumentos posicionales (propenso a invertir el orden en la llamada)
Future<User> updateUser(String id, String tenantId, UserDto data);

// Booleano posicional (antipatrón: llamada críptica 'toggle(true)')
void setNotificationsEnabled(bool enabled);

// ✅ Bien
// 1. Argumento único no-booleano: posicional
Future<void> execute(CreateUserDto dto);

// 2. Múltiples argumentos: nombrados con required
Future<User> updateUser({
  required String id,
  required String tenantId,
  required UserDto data,
});

// 3. Booleano (único o múltiple): siempre nombrado
void setNotificationsEnabled({required bool isEnabled});
```
