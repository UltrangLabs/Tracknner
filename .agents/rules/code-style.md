---
trigger: always_on
glob: "**/*.dart"
description: "Estándares obligatorios de estilo de código, firmas de métodos y arquitectura de widgets en Flutter & Dart para Tracknner."
---

# 📏 Estilo de Código y Reglas de Desarrollo (Tracknner)

Todo agente de IA y desarrollador debe cumplir de forma estricta las siguientes directrices al generar o refactorizar código Dart y Flutter en este repositorio.

---

## 1. 🏷️ Nomenclatura y Convenciones de Tipos

- **Variables, Métodos y Funciones:** En `lowerCamelCase` (ej. `fetchUserData()`, `totalDistance`).
- **Constantes:** En `lowerCamelCase`. **PROHIBIDO el uso de `UPPER_SNAKE_CASE`** en Dart (ej. `const maxRetries = 3;`, no `MAX_RETRIES`).
- **Clases, Mixins y Enums:** En `PascalCase` (ej. `UserProfileScreen`, `UserRole`). Los valores de un enum deben ir en `lowerCamelCase` (ej. `enum UserRole { admin, guest }`).
- **Archivos y Directorios:** Estrictamente en `snake_case` (ej. `run_tracking_screen.dart`, `create_user_use_case.dart`).
- **Idioma y Claridad:** Nombres en inglés para entidades de código. No incluir el tipo de dato en el nombre (usar `users`, no `userList` o `userMap`).
- **Booleanos:** Prefijos afirmativos (`isValid`, `hasPermission`, `isLoading`, `isEnabled`).
- **Privacidad:** Anteponer siempre un guion bajo `_` para cualquier miembro, método o clase privada del archivo.

---

## 2. 📐 Firmas de Métodos y Parámetros

Al definir funciones, métodos o constructores en cualquier capa:

1. **Parámetro Único (Posicional):**
   - Si recibe exactamente **un parámetro** que no sea booleano (ej. DTO de entrada), debe ser **posicional**.
   ```dart
   // ✅ Correcto
   Future<void> execute(CreateUserDto dto);
   ```

2. **Múltiples Parámetros (Nombrados):**
   - Si la función recibe **2 o más parámetros**, deben ser **nombrados con `required`** para evitar inversiones accidentales de orden.
   ```dart
   // ✅ Correcto
   Future<User> updateUser({
     required String id,
     required String tenantId,
     required UserDto data,
   });
   ```

3. **Excepción Estricta para Booleanos (Siempre Nombrados):**
   - Todo parámetro de tipo `bool` debe ser **nombrado**, sin importar si es el único parámetro de la función (`avoid_positional_boolean_parameters: true`).
   ```dart
   // ❌ Incorrecto: setNotifications(true);
   void setNotifications(bool enabled);

   // ✅ Correcto: setNotifications(isEnabled: true);
   void setNotifications({required bool isEnabled});
   ```

---

## 3. 🛡️ Análisis Estático, Linter y Tipado Fuerte

- **Prohibido `dynamic` (`avoid_dynamic_calls: error`):** Utilizar `Unknown` o `Object?` con validaciones explícitas de tipo.
- **Retornos Explícitos (`always_declare_return_types: error`):** Tipar siempre el valor de retorno de funciones, métodos y getters (`Future<void>`, `int`, `Widget`).
- **Inmutabilidad:**
  - Usar `final` para variables locales y bucles (`prefer_final_locals`, `prefer_final_in_for_each`).
  - Usar `const` exhaustivamente en constructores e instancias inmutables (`prefer_const_constructors`, `prefer_const_declarations`).
- **Coma Final Obligatoria (`require_trailing_commas: true`):** Toda lista de parámetros, colección o árbol de widgets multilínea debe terminar con una coma `,` final para forzar el auto-formateo limpio en cascada.
- **Control de Flujo con Llaves:** Siempre usar llaves `{}` en `if`, `else`, `for`, `while`, sin excepciones de una sola línea.
- **Prohibido `print()` (`avoid_print: true`):** Usar el logger configurado o utilidades del sistema.
- **Imports:** Preferir imports relativos dentro del proyecto (`prefer_relative_imports: true`) y ordenados (`directives_ordering: true`).
- **Constructores:** Inicializar campos en el formal (`this.field`) y ordenar el constructor principal sin nombre antes que los constructores nombrados (`sort_unnamed_constructors_first: true`).

---

## 4. 🧩 Buenas Prácticas de Sintaxis Moderna

- **Manejo de Nulos:** Usar operadores modernos (`?.`, `??`, `??=`) en lugar de bloques `if` redundantes.
- **Colecciones UI (Collection-If):** Usar `[if (condition) Widget()]` directamente dentro de listas de hijos, evitando ternarios que retornen `SizedBox.shrink()` o widgets nulos.
- **Iteradores Funcionales:** Emplear `.map()`, `.where()` y `.fold()` en transformaciones de colecciones en lugar de bucles `for` tradicionales.
- **Operador de Cascada (`..`):** Aprovechar la cascada al configurar propiedades secuenciales en una misma instancia.

---

## 5. 🎨 Arquitectura de UI y Capa de Presentación

### 5.1. Clean Code en Widgets Stateless
- **Clases Dedicated vs Métodos:** PROHIBIDO extraer widgets en métodos auxiliares como `Widget _buildItem()`. Toda sección conceptual debe ser una clase `StatelessWidget`.
- **Evitar la Sobre-Fragmentación:** No crear clases para widgets triviales (`Text`, `Padding`) sin lógica ni reutilización.
- **Stepdown Rule:**
  1. Widget público principal arriba.
  2. Widgets privados auxiliares (`_NombreWidget`) abajo.
  3. Orden de las clases privadas según el orden en que son invocadas en el árbol del widget principal.
- **Límite de Archivo (250–300 líneas):** Si los widgets privados superan este umbral, deben promoverse a públicos y extraerse a `presentation/widgets/`.

### 5.2. Clean Code en StatefulWidget y Controladores
- **Prevención de Fugas de Memoria (`dispose`):** Todo `TextEditingController`, `FocusNode`, `ScrollController` o `AnimationController` debe instanciarse como atributo de la clase `State` y liberarse obligatoriamente en `dispose()`.
- **`super.dispose()` al final:** Siempre llamar a `super.dispose()` en la última línea del método.
- **Regla del Método `build()` (Rendimiento 60/120 FPS):**
  - **Fuera de `build()`:** Todo objeto o configuración estática que **NO dependa del `BuildContext`** (bordes, estilos, decoraciones estáticas) debe declararse fuera del `build()` como atributo `final` del `State`.
  - **Dentro de `build()`:** Solo lo que dependa de `BuildContext` (`Theme.of(context)`, `MediaQuery.of(context)`) o enlace callbacks vivos de la instancia.
- **Estructura Interna del `State`:**
  1. Atributos (controladores y estilos estáticos extraídos).
  2. Ciclo de vida (`initState`, `dispose`).
  3. Método `build(BuildContext context)`.
  4. Callbacks y métodos privados (ordenados según su invocación en `build`).
