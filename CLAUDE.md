# Tracknner

App Flutter de running con mascota virtual (Clean Architecture modular).

Antes de escribir código, lee y cumple:

- `.agents/AGENTS.md`: arquitectura, errores con `CustomError` y protocolo.
- `.agents/rules/code-style.md`: estilo de Dart y Flutter.
- `.docs/quality/quality-presentation-criteria.md`: reglas de UI y widgets.
- `CONTRIBUTING.MD`: ramas, commits y Pull Requests.

Aclaraciones sobre el estado real del código:

- Usa imports relativos dentro de `lib/`, aunque `CONTRIBUTING.MD` pida absolutos.
- El estado se maneja con `BaseController` (`ChangeNotifier`) y `provider`.
- La base de datos está en `lib/core/infrastructure/database/`.

Antes de terminar una tarea, ejecuta:

```bash
dart format .
flutter analyze --fatal-infos --fatal-warnings
flutter test
```
