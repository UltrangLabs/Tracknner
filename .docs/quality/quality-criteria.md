# Criterios de Calidad de Código para Flutter & Dart 🟦

## Base

### Objetivos Principales

- **Seguridad nula (Null Safety):** El código debe aprovechar al máximo el sistema de tipos de Dart. No deben existir errores de tipo `NullPointerException` en tiempo de ejecución.
- **Rendimiento (60/120 FPS):** La interfaz de usuario no debe bloquearse. Las operaciones pesadas deben moverse a _Isolates_ o manejarse de forma asíncrona, y se debe maximizar el uso de constructores `const`.

### Nomenclatura

- **camelCase:** Los nombres de variables, parámetros, propiedades y métodos comienzan con minúscula y usan notación `lowerCamelCase`.
- **Constantes en camelCase:** A diferencia de otros lenguajes, en Dart las constantes **no** usan mayúsculas. Deben escribirse en `lowerCamelCase` (ej. `const maxRetries = 3;`).
- **Inglés:** Se utilizan sustantivos en inglés para variables y propiedades.
- **Sin tipo de dato en el nombre:** No incluir el tipo de dato en el nombre de la variable (ej. usar `user` en lugar de `userMap` o `userList`).
- **Plurales para colecciones:** Los `List`, `Set` o `Map` deben nombrarse con sustantivos en plural (ej. `users`).
- **Booleanos:** Las variables booleanas deben comenzar con prefijos de afirmación (ej. `isLoggedIn`, `hasFriends`, `canUpdate`).
- **Clases y Enums:** Se nombran utilizando `PascalCase`. Si incluyen acrónimos, solo la primera letra va en mayúscula (ej. `HttpService`, no `HTTPService`).
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

### Formato y Estructura

- **Linter Oficial:** El proyecto debe usar `flutter_lints` configurado en el archivo `analysis_options.yaml`. No debe haber advertencias (warnings) azules en el editor.
- **La coma final (Trailing Comma):** Todo constructor de Widget, función o lista que ocupe múltiples líneas debe terminar con una coma `,` antes del paréntesis o corchete de cierre para garantizar el auto-formateo en forma de árbol.
- **Sin valores mágicos:** No se deben utilizar strings, colores o números quemados directamente en la UI. Deben extraerse a constantes o manejarse mediante el `Theme` de la aplicación.

**Ejemplos de Formato:**

```dart
// ❌ Mal (Sin comas finales, difícil de leer)
Column(children: [Text('Hola'), Icon(Icons.add)])

// ✅ Bien (Con comas finales, formateo en árbol)
Column(
  children: [
    Text('Hola'),
    Icon(Icons.add),
  ],
)
```

### Criterios Específicos de Flutter (Arquitectura UI)

- **Uso exhaustivo de const:** Cualquier Widget u objeto que no dependa de variables mutables debe instanciarse con la palabra `const` para guardarse en caché de memoria.
- **Widgets en Clases, no en Métodos:** Si un árbol de Widgets crece demasiado, debe extraerse en una nueva clase `StatelessWidget`. Está prohibido extraer Widgets complejos en métodos que retornen `Widget` (ej. `Widget _buildHeader() { ... }`).
- **Controladores y Memoria:** Todo Widget que instancie un objeto que maneje hardware o escuchas (`TextEditingController`, `FocusNode`, `ScrollController`, `AnimationController`) debe ser un `StatefulWidget` para destruirlos explícitamente en el método `dispose()`.
- **Instanciación en build:** Nunca se deben instanciar controladores, streams o hacer llamadas directas a APIs dentro del método `build`, ya que este se ejecuta múltiples veces por segundo.

## Avanzado

### Sintaxis y Modernidad

- **Null-aware operators:** Se debe preferir el uso de sintaxis moderna (`?.`, `??`, `??=`) para manejar nulos en lugar de bloques `if` extensos.
- **Prohibido el dynamic:** El tipo `dynamic` está estrictamente prohibido, ya que apaga el análisis estático. Si no se conoce el tipo, se debe usar `Object?` y castear explícitamente.
- **Abstracciones:** Para crear interfaces o contratos, se debe utilizar la palabra reservada `abstract class` (en Dart toda clase es una interfaz implícita, pero `abstract` evita su instanciación).

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
- **Múltiples argumentos (Nombrados):** Si una función o método requiere **dos o más parámetros**, todos deben ser **nombrados** (`{required ...}`). Esto previene errores comunes de inversión de argumentos (especialmente de tipos similares como `String`, `int` o `double`) y auto-documenta el punto de invocación.
- **Excepción estricta para booleanos (Siempre Nombrados):** Cualquier parámetro de tipo `bool` debe ser **nombrado**, sin excepción, incluso si es el único parámetro de la función. Esto evita el antipatrón de valores booleanos misteriosos en la llamada (ej. `updateStatus(true)`) y se alinea con la regla de linter `avoid_positional_boolean_parameters`.

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

