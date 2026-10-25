<!-- Plantilla base -->

# Tracknner

Aplicación móvil multiplataforma desarrollada con **Flutter** y **Dart** bajo principios de Clean Architecture.

---

## Requisitos Previos

- Es **estrictamente necesario** tener instalado el [Flutter SDK](https://docs.flutter.dev/get-started/install) en tu sistema y configurado en tu PATH.

- Asegúrate de que no haya problemas en tu entorno ejecutando `flutter doctor`.

- **IMPORTANTE:** Para poder realizar contribuciones al proyecto, es **indispensable** leer el archivo [CONTRIBUTING.MD](CONTRIBUTING.MD) para conocer las convenciones del proyecto, así como los [Criterios de Calidad de Código](.docs/quality/quality-criteria.md) y los [Criterios de Calidad para Presentación (UI & Widgets)](.docs/quality/quality-presentation-criteria.md).

## 🚀 Instalación y Ejecución

Para poder arrancar la aplicación en tu emulador o dispositivo físico, ejecuta los siguientes comandos en la raíz del proyecto:

1. Instala las dependencias de Dart y paquetes nativos:

   ```bash
   flutter pub get
   ```

   **Inicialización de Git Hooks (Crucial):** Dado que el proyecto utiliza el ecosistema de Dart puro para la validación de código, es necesario inicializar Husky manualmente la primera vez para instalar los hooks locales:

   > ```bash
   > dart run husky install
   > ```
   >
   > _(Nota en Linux/WSL/macOS: Asegúrate de dar permisos de ejecución a los hooks con `chmod +x .husky/_` si experimentas problemas al hacer commit).\*

2. Inicia la aplicación en el dispositivo conectado por defecto:

   ```bash
   flutter run
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
   - El proyecto utiliza Convencional Commits controlados por `commitlint.yaml`. Los commits serán bloqueados automáticamente por Husky si no respetan el formato `<tipo>(<scope>): <mensaje>`.

```bash
# Ejemplos de uso manual:
dart format .
flutter analyze
```

## ⚙️ Configuración de `.vscode`

El proyecto está fuertemente ligado a la configuración del formateador nativo de Dart y a la organización automática de imports, por lo que es **altamente recomendable** crear de forma local el archivo `.vscode/settings.json` en la raíz del proyecto y agregarle la siguiente configuración. Esto permitirá que tu editor se integre perfectamente al guardar.

```json
{
  // 1. Configuración global para archivos que NO son Dart (JSON, Markdown, YAML, etc.)
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,

  // 2. Configuración específica y exclusiva para Dart/Flutter
  "[dart]": {
    // Reemplazamos Prettier por el formateador oficial de Dart solo aquí
    "editor.defaultFormatter": "Dart-Code.dart-code",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll": "explicit",
      "source.organizeImports": "explicit"
    }
  },

  // 3. Herramientas visuales de Flutter
  "dart.previewFlutterUiGuides": true,

  // 4. File Nesting adaptado al ecosistema
  "explorer.fileNesting.enabled": true,
  "explorer.fileNesting.expand": false,
  "explorer.fileNesting.patterns": {
    "*.dart": "${capture}.g.dart, ${capture}.freezed.dart, ${capture}.part.dart",
    "pubspec.yaml": "pubspec.lock, analysis_options.yaml, .metadata, pubspec_overrides.yaml, build.yaml",
    "package.json": "pnpm-lock.yaml, nest-cli.json, tsconfig*.json",
    "README.md": "CONTRIBUTING.md, LICENSE, CHANGELOG.md",
    ".env.template": ".env*",
    "Dockerfile": "docker*.yml, .dockerignore, Dockerfile.*"
  }
}
```

Para que esta configuración funcione correctamente, asegúrate de tener instaladas las siguientes extensiones oficiales en VS Code:

- **Flutter** (`dart-code.flutter`)
- **Dart** (`dart-code.dart-code`)
- **Prettier - Code formatter** (`esbenp.prettier-vscode`) _(Para formatear archivos JSON, YAML y Markdown)_

## Documentación

La documentación adicional técnica, de arquitectura y manuales de usuario se encuentra en la carpeta [.docs](.docs/).
