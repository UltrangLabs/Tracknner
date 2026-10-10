# Guía de Contribución 🚀

¡Gracias por contribuir a este proyecto! Este documento describe las convenciones, arquitectura y flujos de trabajo que seguimos para mantener un desarrollo organizado, ágil y de alta calidad técnica en nuestra aplicación móvil multiplataforma.

Para ayudarnos a mantener el código impecable y altamente estandarizado, **te invitamos a leer detenidamente** nuestros documentos principales de estilo antes de escribir tu primera línea de código. ¡Son tu mejor guía para evitar rechazos en los PRs!
👉 [Criterios de Calidad de Código](QUALITY_CRITERIA.md)
👉 [Estructura de Arquitectura Limpia](.docs/structure.md)

---

## 📋 Requisitos Previos

Antes de comenzar a codificar, asegúrate de tener:

- **Git** instalado y configurado.
- **Flutter SDK** instalado (en el canal `stable`).
- **VS Code** con las extensiones oficiales de Flutter y Dart, y el archivo `.vscode/settings.json` configurado.
- **Husky y Commitlint** habilitados localmente. **IMPORTANTE:** Tras tu primer `flutter pub get`, inicializa los hooks nativos ejecutando:
  ```bash
  dart run husky install
  ```

---

## 🌳 Estrategia de Ramas (Kanban + Fases)

Para evitar el "merge hell" en el ciclo de vida de la aplicación, utilizamos **ramas de fase** como entornos de integración temporal controlados por nuestro script pre-push.

```text
production
└── develop
    └── phase/<numero>-<nombre-fase>
        ├── feat/<modulo>-<funcionalidad>-<ticket>
        ├── fix/<modulo>-<bug>-<ticket>
        ├── refactor/<modulo>-<tarea>-<ticket>
        └── chore/<modulo>-<tarea>-<ticket>
```

### Ramas Principales

- **`production`**: Código 100% estable y empaquetado para las tiendas (App Store / Play Store). Solo recibe cambios desde `develop` mediante Pull Request.
- **`develop`**: Rama principal de integración continua. Recibe los PRs de las ramas `phase/` una vez que la fase completa ha sido validada.
- **`phase/<numero>-<nombre>`** _(Ej: `phase/01-core-database`)_: Nuestro entorno de desarrollo diario. Desde aquí nacen todas las ramas de trabajo individuales.

### Ramas de Trabajo (Tickets)

El número del ticket al final de la rama es **OBLIGATORIO** para que GitHub Projects mueva las tarjetas en el tablero Kanban. Husky bloqueará el Push si no sigues esta regla.

**Formato:**

```text
<type>/<module>-<short-description>-<ticket_id>
```

**Ejemplos:**

- `feat/iam-login-screen-3`
- `fix/shared-theme-colors-12`
- `chore/infra-setup-lefthook-1`

### Sub-ramas de Trabajo (Opcional)

Si una feature es masiva, divídela en sub-ramas que hacen merge hacia la rama de trabajo principal (sin requerir el ID del ticket en las hijas).

```text
phase/01-core-database
└── feat/database-offline-first-3
    ├── feat/database-sqlite-setup
    └── feat/database-drift-models
```

---

### 🔒 Validaciones CI por Nivel de Rama

Al abrir un Pull Request, el pipeline de GitHub Actions ejecuta validaciones progresivas. Mientras más cerca de `production`, más estricto es el control:

| Validación Flutter                    | `feat → feat` | `feat → phase` | `phase → develop` | `develop → prod` |
| ------------------------------------- | :-----------: | :------------: | :---------------: | :--------------: |
| dart format (estilo de código)        |      ✅       |       ✅       |        ✅         |        ✅        |
| flutter analyze (calidad y tipos)     |      ✅       |       ✅       |        ✅         |        ✅        |
| Reglas de Arquitectura Limpia         |      ❌       |       ✅       |        ✅         |        ✅        |
| Compilación (build apk)               |      ❌       |       ❌       |        ✅         |        ✅        |
| Testing (flutter test)                |      ❌       |       ❌       |        ✅         |        ✅        |

> **¿Por qué esta progresión?**
> En ramas de trabajo (`feat/`) priorizamos la velocidad de iteración asegurando formato (80 caracteres) y tipado estricto. La compilación de los binarios (APK/iOS) es pesada y toma tiempo, por lo que solo se ejecuta cuando consolidamos una fase hacia `develop` o `production` para garantizar que la app realmente corre.

---

## 💬 Convención de Commits

Aplicamos Semantic Versioning automatizado mediante `commitlint_cli`. Todo commit debe seguir este formato exacto:

```text
type(scope): imperative description
```

**Reglas del mensaje:**

- Todo en minúsculas.
- Sin punto final.
- Describe qué hace el commit (ej. `feat(iam): add login screen`).

### Tipos permitidos

- **`feat`**: Úsalo cuando agregues una nueva funcionalidad, pantalla o característica al proyecto.
- **`fix`**: Úsalo cuando corrijas un bug, error o comportamiento no deseado.
- **`docs`**: Úsalo cuando solo estés modificando archivos de documentación (README, criterios, etc).
- **`style`**: Úsalo para cambios de formato de código (como ejecutar `dart format`) que no afecten la lógica.
- **`refactor`**: Úsalo para cambios en el código que no corrigen un bug ni agregan una funcionalidad, pero mejoran su estructura (como extraer un widget).
- **`chore`**: Úsalo para tareas de mantenimiento, actualizaciones de dependencias, configuración de herramientas o CI.

### Scopes permitidos

Scope Carpeta

---

- **core**: `lib/core/`
- **shared**: `lib/shared/`
- **profile**: `lib/modules/profile/`
- **activity**: `lib/modules/activity/`
- **game-engine**: `lib/modules/game_engine/`
- **deps**: Dependencias (pubspec.yaml)
- **tools**: Scripts y herramientas
- **docs**: Archivos `.md` y documentación
- **root**: Configuración principal
- **ci**: GitHub Actions, Husky, CI

### Ejemplos válidos

```bash
git commit -m "feat(activity): create gps tracker component"
git commit -m "fix(shared): resolve text formatting"
git commit -m "docs(root): update contributing guide"
git commit -m "chore(ci): update commitlint configuration"
```

---

## 📏 Estándares de Código y Arquitectura

Tu código debe respetar el `analysis_options.yaml` en modo estricto. De lo contrario, el CI fallará:

1. **Clean Architecture:** La capa de Dominio no debe conocer a Flutter (`package:flutter`). Mantenla en Dart puro. La capa de Presentación y de Datos se comunican exclusivamente a través del Dominio.
2. **Importaciones Absolutas:** Prohibido usar rutas relativas para salir de tu módulo (`../../`). Utiliza siempre Package Imports: `import 'package:mi_app/shared/theme.dart';`.
3. **Tipado Estricto:** Está estrictamente prohibido el uso de `dynamic` y todos los métodos deben tener un tipo de retorno declarado.
4. **Cero Advertencias:** Todo el código debe estar libre de "blue lines" (warnings).

---

## 📝 Convención de Pull Requests

- **Título:** Semantic commit (`feat(iam): diseño inicial de la pantalla de login`).
- **Cuerpo:** Obligatorio enlazar el ticket en la sección "Resolves" (ej. `Resolves #5`) para automatizar el Kanban.
- **Destino:** Los PRs diarios deben apuntar a la rama `phase/` activa.

---

## 🔀 Flujo de Trabajo (Ejemplo Práctico)

1. **Posiciónate en la fase actual y actualízala:**

   ```bash
   git checkout phase/01-core-setup
   git pull origin phase/01-core-setup
   ```

2. **Crea tu rama de trabajo con el ticket Kanban (ej. Ticket #3):**

   ```bash
   git checkout -b feat/shared-theme-colors-3
   ```

3. **Desarrolla, guarda (VS Code formateará y ordenará los imports), y sube los cambios:**

   ```bash
   git add .
   git commit -m "feat(shared): configure material 3 color scheme"
   git push origin feat/shared-theme-colors-3
   ```
   *(Husky revisará el código automáticamente antes de enviarlo).*

4. **Abre el Pull Request en GitHub dirigido hacia `phase/01-core-setup`.**

---

## ✅ Checklist antes de solicitar un Code Review

- [ ] Entendí los Criterios de Aceptación del ticket Kanban.
- [ ] Ejecuté `dart format .` o guardé en VS Code para ordenar el código.
- [ ] Ejecuté `flutter analyze` y solucioné todos los infos/warnings.
- [ ] El nombre de mi rama sigue la estructura con el ID del ticket al final.
- [ ] Enlacé el número del ticket en el cuerpo del Pull Request.