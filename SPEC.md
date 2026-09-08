# SPEC — Just In Time
### La lógica de negocio del juego de mecanografía para programadores

> Este documento describe **qué es el producto y cómo se comporta**, no cómo se construye. No contiene arquitectura, stacks, esquemas de base de datos ni contratos de API. Es la fuente de verdad conceptual: cualquier decisión de diseño o de implementación debe poder trazarse a una regla escrita aquí.

---

## Índice

0. [Resumen ejecutivo](#0-resumen-ejecutivo)
1. [Visión y principios de producto](#1-visión-y-principios-de-producto)
2. [Público objetivo y casos de uso](#2-público-objetivo-y-casos-de-uso)
3. [El contenido: código real como material de práctica](#3-el-contenido-código-real-como-material-de-práctica)
4. [El núcleo del producto: el sistema de métricas](#4-el-núcleo-del-producto-el-sistema-de-métricas)
5. [Modos de juego](#5-modos-de-juego)
6. [Progresión individual: XP, niveles y currícula](#6-progresión-individual-xp-niveles-y-currícula)
7. [Cuentas y perfiles](#7-cuentas-y-perfiles)
8. [Modo offline vs. online y sincronización](#8-modo-offline-vs-online-y-sincronización)
9. [Competencia 1 vs 1: Duelos](#9-competencia-1-vs-1-duelos)
10. [Escuadrones y competencia grupal](#10-escuadrones-y-competencia-grupal)
11. [Leaderboards y clasificaciones](#11-leaderboards-y-clasificaciones)
12. [Logros, insignias y retención](#12-logros-insignias-y-retención)
13. [Multiplataforma: paridad y reglas por plataforma](#13-multiplataforma-paridad-y-reglas-por-plataforma)
14. [Integridad, anti-trampas y confianza en los datos](#14-integridad-anti-trampas-y-confianza-en-los-datos)
15. [Privacidad y propiedad de los datos](#15-privacidad-y-propiedad-de-los-datos)
16. [Modelo de negocio (propuesta)](#16-modelo-de-negocio-propuesta)
17. [Métricas de éxito del producto (KPIs)](#17-métricas-de-éxito-del-producto-kpis)
18. [Fuera de alcance en v1 / Roadmap futuro](#18-fuera-de-alcance-en-v1--roadmap-futuro)
19. [Glosario](#19-glosario)

---

## 0. Resumen ejecutivo

**Just In Time** es un juego de mecanografía diseñado específicamente para programadores. A diferencia de las apps de mecanografía genéricas (que usan frases aleatorias, citas o texto literario), el material de práctica es **código real** — empezando por Go — de modo que el usuario entrena el músculo que realmente usa en su trabajo: escribir `func`, `if err != nil {`, llaves, dos puntos, guiones bajos, paréntesis anidados y operadores, no prosa.

El diferenciador del producto no es "otro juego de teclear rápido": es la **profundidad y calidad de la metadata** que se captura de cada sesión — tiempo por carácter, dedo usado, velocidad por cadena de caracteres, consistencia, errores por tipo — convertida en información accionable para que el usuario entienda *exactamente* qué le cuesta trabajo y por qué.

El producto vive en dos planos que conviven sin fricción:
- **Un plano personal y offline**: práctica, estadísticas propias, progresión, sin necesitar red.
- **Un plano social y online**: duelos 1 vs 1, escuadrones, torneos y leaderboards globales, sincronizados en tiempo real.

Todo esto sobre una identidad de usuario mínima (solo *username*, sin correo, sin datos personales) y una operación de bajo costo que permita mantener el producto vivo indefinidamente sin depender de infraestructura cara.

---

## 1. Visión y principios de producto

**Visión:** convertirse en el lugar donde un programador entrena la mecanografía de la misma forma en que un atleta entrena con datos — con métricas precisas, progresión visible y competencia social — usando el material que de verdad importa: código.

**Principios rectores** (toda decisión de producto debe respetar estos principios; si algo los contradice, se replantea):

1. **Contenido real, no relleno.** Nunca se practica con lorem ipsum ni frases genéricas. Siempre es código Go real y sintácticamente válido — de proyectos reales o escrito por humanos que dominan el lenguaje.
2. **La métrica es el producto.** La velocidad final (PPM/WPM) es solo la punta del iceberg. El valor real está en el desglose: por carácter, por dedo, por combinación de teclas, por tramo de la sesión. Si una feature no genera o no usa esa metadata, se cuestiona su prioridad.
3. **Simplicidad de identidad.** Nadie debe dar su correo, su nombre real ni completar un formulario para jugar. Un *username* (y opcionalmente una contraseña) es suficiente.
4. **Offline primero, online cuando suma.** El modo individual nunca debe depender de la red. La red se usa exclusivamente para lo que *necesita* de otras personas: duelos, equipos y rankings globales.
5. **Elegante y minimalista.** Sin ruido visual, sin fricción de onboarding, sin pantallas que no aporten a "quiero mejorar mi velocidad y precisión escribiendo código".
6. **Bajo costo, alta velocidad.** El diseño del producto (no solo la tecnología) evita features que exijan infraestructura cara: nada de streaming de video, nada de matchmaking masivo tipo shooter, nada de cómputo pesado en servidor. Todo dato pesado (la metadata detallada) se procesa y almacena de forma barata y se sincroniza de forma ligera.
7. **La competencia debe sentirse justa.** Un leaderboard sin confianza no vale nada. Toda regla de puntuación y de ranking existe también pensando en que sea difícil de falsear.

---

## 2. Público objetivo y casos de uso

**Público primario:** programadores de cualquier nivel que quieren escribir código más rápido y con menos errores, con foco inicial en el ecosistema **Go**.

Segmentos concretos:

- **Estudiantes / bootcamps de Go**: aprenden sintaxis mientras entrenan el teclado. Los instructores pueden agrupar a su cohorte en un escuadrón.
- **Desarrolladores junior**: quieren dejar de "cazar" el símbolo `{`, `:=`, `&`, o corregir todo el tiempo con backspace.
- **Desarrolladores senior**: usan el modo competitivo (duelos, leaderboard) como entretenimiento y prueba de destreza — el equivalente a un ejercicio de "code golf" de velocidad de tecleo.
- **Equipos de trabajo**: compiten como escuadrón por diversión interna (retos semanales entre compañeros), como team-building.
- **Streamers / comunidad**: duelos en vivo y rankings públicos generan contenido compartible ("le gané a X con 142 PPM y 99.2% de precisión").

**Casos de uso clave que el producto debe resolver bien:**

1. "Quiero calentar 5 minutos antes de programar." → Modo Zen/Práctica offline, rápido de iniciar.
2. "Quiero saber en qué exactamente soy malo." → Reporte de debilidades (caracteres, dedos, combinaciones).
3. "Quiero medirme contra otros ahora mismo." → Duelo 1 vs 1 con matchmaking instantáneo.
4. "Quiero que mi equipo compita esta semana." → Escuadrones con reto semanal y tabla interna.
5. "Quiero ver dónde quedo en el mundo." → Leaderboard global, filtrable.
6. "Quiero seguir mejorando sin conexión, en el tren, en el avión." → Todo el modo individual funciona 100% offline y sincroniza después.

---

## 3. El contenido: código real como material de práctica

### 3.1 Naturaleza del contenido

Todo el material de escritura es **código Go real, correcto y compilable en su contexto** (no fragmentos rotos ni pseudocódigo). El contenido se organiza en **snippets**: bloques de código de longitud controlada, cada uno etiquetado con:

- **Lenguaje** (Go en v1; el modelo de contenido está pensado para añadir otros lenguajes a futuro, ver §18).
- **Nivel de dificultad**: Principiante, Intermedio, Avanzado, Experto.
- **Categoría temática / constructo**: variables y tipos, condicionales, ciclos, funciones, structs, interfaces, slices y maps, manejo de errores, punteros, concurrencia (goroutines/channels), genéricos, formato idiomático (`gofmt`).
- **Foco de símbolos**: algunos snippets están diseñados específicamente para forzar la práctica de un símbolo o combinación difícil (llaves anidadas, `:=`, comillas backtick para tags de struct, operadores `&&`/`||`, punteros `*`/`&`, generics `[T any]`).
- **Longitud**: Corto (una línea o firma de función), Medio (un bloque/función completa), Largo (un archivo pequeño o varias funciones relacionadas).

### 3.2 Curación y calidad

- El contenido inicial es **curado**, no generado al vuelo: proviene de código idiomático real (librería estándar de Go, proyectos open source reconocidos, o escrito por editores humanos que siguen las convenciones oficiales de estilo de Go).
- Cada snippet pasa una validación de que es sintácticamente correcto en su contexto antes de entrar al catálogo.
- El catálogo crece con el tiempo; nuevos snippets se pueden agregar sin afectar el progreso ya registrado de los usuarios (un snippet es una unidad de contenido versionada e inmutable una vez publicada — si se corrige, se publica como una revisión nueva).

### 3.3 Selección de snippet para una sesión

La app puede elegir el snippet de tres formas, según el modo de juego:

1. **Elección manual**: el usuario navega el catálogo por categoría/dificultad y elige qué practicar.
2. **Selección inteligente ("Lección recomendada")**: el sistema prioriza snippets que contienen los caracteres, símbolos o combinaciones donde el usuario tiene peor desempeño histórico (ver §4). Esto convierte la metadata en currícula personalizada de forma automática.
3. **Snippet fijo compartido**: en Duelos, Retos Diarios y eventos de Escuadrón, todos los participantes reciben **exactamente el mismo snippet**, para que la comparación sea justa.

---

## 4. El núcleo del producto: el sistema de métricas

Esta es la parte más importante del negocio: **el valor percibido del producto depende directamente de qué tan rica, precisa y útil es la metadata** que se le devuelve al usuario. Todo lo demás (modos de juego, competencia, leaderboards) es una capa construida sobre estos datos.

### 4.1 Qué se captura durante cada sesión

Mientras el usuario escribe un snippet, el sistema registra, **carácter por carácter**:

- **Carácter esperado** vs. **carácter realmente tecleado** (para poder distinguir aciertos de distintos tipos de error).
- **Tiempo de permanencia** de la tecla (cuánto se tarda en pulsar y soltar, cuando la plataforma lo permite medir).
- **Tiempo de vuelo** entre una tecla y la siguiente (el intervalo que realmente define el ritmo de tecleo).
- **Resultado**: acierto, error por sustitución (tecleó otro carácter), error por omisión (se saltó un carácter), error por inserción (agregó uno de más), error por transposición (invirtió el orden de dos caracteres consecutivos).
- **Correcciones**: cada uso de retroceso/borrado se registra como evento propio, distinto de un error "dejado pasar". Corregir mucho y corregir poco cuentan historias distintas sobre el usuario.
- **Dedo y mano asignados a esa tecla**, según el estándar de mecanografía táctil (incluyendo variantes con Shift para símbolos y mayúsculas). Esto permite saber no solo *qué* tecla falló, sino *qué dedo* es el responsable.
- **Fila del teclado** involucrada (fila numérica, superior, home row, inferior) — útil para detectar si el usuario tiene problemas por alejarse de la fila base.

### 4.2 Qué se calcula a partir de eso (la metadata de valor)

A partir de los eventos crudos de cada sesión, el sistema deriva:

- **Velocidad bruta y neta**: caracteres/palabras por minuto contando todo lo tecleado (bruta) vs. contando solo lo correcto ya corregido al final (neta). Ambas se muestran, porque cuentan historias distintas (alguien puede ser "rápido pero sucio").
- **Precisión**: porcentaje de caracteres correctos a la primera, sin contar correcciones.
- **Perfil por carácter**: para cada carácter individual (letras, dígitos, y muy especialmente los símbolos de programación: `{ } ( ) [ ] < > _ - = + * & | : ; ' " \ / ~ ^ % $ # @ !`), un histórico de velocidad promedio, tasa de error y tendencia (mejorando/empeorando/estable).
- **Perfil por dedo y por mano**: qué dedo comete más errores, qué dedo es más lento, y el **balance de carga entre mano izquierda y derecha** (un desbalance fuerte es una señal de que el usuario compensa con una mano y descuida la otra).
- **Encadenamientos (n-gramas)**: tiempos y tasas de error para combinaciones de 2 y 3 caracteres que aparecen frecuentemente en código Go idiomático (por ejemplo `:=`, `{}`, `()`, `err`, `if `, `func `, `nil`, `->` en comentarios, `//`, el salto entre mayúscula y minúscula en camelCase, el salto hacia/desde `_` en snake_case). Estas combinaciones son justamente las que distinguen a este producto de una app de mecanografía genérica: son los patrones reales de un programador, no de un escritor de prosa.
- **Transiciones entre teclas ("conexiones")**: además de los n-gramas de contenido, se mide el costo de moverse entre teclas específicas del teclado (por ejemplo, salir de la fila base hacia la fila numérica para escribir un símbolo, o alternar entre manos), independientemente de qué letra sea — esto identifica problemas de trayectoria física del dedo, no solo de memoria del símbolo.
- **Consistencia / ritmo**: qué tan uniforme es el tecleo (baja varianza = ritmo estable y controlado; alta varianza = tecleo errático, aunque el promedio sea alto). Se prioriza la consistencia como señal de dominio real por encima del pico de velocidad puntual.
- **Curva de fatiga**: comparación de desempeño entre el primer tercio, el tercio medio y el último tercio de una sesión larga, para detectar caída de rendimiento por cansancio o pérdida de foco.
- **Rachas (combos)**: número de caracteres consecutivos correctos sin error. Una racha rota reinicia el contador. Las rachas alimentan tanto el reporte de precisión como mecánicas de juego (bonus de puntaje, ver §5 y §6).
- **Mapa de calor del teclado**: representación de qué teclas se usan más, cuáles son más lentas y cuáles fallan más, agregada en el tiempo.

### 4.3 Cómo se usa esta metadata en el producto

La metadata no es solo un reporte bonito: alimenta decisiones activas del producto:

- **Currícula personalizada**: recomienda automáticamente qué practicar (ver §3.3 y §6.3).
- **Diagnóstico de debilidades**: una pantalla de "tus 10 puntos débiles" (caracteres, dedos y combinaciones) siempre visible, que cambia con el tiempo.
- **Puntaje de sesión**: la fórmula de puntaje de cada modo de juego pondera velocidad, precisión y consistencia — nunca solo velocidad — para que un jugador no pueda "ganar" tecleando sin cuidado (ver detalle de fórmulas por modo en §5).
- **Comparación histórica personal**: cada sesión se compara contra el promedio propio de las últimas N sesiones del mismo snippet o categoría, mostrando progreso real (no solo contra otros usuarios).
- **Certificación de dominio**: cuando el perfil de un carácter, dedo o combinación se mantiene por encima de un umbral de velocidad y precisión durante varias sesiones consecutivas, se marca como "dominado" — esto es lo que desbloquea contenido de mayor dificultad (ver §6).

---

## 5. Modos de juego

Todos los modos comparten el mismo motor de captura de metadata (§4); lo que cambia es el objetivo, la presión de tiempo y si involucran a otras personas.

### 5.1 Zen / Práctica libre *(individual, offline)*
Sin límite de tiempo, sin presión. El usuario elige un snippet o deja que el sistema le recomiende uno según sus debilidades. Ideal para calentar antes de programar o para trabajar un punto débil específico. Se registra toda la metadata igual que en cualquier otro modo.

### 5.2 Sprint cronometrado *(individual, offline)*
Ventana de tiempo fija (ej. 30s / 60s / 120s). El objetivo es maximizar caracteres correctos netos dentro del tiempo. Los errores no corregidos penalizan el resultado neto. Este modo prioriza velocidad bajo presión.

### 5.3 Prueba de precisión *(individual, offline)*
Snippet fijo que hay que completar por encima de un umbral mínimo de precisión (ej. 98%) para "aprobar". Si el usuario cae por debajo del umbral, puede reintentar. Este modo es la base del sistema de certificación de dominio (§4.3, §6.4): aprobarlo repetidamente con distintos snippets de una categoría es lo que certifica que el usuario "domina" esa categoría.

### 5.4 Reto Diario *(online, un intento contado por día)*
Todos los usuarios del mundo reciben el **mismo snippet** cada día. Aporta a un leaderboard diario específico (§11) y a una racha de días consecutivos jugados (streak), que es uno de los principales ganchos de retención. Puede jugarse offline si no hay señal, pero el resultado solo cuenta para el ranking diario si se sincroniza dentro de la ventana de ese día; fuera de esa ventana, la sesión se guarda igualmente en el historial personal pero no en el ranking.

### 5.5 Duelo 1 vs 1 *(online, tiempo real)*
Dos jugadores compiten en vivo con el mismo snippet. Ver desarrollo completo en §9.

### 5.6 Retos de Escuadrón *(online, grupal)*
Eventos con ventana de tiempo (ej. una semana) donde los miembros de un mismo equipo acumulan puntaje colectivo. Ver desarrollo completo en §10.

### 5.7 Rutas de aprendizaje / Currícula guiada *(individual, offline con progreso sincronizable)*
Secuencias ordenadas de lecciones y snippets con un objetivo pedagógico explícito (ej. "Fundamentos de sintaxis Go", "Manejo de errores idiomático", "Concurrencia sin miedo"). Se desbloquean en orden; cada lección se marca completa según el criterio de la Prueba de Precisión (§5.3). Pensado especialmente para bootcamps y autoestudio estructurado.

---

## 6. Progresión individual: XP, niveles y currícula

### 6.1 Experiencia (XP)
Cada sesión completada otorga XP en función de: caracteres correctos tecleados, precisión alcanzada, dificultad del snippet, y si es la primera vez que se completa ese snippet (bono de primera vez). Rachas de días jugados otorgan un bono adicional. El XP es acumulativo y nunca se pierde (no hay penalización de XP por bajo desempeño, solo menor ganancia).

### 6.2 Niveles
El XP acumulado define un **nivel de cuenta** (progresión de largo plazo, sin techo). Subir de nivel:
- Desbloquea acceso a categorías de contenido de mayor dificultad (Intermedio, Avanzado, Experto).
- Desbloquea cosméticos (ver §16).
- Es puramente una medida de dedicación/trayectoria, **no de habilidad** — para eso existe el rating de habilidad (§6.5 y §9.2), que es independiente.

### 6.3 Currícula personalizada
El sistema mantiene, por usuario, un ranking interno de "puntos débiles" (caracteres, dedos, n-gramas) derivado de §4.2. La sección "Recomendado para ti" prioriza snippets que contienen esos puntos débiles con mayor densidad, de forma que practicar lo recomendado tenga el mayor impacto posible por minuto invertido.

### 6.4 Certificación de dominio
Cuando el desempeño en una categoría (ej. "manejo de errores") se mantiene consistentemente por encima de los umbrales de velocidad y precisión definidos para el nivel de dificultad correspondiente, la categoría se marca como **dominada** para ese usuario. El dominio:
- Es informativo (aparece en el perfil como logro de progreso).
- Puede ser requisito para acceder a snippets de la siguiente dificultad dentro de una ruta de aprendizaje guiada (§5.7).
- Puede degradarse con el tiempo si el desempeño posterior cae de forma sostenida por debajo del umbral (para que "dominado" siga significando algo actual, no un logro congelado en el pasado).

### 6.5 Rating de habilidad (independiente del nivel)
Separado del XP/nivel, existe un **rating de habilidad** que solo se ve afectado por resultados competitivos (Duelos y eventos de Escuadrón). Es la base del matchmaking y de las ligas competitivas. Ver detalle en §9.2 y §11.4.

---

## 7. Cuentas y perfiles

El principio de identidad del producto es: **la mínima fricción y la mínima información posible**. Nunca se pide correo electrónico ni datos personales. Existen exactamente dos tipos de perfil:

### 7.1 Perfil de Invitado (solo *username*, sin contraseña)
- El usuario elige un nombre visible y empieza a jugar de inmediato.
- Vive únicamente en el dispositivo donde se creó: no hay forma de recuperarlo ni de iniciar sesión con esa identidad desde otro dispositivo, porque no existe contraseña que lo proteja.
- Tiene acceso completo a los modos individuales (Zen, Sprint, Precisión, Rutas de aprendizaje) y a toda la metadata y progreso personal, de forma local.
- **No participa en Duelos, Escuadrones ni leaderboards globales/online**, porque esas funciones dependen de una identidad persistente y verificable entre dispositivos y sesiones. Si aplica, puede ver un leaderboard "local" (solo comparándose contra sus propias sesiones anteriores).
- Pensado para quien solo quiere probar el producto o practicar de forma casual sin comprometerse a nada.

### 7.2 Cuenta Registrada (*username* + contraseña, sin correo)
- El usuario elige un *username* único en toda la plataforma y define una contraseña. No se solicita correo ni ningún otro dato personal.
- Como no hay correo para recuperar contraseña, al crear la cuenta se le entrega al usuario un **código de recuperación de un solo uso** que debe guardar por su cuenta; es el único mecanismo para recuperar acceso si olvida su contraseña. Este es el único costo de la privacidad radical del producto, y se comunica claramente al usuario en el momento de crear la cuenta.
- Habilita:
  - Inicio de sesión desde cualquier dispositivo/plataforma, con el mismo progreso y estadísticas.
  - Participación en Duelos 1 vs 1, Escuadrones y todos los leaderboards.
  - Copia de respaldo en la nube de todo su historial y metadata.
- **Migración desde Invitado**: un usuario que empezó como Invitado puede convertir su perfil en Cuenta Registrada en cualquier momento sin perder su progreso — su historial local se adjunta a la nueva cuenta en el momento de la conversión.

### 7.3 Qué contiene un perfil (información visible)
- Username, avatar/cosméticos elegidos, nivel y XP, rating de habilidad y liga actual, racha de días activos, insignias/logros obtenidos, resumen de estadísticas históricas (velocidad promedio, precisión promedio, total de caracteres escritos en la vida del usuario), escuadrón al que pertenece (si aplica).
- No hay nombre real, correo, ni ningún identificador personal en ninguna parte del perfil.

---

## 8. Modo offline vs. online y sincronización

### 8.1 Qué funciona sin conexión
Todo lo individual: Zen, Sprint, Precisión, Rutas de aprendizaje, Reto Diario (jugable offline aunque su cómputo para el ranking dependa de sincronizar a tiempo), y absolutamente toda la captura y el cálculo de metadata (§4). El usuario nunca debe sentir que "necesita internet para practicar".

### 8.2 Qué requiere conexión
Todo lo social/competitivo: Duelos en vivo, actividad de Escuadrón, y la publicación/consulta de leaderboards globales, regionales o de escuadrón. También el login de una Cuenta Registrada en un dispositivo nuevo.

### 8.3 Cómo se sincroniza
- Cada sesión de práctica es un **evento cerrado e inmutable**: ocurrió, con un resultado y una metadata fija, en un momento dado. Cuando el dispositivo recupera conexión, esos eventos pendientes se envían y se agregan al historial de la cuenta en la nube.
- Como cada sesión es un evento independiente (no un documento que dos dispositivos puedan editar a la vez), **no existen conflictos de sincronización en el sentido tradicional**: no hay nada que "fusionar", solo eventos que se agregan a una línea de tiempo. Dos sesiones jugadas offline en dos dispositivos distintos simplemente se suman ambas al historial cuando cada una sincroniza.
- Las estadísticas agregadas (totales, promedios, nivel, XP) siempre se recalculan a partir del historial completo de eventos, nunca se sobrescriben manualmente — esto es lo que garantiza que la cuenta nunca "pierda" progreso por reinstalar la app o cambiar de dispositivo, siempre que sea una Cuenta Registrada.
- Un Perfil de Invitado no sincroniza nada: su historial vive y muere con el dispositivo, por diseño (ver §7.1).
- Resultados de Reto Diario, Duelos o eventos de Escuadrón que dependían de una ventana de tiempo específica y llegan fuera de esa ventana (por haberse jugado offline y sincronizado tarde) se conservan en el historial personal del usuario pero **no alteran retroactivamente un ranking ya cerrado**.

---

## 9. Competencia 1 vs 1: Duelos

### 9.1 Flujo de un duelo
1. El usuario (con Cuenta Registrada) entra a la cola de Duelo.
2. El sistema empareja a dos jugadores de rating de habilidad similar (ver §9.2). Si no hay match disponible en un tiempo razonable, el rango de emparejamiento se amplía progresivamente para no dejar al usuario esperando indefinidamente.
3. Ambos jugadores reciben el mismo snippet al mismo tiempo y ven una cuenta regresiva de salida compartida.
4. Durante la carrera, cada jugador ve su propio progreso y una representación del avance del oponente (posición relativa dentro del snippet), en tiempo real.
5. Gana quien completa el snippet primero **cumpliendo un umbral mínimo de precisión** (para que no gane quien tecleó basura a máxima velocidad). Si ninguno alcanza el umbral de precisión al terminar, gana quien tenga la mejor combinación de velocidad y precisión según la fórmula de puntaje del modo.
6. Al finalizar, ambos jugadores ven el desglose comparativo de metadata (quién fue más rápido en qué tramo, quién cometió más errores y en qué caracteres), no solo qué el resultado final.

### 9.2 Rating de habilidad y emparejamiento
- Cada Cuenta Registrada tiene un rating de habilidad competitivo (independiente del nivel/XP, ver §6.5), que solo cambia con resultados de Duelos (y opcionalmente eventos competitivos de Escuadrón, ver §10.3).
- Ganar un duelo contra un rival de rating similar aporta más rating que ganarle a alguien mucho más débil; perder contra alguien mucho más fuerte resta poco.
- El rating decae ligeramente por inactividad prolongada, para que el leaderboard competitivo refleje habilidad *actual*, no solo histórica.

### 9.3 Reglas de integridad del duelo
- Si un jugador se desconecta antes de que el otro termine, el jugador restante gana automáticamente, salvo que su propio progreso al momento de la desconexión del rival sea tan bajo que el resultado se considere no concluyente — en ese caso, el duelo se anula y no afecta el rating de ninguno de los dos.
- Un jugador no puede abandonar un duelo repetidamente sin consecuencia: abandonos frecuentes penalizan el rating de forma similar a una derrota, para desincentivar el "esquive" de rivales difíciles.
- Revancha: al finalizar, ambos jugadores pueden aceptar una revancha inmediata contra el mismo rival, o volver a la cola general.

### 9.4 Ligas competitivas
El rating de habilidad ubica a cada jugador en una **liga** (ej. Bronce, Plata, Oro, Platino, Diamante, y una liga superior de prestigio con nombre propio del producto). Las ligas:
- Se organizan en **temporadas** (ej. trimestrales). Al cerrar una temporada, el rating se comprime parcialmente hacia el centro (soft reset) para que cada temporada nueva sea competitiva desde el inicio, sin borrar por completo el progreso histórico.
- Otorgan una recompensa cosmética exclusiva de la temporada según la liga alcanzada (ver §16), nunca ventajas de juego.

---

## 10. Escuadrones y competencia grupal

### 10.1 Qué es un Escuadrón
Un grupo de Cuentas Registradas que se identifican como equipo: un salón de bootcamp, un equipo de trabajo, un grupo de amigos. Tiene nombre, ícono/color, visibilidad (público, privado o solo por invitación) y un límite razonable de miembros.

### 10.2 Roles y administración
- **Fundador**: crea el escuadrón, puede transferir su rol, tiene control total.
- **Administrador**: puede gestionar miembros e invitaciones, no puede disolver el escuadrón ni remover al fundador.
- **Miembro**: participa en la actividad y los retos del escuadrón.
- Unirse es posible por código de invitación o, si el escuadrón es público, descubriéndolo y solicitando ingreso.

### 10.3 Actividad competitiva de un Escuadrón
- **Tabla interna**: ranking de los miembros del propio escuadrón por XP, caracteres escritos o rating, para fomentar competencia sana puertas adentro.
- **Retos semanales de escuadrón**: durante una ventana de tiempo, cada miembro contribuye con su mejor desempeño (o la suma de sus sesiones) en un conjunto de snippets del reto; el escuadrón acumula un puntaje colectivo.
- **Escuadrón vs. Escuadrón**: enfrentamientos directos entre dos o más equipos en la misma ventana de reto, comparando el puntaje colectivo resultante. El equipo ganador recibe una insignia de temporada; el mejor contribuyente individual dentro del equipo ganador se destaca como MVP del reto.
- Estas dinámicas están pensadas explícitamente para instructores de bootcamp (cohortes compitiendo entre sí) y para equipos de trabajo (competencia interna amistosa).

---

## 11. Leaderboards y clasificaciones

### 11.1 Dimensiones de un leaderboard
Todo leaderboard se define por una combinación de:
- **Alcance**: Global, Regional/País, Escuadrón, Amigos.
- **Modo**: Sprint, Precisión, Rating de Duelos, Reto Diario.
- **Categoría de contenido**: por dificultad o por categoría temática de snippet (ej. "mejores en concurrencia").
- **Ventana de tiempo**: Diario, Semanal, Mensual, Histórico (all-time), Temporada (para el rating competitivo).

### 11.2 Métrica de ranking por tipo de leaderboard
- **Sprint**: mayor cantidad de caracteres netos correctos en una sola corrida, exigiendo un mínimo de precisión para calificar (evita que alguien "gane" tecleando basura muy rápido).
- **Precisión**: mejor combinación de precisión y luego velocidad como desempate.
- **Duelos / Competitivo**: rating de habilidad de temporada (§9.2, §9.4).
- **Reto Diario**: mejor puntaje del día según la fórmula de Sprint o Precisión aplicada al snippet del día (definido por el propio Reto Diario), con el desempate por tiempo total.

### 11.3 Requisitos para calificar
Para evitar que resultados triviales ensucien un leaderboard: existe una longitud mínima de snippet y un mínimo de precisión para que una corrida sea elegible a aparecer en un ranking. Corridas por debajo de esos mínimos cuentan para las estadísticas personales del usuario, pero no compiten por posición.

### 11.4 Relación entre rating competitivo y leaderboard "casual"
El leaderboard competitivo (basado en rating de Duelos) y los leaderboards de Sprint/Precisión son **independientes**: alguien puede ser extremadamente rápido en solitario pero no destacar en Duelos (o viceversa), y ambos logros son válidos y visibles por separado.

---

## 12. Logros, insignias y retención

- **Insignias de hito**: por ejemplo, completar una sesión sin ningún error ("Cero Errores"), alcanzar cierta velocidad sostenida, escribir una cantidad acumulada de caracteres en la vida del usuario ("Maratonista"), lograr balance casi perfecto entre ambas manos ("Ambidiestro"), dominar todas las categorías de una dificultad.
- **Rachas (streaks) de días activos**: jugar el Reto Diario (o cualquier sesión) en días consecutivos construye una racha visible en el perfil; romperla la reinicia. Es uno de los principales mecanismos de retención diaria.
- **Insignias de temporada competitiva**: ligadas a la liga alcanzada al cierre de cada temporada (§9.4) y a resultados de Escuadrón vs. Escuadrón (§10.3).
- Todas las insignias son de prestigio/cosméticas: nunca otorgan ventajas de juego, para no contaminar la integridad competitiva del producto (principio #7, §1).

---

## 13. Multiplataforma: paridad y reglas por plataforma

### 13.1 Paridad de cuenta y progreso
Una Cuenta Registrada tiene exactamente el mismo progreso, estadísticas, rating y contenido desbloqueado sin importar si el usuario juega desde Android, Windows, Linux de escritorio o Web. La expectativa de negocio es "empiezo en la laptop del trabajo, sigo en el celular en el camión".

### 13.2 Regla especial para dispositivos móviles/táctiles
La medición de dedo, mano y trayectoria física (§4.1–4.2) asume un teclado físico estándar. Escribir con un teclado táctil en pantalla mide algo fundamentalmente distinto (no hay dedos fijos por tecla, no hay fila base). Por lo tanto:
- En Android (y cualquier plataforma sin teclado físico detectado), el producto favorece fuertemente el uso de un teclado físico o Bluetooth conectado al dispositivo para cualquier sesión que vaya a contar para leaderboards, Duelos o el rating competitivo.
- Si el usuario juega con teclado táctil en pantalla, sus sesiones se registran en una categoría separada ("Modo táctil"), con sus propias estadísticas y, si aplica, su propio leaderboard — nunca se mezclan con las métricas ni rankings de teclado físico, para no distorsionar ni el diagnóstico personal (dedo/mano no aplican igual) ni la integridad de la competencia.

### 13.3 Disponibilidad de modos por plataforma
Todos los modos individuales y todo el sistema de metadata están disponibles en todas las plataformas soportadas. Los modos sociales (Duelos, Escuadrones, leaderboards online) requieren conexión, independientemente de la plataforma, pero están igualmente disponibles en todas ellas — no hay una plataforma "de segunda categoría".

---

## 14. Integridad, anti-trampas y confianza en los datos

Dado que el corazón del producto es la comparación (contra uno mismo y contra otros), la confianza en los datos es un requisito de negocio, no un detalle técnico:

- **Límites de plausibilidad humana**: cualquier resultado que exceda umbrales de velocidad/precisión humanamente plausibles se marca automáticamente para revisión y se excluye de los leaderboards mientras no se confirme como válido.
- **Snippets fijos y sincronizados** en toda situación comparativa (Duelos, Reto Diario, eventos de Escuadrón) — nadie compite con un texto más fácil que otro.
- **Requisitos mínimos de calificación** (§11.3) para evitar manipular rankings con corridas triviales.
- **Separación de categorías de entrada** (teclado físico vs. táctil, §13.2) para que la fuente del dato no distorsione la comparación.
- La confianza del leaderboard es, en última instancia, lo que sostiene todo el valor social/competitivo del producto — si se percibe como manipulable, esa parte del producto pierde su propósito.

---

## 15. Privacidad y propiedad de los datos

- **Dato mínimo necesario**: username y (si aplica) contraseña. Nunca correo, nombre real, teléfono ni cualquier otro identificador personal.
- **El usuario es dueño de su metadata**: toda la información detallada de tecleo (§4) le pertenece a quien la generó. El usuario puede consultar y exportar su propio historial y reporte de progreso en cualquier momento.
- **Nada de la metadata detallada de un usuario se expone públicamente** más allá de lo que el propio usuario decide mostrar en su perfil (resúmenes, insignias, posición en leaderboards). El detalle carácter-por-carácter es siempre privado.
- Un Perfil de Invitado que nunca se convierte en Cuenta Registrada simplemente deja de existir si se desinstala la app o se borran los datos locales — no hay copia en ningún servidor de la que "borrar" nada, por diseño.

---

## 16. Modelo de negocio (propuesta)

*(El usuario del producto no especificó una estrategia de monetización explícita; esta sección es una propuesta razonable, coherente con los principios de bajo costo y elegancia del producto, y queda abierta a ajuste.)*

- **Núcleo gratuito para siempre**: todos los modos individuales, todo el sistema de metadata, Duelos, Escuadrones y leaderboards son gratuitos sin límites artificiales. La operación de bajo costo del producto (contenido curado una vez y reutilizado, comunicación en tiempo real eficiente, sin cómputo pesado) hace esto sostenible.
- **Nunca pagar para ganar**: ninguna compra afecta velocidad, precisión, rating o resultado de ninguna competencia. Esto es una decisión de negocio, no solo ética: un leaderboard percibido como comprable pierde todo su valor (ver §14).
- **Monetización cosmética opcional**: temas visuales, sonidos de tecleo, marcos de perfil, insignias decorativas alternativas — una vía de ingreso opcional para quien quiera apoyar el producto, sin fricción para quien no.
- **Sin publicidad**: contraria a la experiencia "elegante y rápida" que define al producto (principio #5, §1).

---

## 17. Métricas de éxito del producto (KPIs)

- **Usuarios activos diarios/semanales** que completan al menos una sesión.
- **Duración y frecuencia de sesión promedio** (¿la gente vuelve a calentar antes de programar, como se busca en el caso de uso principal?).
- **Tasa de finalización del Reto Diario** y longitud promedio de racha (streak) — proxy directo de retención diaria.
- **Duelos jugados por usuario activo por semana** — proxy de qué tan viva está la capa social/competitiva.
- **Porcentaje de usuarios que alcanzan hitos de fluidez** (ej. cierta velocidad sostenida con alta precisión y baja varianza) — proxy de que el producto efectivamente cumple su promesa central: enseñar a escribir código más rápido y con menos errores.
- **Tasa de conversión de Invitado a Cuenta Registrada** — indica si el valor social/competitivo es suficientemente atractivo como para que el usuario acepte crear una identidad persistente.
- **Retención de escuadrones activos** (¿los equipos siguen compitiendo semana a semana?) — proxy de la salud del caso de uso de bootcamps/equipos.

---

## 18. Fuera de alcance en v1 / Roadmap futuro

Explícitamente fuera del alcance inicial, para mantener el producto enfocado:

- Lenguajes de programación distintos a Go (el modelo de contenido de §3 está diseñado para poder añadir Python, JavaScript, Rust, etc. más adelante, pero v1 se concentra solo en Go).
- Contenido generado automáticamente/por IA como sustituto del código real curado (contradice el principio #1, §1).
- Chat de voz o video dentro de Duelos o Escuadrones.
- Torneos con premios en dinero real.
- Herramientas de administración empresarial/corporativa avanzadas más allá de la gestión básica de un Escuadrón (roles, invitaciones).
- Cualquier forma de ventaja pagada dentro del juego (ver §16 — esto no es "fuera de alcance por ahora", es una exclusión permanente).

---

## 19. Glosario

- **Snippet**: unidad de código real usada como material de práctica.
- **Sesión**: una corrida completa de tecleo sobre un snippet, en cualquier modo.
- **Metadata de tecleo**: el conjunto de datos detallados (por carácter, por dedo, por combinación) capturados durante una sesión.
- **PPM / WPM neto vs. bruto**: velocidad contando solo lo correcto (neto) vs. contando todo lo tecleado incluyendo errores (bruto).
- **Racha (streak)**: caracteres consecutivos correctos sin error (dentro de una sesión) o días consecutivos jugando (a nivel de retención).
- **Rating de habilidad**: puntaje competitivo independiente del nivel/XP, usado para matchmaking y ligas.
- **Escuadrón**: grupo de Cuentas Registradas que compite y se organiza como equipo.
- **Perfil de Invitado / Cuenta Registrada**: los dos tipos de identidad de usuario soportados (§7).
- **Modo táctil**: categoría separada de sesiones jugadas sin teclado físico, con sus propias métricas y rankings.

