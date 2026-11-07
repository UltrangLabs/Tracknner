<!-- Plantilla base -->

# Tracknner

Aplicación móvil multiplataforma desarrollada con **Flutter** y **Dart** bajo principios de Clean Architecture.

---

## 📋 Requisitos Previos

- Es **estrictamente necesario** tener instalado el [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.24+) en tu sistema y configurado en tu PATH.
- Asegúrate de que no haya problemas en tu entorno ejecutando `flutter doctor`.
- **IMPORTANTE:** Para contribuir al proyecto, es indispensable leer el archivo [CONTRIBUTING.MD](CONTRIBUTING.MD), así como los [Criterios de Calidad de Código](.docs/quality/quality-criteria.md) y los [Criterios de Calidad para Presentación (UI & Widgets)](.docs/quality/quality-presentation-criteria.md).

---

## 🚀 Instalación y Variables de Entorno (.env)

El proyecto maneja configuraciones y entornos independientes mediante **Dart Defines** leídos desde archivos `.env`. Antes de arrancar la aplicación, debes preparar tus variables locales:

1. Duplica la plantilla base `.env.template`.
2. Renombra la copia a `.env.dev` (para desarrollo local) o `.env.test` (para pruebas e integración).
3. Rellena las variables requeridas en cada archivo según corresponda *(Nota: Los archivos `.env.*` están ignorados en Git por seguridad y nunca deben commitearse)*.

Luego, ejecuta en tu terminal:

```bash
# 1. Instala dependencias de Dart y paquetes nativos
flutter pub get

# 2. Inicializa los hooks de Husky (Obligatorio la primera vez)
dart run husky install
# (En Linux/WSL/macOS: asegúrate de dar permisos de ejecución si hay error: chmod +x .husky/*)
```

---

## ▶️ Opciones para Ejecutar el Proyecto

El repositorio incluye automatizaciones y configuraciones listas para usar de modo que no tengas que recordar comandos extensos:

### 1. Desde el Editor (Recomendado - Zero Setup)

El proyecto incluye la configuración predefinida en `.vscode/launch.json`. En VS Code o Antigravity IDE:

1. Ve al panel de **Run and Debug** (`Ctrl+Shift+D` en Windows/Linux o `Cmd+Shift+D` en macOS).
2. Selecciona una configuración del menú desplegable:
   - **🚀 Tracknner (Dev):** Ejecuta `lib/main.dart` apuntando a `.env.dev`.
   - **🧪 Tracknner (Integration Tests):** Ejecuta `integration_test/app_test.dart` con `.env.test`.
3. Presiona **`F5`** para iniciar en modo depuración (debugging) con breakpoints y Hot Reload activos.

### 2. Desde la Terminal (Vía Makefile - Opcional)

Si utilizas terminal y cuentas con **GNU Make** instalado (nativo en Linux/macOS, o instalable en Windows vía `winget install GnuWin32.Make` o `choco install make`):

```bash
make dev       # Inicia la app con --dart-define-from-file=.env.dev
make test      # Ejecuta pruebas de integración con --dart-define-from-file=.env.test
make coverage  # Genera reporte de cobertura lcov y HTML
```

### 3. Ejecución Manual (CLI de Flutter)

También puedes correr los comandos directamente usando el CLI de Flutter:

```bash
# Ejecutar en desarrollo
flutter run --dart-define-from-file=.env.dev

# Ejecutar tests de integración
flutter test integration_test/app_test.dart --dart-define-from-file=.env.test
```

---

## 🛡️ Validaciones y Calidad de Código

Este proyecto asegura la calidad del código mediante las herramientas oficiales del SDK de Dart configuradas en "Modo Estricto", acompañadas de **Husky** (hooks de Git) y `commitlint_cli` que validan tu código y mensajes de commit de forma automática.

Puedes auditar el proyecto de forma manual ejecutando los siguientes comandos:

1. **Análisis Estático (Linter)**
   - `flutter analyze`: Ejecuta el analizador estático validando el tipado estricto, imports absolutos y reglas de `analysis_options.yaml`.
   - `flutter analyze --fatal-infos --fatal-warnings`: (Modo CI) Falla la ejecución si existe cualquier advertencia o regla de estilo rota.

2. **Formateo Automático**
   - `dart format .`: Formatea todo el código del proyecto al estándar oficial de 80 caracteres de Dart.

3. **Validación de Commits**
   - El proyecto utiliza Conventional Commits controlados por `commitlint.yaml`. Los commits serán bloqueados automáticamente por Husky si no respetan el formato `<tipo>(<scope>): <mensaje>`.

```bash
# Ejemplos de uso manual:
dart format .
flutter analyze
```

---

## ⚙️ Configuración del Editor (Zero-Config con `.vscode`)

El repositorio incluye la carpeta `.vscode/` versionada directamente para ofrecer una experiencia lista para codificar desde el primer minuto:

- **`launch.json`**: Perfiles de arranque y debug con `F5` mapeados a las variables de entorno correspondientes.
- **`settings.json`**:
  - Formateo automático al guardar (`formatOnSave`).
  - Organización automática de imports (`source.organizeImports`) y auto-fixes de Dart.
  - Formateador por defecto configurado (`Dart-Code` para `.dart`, `Prettier` para JSON/YAML/Markdown).
  - Guías visuales de UI de Flutter (`previewFlutterUiGuides`).
  - Anidamiento visual de archivos (`File Nesting`) para agrupar `.env*`, archivos autogenerados (`.g.dart`, `.freezed.dart`), configs y documentación.
- **`extensions.json`**: Extensiones recomendadas que VS Code sugerirá instalar al abrir el workspace:
  - **Esenciales:** `dart-code.flutter`, `dart-code.dart-code`, `esbenp.prettier-vscode`.
  - **Productividad:** `ErrorLens`, `GitLens`, `Better Comments`, `Pubspec Assist`, `Material Icon Theme`, etc.

---

## 📚 Documentación

La documentación adicional técnica, de arquitectura y manuales de usuario se encuentra en la carpeta [.docs/](.docs/).
