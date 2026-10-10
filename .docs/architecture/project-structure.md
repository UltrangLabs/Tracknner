# 🏗️ Arquitectura y Estructura del Proyecto

Este documento describe la organización de directorios y módulos de la aplicación. El proyecto sigue un enfoque modular, separando las responsabilidades de infraestructura, UI compartida y dominios de negocio específicos.

---

## 📂 Directorios Raíz

La carpeta principal `lib/` se divide lógicamente en áreas clave para soportar la aplicación:

```text
lib/
├── main.dart                       # Punto de entrada y orquestador principal
├── core/                           # ⚙️ El "Núcleo" Global (Plomería)
├── shared/                         # 🛠️ UI y utilidades compartidas
└── modules/                        # 🏗️ Macro-Dominios de Negocio
```

---

## ⚙️ Core (El "Núcleo" Global)

Contiene la configuración central y las herramientas que mantienen el sistema funcionando (plomería).

```text
lib/core/
├── database/                   # Inicialización SQLite (Sqflite)
├── di/                         # Service Locator Central (get_it global)
├── errors/                     # Failures y Exceptions globales
└── usecases/                   # Contrato base genérico para los Casos de Uso
```

---

## 🛠️ Shared (UI y utilidades compartidas)

Contiene elementos transversales de diseño y lógica de utilidad general.

```text
lib/shared/
├── constants/                  # Cadenas estáticas, rutas de assets
├── theme/                      # Paleta de colores, tipografías
├── utils/                      # Formateadores, helpers matemáticos
└── widgets/                    # Componentes UI reutilizables (Botones, NavBar)
```

---

## 🏗️ Módulos de Negocio (Macro-Dominios)

La aplicación se divide en 2 grandes bloques de negocio.

### 1. 🏃 Activity (El Mundo Real)

**Responsabilidad del Macro**: Registrar el esfuerzo físico crudo del usuario. Este macro es completamente "ciego" al juego; no sabe qué son las monedas, ni los niveles, ni la mascota. Entra un corredor, sale un registro de tiempo y distancia.

#### ⏱️ Feature: tracking (Motor de Carrera)
- **Qué hace**: Es el cronómetro y el rastreador en vivo. Se encarga de iniciar, pausar, reanudar y finalizar la carrera (HU 1.1). Se conecta al hardware del teléfono (GPS) para calcular el ritmo y la distancia (HU 1.2).
- **Qué contiene**: La lógica del timer nativo, la comunicación con los sensores del celular, el caso de uso para guardar esa carrera específica en SQLite de forma offline al terminar (HU 1.3), y la Pantalla de Sesión Activa (el cronómetro visual gigante).

#### 📖 Feature: history (Diario de Actividad)
- **Qué hace**: Es la bitácora del corredor. Su único trabajo es leer la base de datos local y mostrar lo que el usuario ha hecho en el pasado (HU 1.4).
- **Qué contiene**: Las consultas SQL (read-only) a la tabla de carreras, el formateo de fechas, y la Pantalla del Historial (la lista de tarjetas ordenadas desde la más reciente a la más antigua).

### 2. 🎮 Game Engine (El Mundo Virtual)

**Responsabilidad del Macro**: Es el cerebro del juego. Toma los datos duros que generó el macro activity y los transforma en diversión, dopamina y retención de usuarios.

#### ⚖️ Feature: missions (El Juez Diario)
- **Qué hace**: Dicta qué tiene que hacer el usuario hoy y lo juzga. Evalúa si el tiempo que corriste alcanza para darte un premio (HU 2.1 y 2.2). Controla que no pierdas el hábito (HU 2.3).
- **Qué contiene**: El generador aleatorio/secuencial de misiones diarias, el validador que intercepta el fin de una carrera para decir "Misión Cumplida" o "Fallida", el contador de días consecutivos (rachas) y el disparador de notificaciones locales para que el celular vibre a las 18:00 hrs si no has corrido (HU 2.4). También contiene la Pantalla de Resumen Post-Carrera.

#### 🐾 Feature: pet_core (La Mascota y la Billetera)
- **Qué hace**: Es la "cuenta bancaria" y el progreso del usuario. Administra cuánto dinero tienes para que no gastes más de lo que posees y maneja el crecimiento de tu compañero virtual (HU 3.1, HU 3.3, HU 3.4).
- **Qué contiene**: El saldo total de monedas, el algoritmo matemático de Experiencia (XP = Nivel), el inventario del usuario (qué ropa o comida ya posee), la lógica para aplicar un consumible (sumar XP a la mascota), y la Pantalla Principal (Dashboard) donde vive el avatar 2D.

#### 🛒 Feature: shop (El Sumidero de la Economía)
- **Qué hace**: Es el lugar donde el usuario quema las monedas que ganó con su sudor.
- **Qué contiene**: El catálogo estático de ítems (comida, skins), la lógica transaccional atómica ("restar 50 monedas y añadir 1 manzana al inventario"), y la UI de la Tienda de Consumibles (HU 3.2).

#### 💰 Feature: monetization (El Dinero Real)
- **Qué hace**: Conecta Tracknner con el mundo comercial de Google/Apple y los anunciantes. Es el único módulo que sí requiere internet obligatoriamente.
- **Qué contiene**: La integración con SDKs externos (AdMob, In-App Purchases). Lógica para mostrar un video de 30 segundos y decirle a pet_core que multiplique las monedas (HU 4.2), la pasarela de pago para comprar paquetes de monedas (HU 4.1), y el validador de si el usuario es "Premium" para ocultar la publicidad (HU 4.3).

---

## 🌳 Árbol Completo del Proyecto

A continuación se muestra la estructura general y completa que se creará, integrando los diferentes dominios, submódulos e infraestructura:

```text
lib/
├── main.dart                       # Punto de entrada y orquestador principal
├── core/                           # ⚙️ El "Núcleo" Global (Plomería)
│   ├── database/                   # Inicialización SQLite (Sqflite)
│   ├── di/                         # Service Locator Central (get_it global)
│   ├── errors/                     # Failures y Exceptions globales
│   └── usecases/                   # Contrato base genérico para los Casos de Uso
├── shared/                         # 🛠️ UI y utilidades compartidas
│   ├── constants/                  # Cadenas estáticas, rutas de assets
│   ├── theme/                      # Paleta de colores, tipografías
│   ├── utils/                      # Formateadores, helpers matemáticos
│   └── widgets/                    # Componentes UI reutilizables (Botones, NavBar)
└── modules/                        # 🏗️ Macro-Dominios de Negocio
    │
    ├── profile/                    # 👤 MACRO 3: El Jugador (Usuario base)
    │   ├── application/
    │   ├── di/
    │   ├── domain/
    │   ├── infrastructure/
    │   ├── presentation/
    │   └── profile_module.dart     # 🚪 API Pública del módulo Profile
    │
    ├── activity/                   # 🏃 MACRO 1: El Esfuerzo Físico
    │   ├── history/                # Diario de carreras pasadas
    │   │   ├── application/
    │   │   ├── di/
    │   │   ├── domain/
    │   │   ├── infrastructure/
    │   │   └── presentation/
    │   ├── tracking/               # Motor GPS, cronómetro y guardado de sesión
    │   │   ├── application/
    │   │   ├── di/
    │   │   ├── domain/
    │   │   ├── infrastructure/
    │   │   └── presentation/
    │   └── activity_module.dart    # 🚪 API Pública del módulo Activity
    │
    └── game_engine/                # 🎮 MACRO 2: El Core Loop y Economía
        ├── missions/               # Metas diarias, rachas y notificaciones
        │   ├── application/
        │   ├── di/
        │   ├── domain/
        │   ├── infrastructure/
        │   └── presentation/
        ├── monetization/           # Anuncios y estado Premium
        │   ├── application/
        │   ├── di/
        │   ├── domain/
        │   ├── infrastructure/
        │   └── presentation/
        ├── pet_core/               # XP, niveles y equipamiento
        │   ├── application/
        │   ├── di/
        │   ├── domain/
        │   ├── infrastructure/
        │   └── presentation/
        ├── shop/                   # Consumibles y compras in-app
        │   ├── application/
        │   ├── di/
        │   ├── domain/
        │   ├── infrastructure/
        │   └── presentation/
        └── game_engine_module.dart # 🚪 API Pública del módulo Game Engine
```