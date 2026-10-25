# 🤖 Instrucciones para Agentes de IA (AGENTS.md) - Tracknner

Este documento establece las directrices obligatorias, estándares de arquitectura, reglas de análisis estático y convenciones de calidad que todo agente de IA o desarrollador debe seguir rigurosamente al generar o modificar código en este repositorio.

---

## 1. 🏗️ Arquitectura y Organización del Proyecto

Tracknner implementa una **Arquitectura Limpia Modular (Clean Architecture)** con separación estricta de dominios, submódulos e infraestructura.

### 1.1. Estructura de Directorios (`lib/`)

```text
lib/
├── main.dart                       # Entrada y orquestador de la app
├── core/                           # Núcleo global transversal ("plomería")
│   ├── database/                   # SQLite (Sqflite)
│   ├── di/                         # Service locator global (get_it)
│   ├── domain/                     # Tipos, contratos y errores globales
│   │   ├── errors/                 # Sistema canónico de CustomError
│   │   └── types/                  # Tipos base (ej. Unknown)
│   ├── infrastructure/             # Adaptadores globales (ej. ValidatorAdapter)
│   └── usecases/                   # Contrato base de Casos de Uso
├── shared/                         # Elementos compartidos transversales de UI
│   ├── constants/                  # Cadenas estáticas, rutas de assets
│   ├── theme/                      # Paleta de colores, tipografías
│   ├── utils/                      # Formateadores, helpers matemáticos
│   └── widgets/                    # Widgets reutilizables (Botones, NavBar, etc.)
└── modules/                        # Macro-Dominios de Negocio
    ├── profile/                    # Macro: Usuario y perfil
    ├── activity/                   # Macro: Registro de actividad física
    │   ├── history/                # Submódulo: Historial de carreras
    │   └── tracking/               # Submódulo: Motor GPS y timer de carrera
    └── game_engine/                # Macro: Core loop de gamificación
        ├── missions/               # Submódulo: Misiones diarias y rachas
        ├── monetization/           # Submódulo: Ads y estado Premium
        ├── pet_core/               # Submódulo: Mascota virtual, XP y niveles
        └── shop/                   # Submódulo: Tienda y economía virtual
```

### 1.2. Reglas de Capas por Módulo / Submódulo
Cada módulo o submódulo sigue una estructura de capas estricta:
1. **`domain/`**: Entidades, contratos de repositorios (`*Repository`), DTOs de dominio y reglas de negocio puras. **Sin dependencias externas ni de Flutter.**
2. **`application/`**: Casos de uso (`*UseCase`), DTOs de entrada (`*DtoImpl`) y orquestación de la lógica de negocio.
3. **`infrastructure/`**: Implementación de repositorios, datasources (locales o remotos), mappers (`*Mapper`) y adaptadores.
4. **`presentation/`**: Controladores de estado (BLoC / Cubit / Riverpod / Notifiers), pantallas (`*Screen`), vistas y widgets propios del módulo.
5. **`di/`**: Inyección de dependencias específica del módulo o submódulo.
6. **`*_module.dart`**: Archivo de fachada que define la **API pública** del macro-dominio. Ningún módulo externo debe acceder a detalles privados internos de otro módulo saltándose esta API.

---

## 2. 🚨 Manejo Estricto de Errores (`CustomError`)

> [!CRITICAL]
> **PROHIBIDO EL USO DE ERRORES GENÉRICOS:**
> Queda estrictamente prohibido lanzar excepciones genéricas como `throw Exception(...)`, `throw 'string'`, `throw Error()` o crear clases de excepción ad-hoc dispersas sin justificación.

Todo error, fallo de infraestructura o validación de negocio debe modelarse y propagarse mediante la clase canónica `CustomError` ubicada en:
`lib/core/domain/errors/custom_error.dart`

### 2.1. Constructores Factory Disponibles

| Factory | Propósito | Parámetros Requeridos |
|---|---|---|
| `CustomError.badRequest` | Error de validación o payload incorrecto | `payload: List<FormattedErrorResponse>`, `path: String` |
| `CustomError.unauthorized` | Sesión inválida o falta de credenciales | `message: String = "No autorizado"`, `path: String` |
| `CustomError.forbidden` | Permisos insuficientes para la acción | `message: String = "No autorizado"`, `path: String` |
| `CustomError.notFound` | Recurso o registro inexistente | `message: String = "No encontrado"`, `path: String` |
| `CustomError.conflict` | Conflicto de estado (ej. duplicados) | `message: String = "Conflicto"`, `path: String` |
| `CustomError.internalServer` | Error grave no controlado / inesperado | `message: String`, `path: String = "desconocido"` |
| `CustomError.serviceUnavailable` | Fallo de red temporal o servicio caído | `message: String`, `path: String = "desconocido"` |

### 2.2. Reglas al Crear Errores
- Siempre especificar el parámetro `path` indicando la procedencia del error (ej. `'modules.profile.create_user'`, `'database.history.query'`).
- Para validaciones, utilizar `FormattedErrorResponse = ({String message, String path})`.

```dart
// ❌ INCORRECTO
throw Exception('User already exists');
throw 'Error al obtener datos';

// ✅ CORRECTO
throw CustomError.conflict(
  message: 'El usuario con este identificador ya existe',
  path: 'modules.profile.infrastructure.user_repository',
);
```

---

## 3. 🔍 Reglas de Linter y Análisis Estático (`analysis_options.yaml`)

El proyecto cuenta con reglas de análisis muy estrictas que rompen el build si se ignoran:

### 3.1. Tipado Fuerte y Seguridad
- **`strict-casts: true`**, **`strict-inference: true`**, **`strict-raw-types: true`**.
- **`avoid_dynamic_calls: error`**: Prohibido el uso de `dynamic`. Si un dato es de tipo desconocido, utilizar `Unknown` o `Object?` con validación explícita.
- **`always_declare_return_types: true` (y error)**: Toda función, método y getter debe tipar explícitamente su retorno (ej. `Future<void>`, `Stream<Activity>`, `int`).

### 3.2. Inmutabilidad y Constructores
- **`prefer_const_constructors: error`** y **`prefer_const_declarations: error`**: Todo widget u objeto inmutable debe usar `const`.
- **`prefer_final_locals: true`** y **`prefer_final_in_for_each: true`**: Prohibido usar `var` para variables reasignables innecesarias. Usar `final` siempre.
- **`prefer_initializing_formals: true`**: Inicializar campos en el constructor (`this.field`).
- **`sort_unnamed_constructors_first: true`**: El constructor principal sin nombre debe ir siempre antes que los constructores nombrados (`.fromJson`, `.create`, etc.).

### 3.3. Estilo, Formato y Estructura
- **`curly_braces_in_flow_control_structures: true`**: Obligatorio el uso de llaves `{}` en todas las estructuras de control (`if`, `else`, `for`, `while`), incluso si son de una sola línea.
- **`require_trailing_commas: true`**: Toda lista de parámetros, colección o árbol de widgets multilínea **debe terminar con una coma final (`,`)**.
- **`directives_ordering: true`**: Orden estricto en imports (Dart SDK -> Paquetes -> Proyecto).
- **`prefer_relative_imports: true`**: Dentro del proyecto se deben preferir imports relativos para mantener la modularidad.
- **`avoid_classes_with_only_static_members: true`**: No crear clases utilitarias de puros miembros estáticos. Usar funciones top-level o extensiones según corresponda en Dart.
- **`avoid_print: true`**: Prohibido usar `print()`. Utilizar el sistema de logs configurado.

---

## 4. 📐 Convenciones de Parámetros y Firmas de Métodos

Siguiendo la norma de `quality-criteria.md`:

1. **Parámetro Único (Posicional):**
   - Si una función o método recibe **exactamente un parámetro** que no sea booleano (ej. un DTO de entrada en un Caso de Uso), debe ser **posicional**.
   ```dart
   // ✅ Correcto
   Future<void> execute(CreateUserDto dto);
   ```
2. **Múltiples Parámetros (Nombrados):**
   - Si la función recibe **2 o más parámetros**, deben ser **nombrados con `required`** para prevenir confusiones de orden en los sitios de llamada.
   ```dart
   // ✅ Correcto
   Future<User> updateUser({
     required String id,
     required UserDto data,
   });
   ```
3. **Excepción Estricta para Booleanos (Siempre Nombrados):**
   - Todo parámetro de tipo `bool` debe ser **nombrado**, sin importar si es el único parámetro de la función (`avoid_positional_boolean_parameters: true`).
   ```dart
   // ❌ Incorrecto
   void setEnabled(bool enabled);

   // ✅ Correcto
   void setEnabled({required bool isEnabled});
   ```

---

## 5. 🏷️ Nomenclatura y Buenas Prácticas de Código

- **Archivos y Directorios:** Estrictamente `snake_case` (ej. `create_user_use_case.dart`, `custom_error.dart`).
- **Clases, Mixins y Enums:** `PascalCase` (ej. `CreateUserUseCase`, `ActivityHistoryScreen`).
- **Variables, Métodos y Constantes:** `lowerCamelCase` (ej. `maxRetries = 3;`, `loadUserData()`). **En Dart las constantes NO van en UPPER_SNAKE_CASE.**
- **Booleanos:** Prefijos afirmativos (`isValid`, `hasPermission`, `isLoading`).
- **Privacidad:** Anteponer guion bajo `_` para variables, clases o métodos privados del archivo.
- **Widgets de Flutter (ver `quality-presentation-criteria.md`):**
  - Extraer widgets en nuevas clases `StatelessWidget` o `StatefulWidget`, nunca en métodos como `Widget _buildRow()`.
  - Aplicar la *Stepdown Rule* (widget público arriba, widgets privados abajo en orden de uso).
  - Límite de 250-300 líneas por archivo: extraer widgets privados a `widgets/` si se supera.
  - Liberar controladores (`dispose()`) en `StatefulWidget` con `super.dispose()` al final.
  - Optimización de `build()`: variables u objetos que no dependan del `BuildContext` deben ir fuera del `build()` como atributos `final`.
  - Usar operadores de colección (`[if (condition) Widget()]`) en vez de ternarios que devuelvan `SizedBox.shrink()`.
  - Usar métodos funcionales (`.map()`, `.where()`, `.fold()`) y operador en cascada (`..`).

---

## 6. 🛡️ Protocolo para Agentes al Modificar el Repositorio

Antes de dar por finalizada cualquier tarea en el código:
1. **Respetar la Arquitectura:** Ubicar cada archivo en el módulo y capa correspondiente (`domain`, `application`, `infrastructure`, `presentation`).
2. **Cumplir con `CustomError`:** Nunca capturar y ocultar errores ni lanzar excepciones genéricas.
3. **Verificar el Formato y Linter:** Comprobar que no se violen las reglas de `analysis_options.yaml` (tipado de retornos, comas finales, sin `dynamic`, imports correctos).
4. **Preservar la Documentación:** No alterar comentarios ni documentaciones existentes a menos que el usuario lo solicite.
