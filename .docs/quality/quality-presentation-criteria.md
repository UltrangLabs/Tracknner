# 🎨 Criterios de Calidad para la Capa de Presentación (UI & Widgets)

Este documento define los estándares obligatorios de diseño, estructura, rendimiento y limpieza de código para la capa de **Presentación (`presentation/`)** en Flutter dentro de Tracknner.

Todo desarrollador y agente de IA debe aplicar estas directrices al crear o refactorizar pantallas (`screens/`), componentes (`widgets/`) y vistas.

---

## 1. 🧩 Clean Code con Widgets Stateless

La descomposición de la interfaz de usuario en widgets pequeños es esencial para mantener un código legible, desacoplado y fácil de testear.

### 1.1. Separación en Clases Dedicated
- **Widgets en Clases, no en Métodos:** Queda terminantemente prohibido extraer fragmentos de UI en métodos auxiliares como `Widget _buildItem()`. Toda sección reutilizable o conceptualmente independiente debe ser un `StatelessWidget`.
- **Ventaja:** Permite que Flutter optimice las reconstrucciones mediante el árbol de elementos (`Element Tree`) y el uso de constructores `const`.

### 1.2. Evitar la Sobre-Fragmentación
- No caer en el extremo de crear una nueva clase para un simple `Text`, `Padding` o `SizedBox` que no aporta valor semántico, reutilización lógica ni modularidad visual.
- La división debe responder a bloques coherentes de la interfaz (ej. `_MessageBubble`, `_ImageBubble`, `_UserProfileHeader`).

### 1.3. Regla del Paso Hacia Abajo (Stepdown Rule)
- **Flujo de Lectura:** El archivo debe leerse de arriba hacia abajo:
  1. **Clases públicas primero:** El widget principal exportable va en la parte superior del archivo.
  2. **Clases privadas al final:** Los widgets auxiliares privados (con prefijo `_`) se declaran después del widget público principal.
  3. **Orden de uso:** El orden secuencial de las clases privadas debe coincidir con el orden en que son invocadas en el árbol del widget principal.

### 1.4. Límite de Tamaño de Archivo (250 - 300 Líneas)
- Si un archivo supera las **250 a 300 líneas de código** debido a la acumulación de widgets privados auxiliares:
  - Dichos widgets deben ser promovidos a **widgets públicos**.
  - Deben extraerse a sus propios archivos independientes dentro de la subcarpeta `widgets/` de la feature correspondiente (`presentation/widgets/`).

---

### 1.5. Ejemplo: Stateless & Stepdown Rule

```dart
// ❌ Mal (Extracción en métodos auxiliares dentro del mismo widget)
class HerMessageBubble extends StatelessWidget {
  const HerMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMessage(), // Antipatrón: método que retorna Widget
        _buildImage(context),
      ],
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Text('Hola mundo'),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Image.network('https://example.com/photo.jpg');
  }
}
```

```dart
// ✅ Bien (Clases dedicadas, constructor const y orden descendente)
class HerMessageBubble extends StatelessWidget {
  const HerMessageBubble({super.key});

  @override
  Widget build(BuildContext context) {
    // Correcto: Depende del context, se lee dentro del build
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MessageBubble(colors: colors),
        const SizedBox(height: 5),
        const _ImageBubble(),
        const SizedBox(height: 10),
      ],
    );
  }
}

// 1° Widget privado auxiliar (invocado primero)
class _MessageBubble extends StatelessWidget {
  final ColorScheme colors;

  const _MessageBubble({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text('Hola mundo', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// 2° Widget privado auxiliar (invocado segundo)
class _ImageBubble extends StatelessWidget {
  const _ImageBubble();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        'https://example.com/asset.gif',
        width: size.width * 0.7,
        height: 150,
        fit: BoxFit.cover,
      ),
    );
  }
}
```

---

## 2. ⚡ Clean Code con StatefulWidget y Controladores

Cuando una vista requiere gestión de estado local, animaciones, hardware o captura de texto, se deben aplicar reglas estrictas de consumo de memoria y ciclo de vida.

### 2.1. Gestión de Recursos y Fugas de Memoria (`dispose`)
- **Controladores como Atributos:** Todo objeto que gestione hardware, listeners o buffers (`TextEditingController`, `FocusNode`, `ScrollController`, `AnimationController`, `PageController`) debe ser instanciado como atributo en la clase `State`.
- **Liberación Obligatoria:** Es mandatorio liberar cada uno en el método `dispose()` para evitar fugas de memoria (`memory leaks`).
- **Super al final:** Siempre llamar a `super.dispose()` en la última línea del método `dispose()`.

### 2.2. Regla de Oro del Método `build()` (Rendimiento 60/120 FPS)
> [!TIP]
> Para una guía práctica detallada y un árbol de decisión interactivo de 3 preguntas, consulta la nota técnica: [Reglas de Rendimiento: ¿Dentro o Fuera de build?](../notes/build-performance-rules.md).

- **Fuera del `build()`:** Todo objeto, configuración, estilo o variable que **NO dependa del `BuildContext`** (ej. bordes de inputs, constantes de diseño, decoraciones estáticas, duraciones) debe declararse **fuera del `build()` como atributo `final` de la clase `State`**.
  - *Razón:* Declararlos dentro del `build()` causa que Flutter instancie nuevos objetos innecesariamente en cada frame de reconstrucción, sobrecargando el Garbage Collector.
- **Dentro del `build()`:** Únicamente se declara lo que:
  1. Depende directamente del `BuildContext` (ej. `Theme.of(context)`, `MediaQuery.of(context)`).
  2. Requiere enlazar callbacks o referencias vivas de la instancia (ej. `onPressed: _onPressed`).

### 2.3. Estructura Interna del `State`
El cuerpo de la clase `State` debe seguir un orden predecible y estricto:
1. **Atributos de la clase:**
   - Controladores (`TextEditingController`, `FocusNode`).
   - Propiedades de diseño estáticas extraídas (fuera de `build`).
2. **Ciclo de vida:**
   - `initState()` (si aplica).
   - `didChangeDependencies()` (si aplica).
   - `dispose()` (con liberación de controladores y `super.dispose()` al final).
3. **Método `build(BuildContext context)`**.
4. **Métodos privados y Callbacks de eventos:**
   - Declarados en el orden exacto en el que son referenciados dentro del `build()`.

---

### 2.4. Ejemplo: StatefulWidget & Controladores

```dart
// ❌ Mal (Instanciación de bordes dentro del build y sin liberar controladores)
class BadFieldBox extends StatefulWidget {
  const BadFieldBox({super.key});

  @override
  State<BadFieldBox> createState() => _BadFieldBoxState();
}

class _BadFieldBoxState extends State<BadFieldBox> {
  // Sin dispose() -> Memory Leak asegurado
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Ineficiente: Se recrea el mismo borde estático en cada pulsación de tecla
    final border = UnderlineInputBorder(
      borderRadius: BorderRadius.circular(80),
      borderSide: const BorderSide(color: Colors.transparent),
    );

    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}
```

```dart
// ✅ Bien (Bordes fuera del build, dispose riguroso y callbacks ordenados)
class MessageFieldBox extends StatefulWidget {
  const MessageFieldBox({super.key});

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  // Correcto: Extraído del build porque NO requiere leer el BuildContext.
  // Evita instanciarlo repetidas veces en cada redibujado de la pantalla.
  final _outlineInputBorder = UnderlineInputBorder(
    borderSide: const BorderSide(color: Colors.transparent),
    borderRadius: BorderRadius.circular(80),
  );

  @override
  void dispose() {
    // Destrucción explícita de controladores para liberar memoria
    textController.dispose();
    focusNode.dispose();

    // super.dispose() siempre se llama al final
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // inputDecoration se mantiene dentro del build porque referencia 
    // a _onPressed (método de la instancia viva).
    final inputDecoration = InputDecoration(
      hintText: 'Envía tu mensaje...',
      filled: true,
      enabledBorder: _outlineInputBorder,
      focusedBorder: _outlineInputBorder,
      suffixIcon: IconButton(
        icon: const Icon(Icons.send_outlined),
        onPressed: _onPressed,
      ),
    );

    return TextFormField(
      controller: textController,
      focusNode: focusNode,
      decoration: inputDecoration,
      onTapOutside: _onTapOutside,
      onFieldSubmitted: _onSubmittedValue,
      onChanged: _onValueChanged,
    );
  }

  // 1° Callback: referenciado primero en suffixIcon
  void _onPressed() {
    final textValue = textController.value.text;
    // Procesar acción
    textController.clear();
  }

  // 2° Callback: referenciado en onTapOutside
  void _onTapOutside(PointerDownEvent event) {
    focusNode.unfocus();
  }

  // 3° Callback: referenciado en onFieldSubmitted
  void _onSubmittedValue(String value) {
    textController.clear();
    focusNode.requestFocus();
  }

  // 4° Callback: referenciado en onChanged
  void _onValueChanged(String value) {
    // Validación o sincronización en tiempo real
  }
}
```

---

## 3. 📂 Organización de Archivos en la Capa Presentation

Dentro de cada macro-dominio o submódulo (`lib/modules/<macro>/<feature>/presentation/`):

```text
presentation/
├── controllers/                   # BLoC, Cubit o ValueNotifiers de la feature
├── screens/                       # Pantallas completas navegables (ej. run_tracking_screen.dart)
└── widgets/                       # Widgets reutilizables o promovidos (>250-300 líneas)
    ├── tracking_timer_card.dart
    └── tracking_action_buttons.dart
```

### Reglas de Importación y Visibilidad
- **Widgets exclusivos:** Si un widget solo lo usa una pantalla y tiene menos de 250 líneas, permanece como clase privada (`_NombreWidget`) en el mismo archivo bajo la *Stepdown Rule*.
- **Widgets de submódulo:** Si el archivo supera las 250 líneas o el widget es compartido por varias pantallas de la misma feature, se ubica en `presentation/widgets/`.
- **Widgets globales:** Si el componente es transversal a toda la aplicación (ej. botones primarios corporativos, loaders, app bar global), se ubica en `lib/shared/widgets/`.

---

## 4. 📋 Checklist para Pull Requests en Presentation

Antes de aprobar un cambio en la capa de presentación, verificar:
- [ ] ¿Los widgets están extraídos en clases `StatelessWidget`/`StatefulWidget` y no en métodos tipo `Widget _build...()`?
- [ ] ¿Se aplica la *Stepdown Rule* (widget público arriba, widgets privados abajo en orden de aparición)?
- [ ] ¿El archivo tiene menos de 250-300 líneas o se extrajeron los widgets auxiliares a `presentation/widgets/`?
- [ ] ¿Todo `TextEditingController`, `FocusNode` o `ScrollController` es liberado en `dispose()`?
- [ ] ¿`super.dispose()` está ubicado al final del método?
- [ ] ¿Las propiedades estáticas de diseño (bordes, decoraciones fijas) están fuera del método `build()`?
- [ ] ¿Todos los constructores de widgets usan `const` cuando es posible?
- [ ] ¿Se utiliza `require_trailing_commas` en todas las listas de parámetros y árboles de widgets?
- [ ] ¿No se utiliza `print` en producción (usar logs si es necesario)?
