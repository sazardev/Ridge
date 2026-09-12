// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Ridge';

  @override
  String get splashSlogan => 'Escribe mejor, no solo más rápido.';

  @override
  String get navPractice => 'Práctica';

  @override
  String get navProgress => 'Progreso';

  @override
  String get navFreePractice => 'Libre';

  @override
  String get navProfile => 'Perfil';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get navRailCollapse => 'Colapsar navegación';

  @override
  String get navRailExpand => 'Expandir navegación';

  @override
  String get profileCreateTitle => 'Crea tu perfil';

  @override
  String get profileCreateSubtitle =>
      'Elige un nombre de usuario para empezar a practicar';

  @override
  String get profileUsernameLabel => 'Nombre de usuario';

  @override
  String get profileCreateStart => 'Empezar';

  @override
  String get profileUsernameInvalid =>
      'Ingresa un nombre de usuario de hasta 24 caracteres';

  @override
  String profileMemberSince(String date) {
    return 'Miembro desde $date';
  }

  @override
  String get profileSave => 'Guardar';

  @override
  String get profileEditProfileAction => 'Editar perfil';

  @override
  String get profileEditProfileTitle => 'Editar perfil';

  @override
  String get profileAchievementsAction => 'Ver logros';

  @override
  String get profileAchievementsTitle => 'Logros';

  @override
  String profileAchievementsCount(int count) {
    return '$count desbloqueados';
  }

  @override
  String get profileStatsTitle => 'Tu progreso';

  @override
  String get profileViewProgressAction => 'Ver progreso completo';

  @override
  String get profileAboutTitle => 'Sobre mí';

  @override
  String get profileAboutEmptyState =>
      'Agrega tus lenguajes favoritos, teclado y más para personalizar tu perfil';

  @override
  String get profileEditCustomizationAction => 'Personalizar perfil';

  @override
  String get profileFavoriteLanguageLabel => 'Lenguajes favoritos';

  @override
  String get profileKeyboardLayoutLabel => 'Distribución de teclado';

  @override
  String get profileKeyboardBrandLabel => 'Marca de teclado';

  @override
  String get profileKeyboardModelLabel => 'Modelo de teclado';

  @override
  String profileKeyboardShapePreviewSemanticLabel(String model) {
    return 'Vista previa de la forma del teclado para $model';
  }

  @override
  String get profileFavoriteProgrammerLabel =>
      'Programador o influencia favorita';

  @override
  String get profileFavoriteQuoteLabel => 'Frase favorita';

  @override
  String get profileCustomizationInvalid =>
      'No se pudo guardar — algún campo no es válido';

  @override
  String get profileSearchLanguageHint => 'Buscar lenguajes…';

  @override
  String get profileSearchNoResults =>
      'Ningún lenguaje coincide con tu búsqueda';

  @override
  String get profileLanguageShowMore => 'Más…';

  @override
  String get profileLinksTitle => 'Enlaces';

  @override
  String get profileGithubLabel => 'GitHub';

  @override
  String get profileGithubHint => 'Usuario o URL del perfil';

  @override
  String get profileWebsiteLabel => 'Página web personal';

  @override
  String get profileWebsiteHint => 'ejemplo.com';

  @override
  String get profileOpenLinkAction => 'Abrir en el navegador';

  @override
  String get profileDeviceTitle => 'Dispositivo';

  @override
  String get favoriteLanguageGo => 'Go';

  @override
  String get favoriteLanguagePython => 'Python';

  @override
  String get favoriteLanguageJavascript => 'JavaScript';

  @override
  String get favoriteLanguageTypescript => 'TypeScript';

  @override
  String get favoriteLanguageRust => 'Rust';

  @override
  String get favoriteLanguageC => 'C';

  @override
  String get favoriteLanguageCpp => 'C++';

  @override
  String get favoriteLanguageCsharp => 'C#';

  @override
  String get favoriteLanguageJava => 'Java';

  @override
  String get favoriteLanguageKotlin => 'Kotlin';

  @override
  String get favoriteLanguageSwift => 'Swift';

  @override
  String get favoriteLanguageRuby => 'Ruby';

  @override
  String get favoriteLanguagePhp => 'PHP';

  @override
  String get favoriteLanguageDart => 'Dart';

  @override
  String get favoriteLanguageLua => 'Lua';

  @override
  String get favoriteLanguageHaskell => 'Haskell';

  @override
  String get favoriteLanguageScala => 'Scala';

  @override
  String get favoriteLanguageElixir => 'Elixir';

  @override
  String get favoriteLanguageClojure => 'Clojure';

  @override
  String get favoriteLanguagePerl => 'Perl';

  @override
  String get favoriteLanguageR => 'R';

  @override
  String get favoriteLanguageObjectiveC => 'Objective-C';

  @override
  String get favoriteLanguageShell => 'Shell / Bash';

  @override
  String get favoriteLanguageSql => 'SQL';

  @override
  String get favoriteLanguageAssembly => 'Ensamblador';

  @override
  String get favoriteLanguageZig => 'Zig';

  @override
  String get favoriteLanguageNim => 'Nim';

  @override
  String get favoriteLanguageJulia => 'Julia';

  @override
  String get favoriteLanguageGroovy => 'Groovy';

  @override
  String get favoriteLanguageFsharp => 'F#';

  @override
  String get favoriteLanguageOcaml => 'OCaml';

  @override
  String get favoriteLanguageErlang => 'Erlang';

  @override
  String get favoriteLanguageCrystal => 'Crystal';

  @override
  String get favoriteLanguageSolidity => 'Solidity';

  @override
  String get favoriteLanguagePowershell => 'PowerShell';

  @override
  String get favoriteLanguageLisp => 'Lisp';

  @override
  String get favoriteLanguageProlog => 'Prolog';

  @override
  String get favoriteLanguageCobol => 'COBOL';

  @override
  String get favoriteLanguageFortran => 'Fortran';

  @override
  String get favoriteLanguageMatlab => 'MATLAB';

  @override
  String get favoriteLanguageOther => 'Otro';

  @override
  String get keyboardLayoutQwerty => 'QWERTY';

  @override
  String get keyboardLayoutAzerty => 'AZERTY';

  @override
  String get keyboardLayoutQwertz => 'QWERTZ';

  @override
  String get keyboardLayoutDvorak => 'Dvorak';

  @override
  String get keyboardLayoutColemak => 'Colemak';

  @override
  String get keyboardLayoutWorkman => 'Workman';

  @override
  String get keyboardLayoutOther => 'Otra';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsExpressiveColor => 'Color expresivo';

  @override
  String get settingsExpressiveColorSubtitle =>
      'Usa tonos Material 3 Expressive más vivos';

  @override
  String get settingsSectionPalette => 'Paleta de colores';

  @override
  String get settingsPaletteSubtitle =>
      'Elige el acento y los tonos de fondo de toda la app';

  @override
  String get paletteEmber => 'Ember';

  @override
  String get paletteOcean => 'Océano';

  @override
  String get paletteForest => 'Bosque';

  @override
  String get paletteGrape => 'Uva';

  @override
  String get paletteRose => 'Rosa';

  @override
  String get paletteSunflower => 'Girasol';

  @override
  String get paletteTeal => 'Verde azulado';

  @override
  String get paletteCrimson => 'Carmesí';

  @override
  String get paletteMono => 'Monocromático';

  @override
  String get paletteNord => 'Nord';

  @override
  String get paletteGruvbox => 'Gruvbox';

  @override
  String get paletteDracula => 'Dracula';

  @override
  String get paletteSolarized => 'Solarized';

  @override
  String get paletteCatppuccin => 'Catppuccin';

  @override
  String get paletteTokyoNight => 'Tokyo Night';

  @override
  String get paletteTerminal => 'Terminal';

  @override
  String get paletteMatrix => 'Matrix';

  @override
  String get paletteFallout => 'Fallout';

  @override
  String get paletteBlackWhite => 'Blanco y negro';

  @override
  String get paletteMonokai => 'Monokai';

  @override
  String get paletteOneDark => 'One Dark';

  @override
  String get paletteCyberpunk => 'Cyberpunk';

  @override
  String get paletteSynthwave => 'Synthwave';

  @override
  String get paletteGithub => 'GitHub';

  @override
  String get paletteVscode => 'VS Code';

  @override
  String get settingsCornerStyle => 'Estilo de bordes';

  @override
  String get settingsCornerStyleSubtitle =>
      'Redondez de botones, tarjetas y el marco de la ventana — aplica al instante';

  @override
  String get cornerStyleSharp => 'Recto';

  @override
  String get cornerStyleSoft => 'Suave';

  @override
  String get cornerStyleRound => 'Redondeado';

  @override
  String get cornerStylePill => 'Píldora';

  @override
  String get settingsWindowBorder => 'Borde de ventana';

  @override
  String get settingsWindowBorderSubtitle =>
      'Borde redondeado y sombra alrededor de la ventana, en tiempo real';

  @override
  String get settingsWindowBorderWidth => 'Grosor del borde';

  @override
  String get windowBorderWidthThin => 'Delgado';

  @override
  String get windowBorderWidthMedium => 'Medio';

  @override
  String get windowBorderWidthThick => 'Grueso';

  @override
  String get settingsSectionSound => 'Sonido';

  @override
  String get settingsSoundSubtitle =>
      'Efectos de sonido al escribir — toca el ícono de play para previsualizar un pack';

  @override
  String get settingsSoundPreview => 'Escuchar';

  @override
  String get soundPackMechanical => 'Mecánico';

  @override
  String get soundPackSoft => 'Suave';

  @override
  String get soundPackTypewriter => 'Máquina de escribir';

  @override
  String get soundPackArcade => 'Arcade';

  @override
  String get soundPackPop => 'Pop';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsLanguage => 'Idioma de la app';

  @override
  String get settingsLanguageSystem => 'Igual que el sistema';

  @override
  String get settingsSectionSecurity => 'Seguridad';

  @override
  String get settingsAppLock => 'Bloqueo de la app';

  @override
  String get settingsAppLockSubtitle => 'Pide un PIN para abrir Ridge';

  @override
  String get settingsChangePin => 'Cambiar PIN';

  @override
  String get settingsAppLockBiometric => 'Usar biometría';

  @override
  String get settingsAppLockBiometricSubtitle =>
      'Desbloquea con huella o Face ID en lugar de escribir tu PIN';

  @override
  String get settingsLockNow => 'Bloquear ahora';

  @override
  String get settingsSectionShortcuts => 'Atajos de teclado';

  @override
  String get settingsShortcutsTitle => 'Atajos de teclado';

  @override
  String get settingsShortcutsSubtitle =>
      'Ve y personaliza cómo navegar sin usar el mouse';

  @override
  String get shortcutsScreenTitle => 'Atajos de teclado';

  @override
  String get shortcutActionGoToPractice => 'Ir a Práctica';

  @override
  String get shortcutActionGoToProgress => 'Ir a Progreso';

  @override
  String get shortcutActionGoToFreePractice => 'Ir a Práctica libre';

  @override
  String get shortcutActionGoToProfile => 'Ir a Perfil';

  @override
  String get shortcutActionGoToSettings => 'Ir a Ajustes';

  @override
  String get shortcutActionCycleNextSection => 'Siguiente sección';

  @override
  String get shortcutActionCyclePreviousSection => 'Sección anterior';

  @override
  String get shortcutActionCycleNextTab => 'Siguiente pestaña';

  @override
  String get shortcutActionCyclePreviousTab => 'Pestaña anterior';

  @override
  String get shortcutsCaptureDialogTitle =>
      'Presiona una combinación de teclas';

  @override
  String get shortcutsCaptureDialogHint => 'Debe incluir Ctrl o Alt';

  @override
  String get shortcutsCaptureDialogWaiting => 'Esperando una tecla…';

  @override
  String get shortcutsCaptureDialogNeedsModifier =>
      'Agrega Ctrl o Alt a esta combinación';

  @override
  String shortcutsCaptureDialogConflict(String action) {
    return 'Ya la usa \"$action\"';
  }

  @override
  String get shortcutsCaptureDialogSaved => 'Atajo actualizado';

  @override
  String get shortcutsCaptureCancel => 'Cancelar';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String settingsAboutVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsAboutArchitecture =>
      'Hecho con arquitectura hexagonal y Riverpod';

  @override
  String get settingsAboutChangelog => 'Novedades';

  @override
  String get settingsAboutChangelogSubtitle =>
      'Mirá el historial de versiones de la app';

  @override
  String get changelogScreenTitle => 'Novedades';

  @override
  String get changelogLoadError => 'No se pudo cargar el historial de cambios';

  @override
  String get settingsSectionDataManagement => 'Datos y progreso';

  @override
  String get settingsDataManagementSubtitle =>
      'Estas acciones solo afectan a este dispositivo. Los datos borrados no se pueden recuperar.';

  @override
  String get settingsResetLesson => 'Reiniciar una lección';

  @override
  String get settingsResetLessonSubtitle =>
      'Borra tu progreso en una sola lección para practicarla de nuevo desde cero';

  @override
  String get settingsResetAllLessons => 'Reiniciar todas las lecciones';

  @override
  String get settingsResetAllLessonsSubtitle =>
      'Borra tu progreso en todas las lecciones, de todas las rutas de aprendizaje';

  @override
  String get settingsWipeAllData => 'Borrar todos los datos locales';

  @override
  String get settingsWipeAllDataSubtitle =>
      'Elimina tu perfil, sesiones, estadísticas, logros y PIN — la app vuelve a empezar como nueva';

  @override
  String get settingsPickLessonTitle => 'Elige una lección para reiniciar';

  @override
  String get settingsPickLessonEmpty =>
      'Todavía no hay rutas de aprendizaje disponibles';

  @override
  String settingsResetLessonConfirmTitle(String lessonTitle) {
    return '¿Reiniciar \"$lessonTitle\"?';
  }

  @override
  String get settingsResetLessonConfirmBody =>
      'Se borrará cada intento que hayas hecho en esta lección y su progreso volverá a \"no iniciada\". Esto no se puede deshacer.';

  @override
  String get settingsResetAllLessonsConfirmTitle =>
      '¿Reiniciar todas las lecciones?';

  @override
  String get settingsResetAllLessonsConfirmBody =>
      'Se borrará cada intento en cada lección, de todas las rutas de aprendizaje, y su progreso volverá a \"no iniciada\". Tu XP y estadísticas se recalcularán. Esto no se puede deshacer.';

  @override
  String get settingsWipeAllDataConfirmTitle =>
      '¿Borrar todos los datos locales?';

  @override
  String get settingsWipeAllDataConfirmBody =>
      'Esto elimina permanentemente tu perfil, cada sesión de práctica, tus estadísticas, logros y PIN de este dispositivo. Empezarás de nuevo como un invitado totalmente nuevo. Esto no se puede deshacer.';

  @override
  String get settingsDataActionCancel => 'Cancelar';

  @override
  String get settingsDataActionReset => 'Reiniciar';

  @override
  String get settingsDataActionEraseEverything => 'Borrar todo';

  @override
  String get settingsResetLessonSuccess => 'Lección reiniciada';

  @override
  String get settingsResetAllLessonsSuccess =>
      'Todas las lecciones reiniciadas';

  @override
  String get settingsDataActionError => 'Algo salió mal. Intenta de nuevo.';

  @override
  String get lockTitle => 'Ingresa tu PIN';

  @override
  String get lockSubtitle => 'Ridge está bloqueada';

  @override
  String get lockSetTitle => 'Crea un PIN';

  @override
  String get lockSetSubtitle => 'Lo necesitarás para desbloquear la app';

  @override
  String get lockConfirmTitle => 'Confirma tu PIN';

  @override
  String get lockError => 'PIN incorrecto, intenta de nuevo';

  @override
  String get lockMismatch => 'Los PIN no coinciden';

  @override
  String get lockSaveError => 'No se pudo guardar tu PIN. Intenta de nuevo.';

  @override
  String get lockUnlock => 'Desbloquear';

  @override
  String get lockUseBiometrics => 'Usar biometría';

  @override
  String get lockBiometricReason => 'Desbloquea Ridge';

  @override
  String get lockBiometricError => 'No se pudo autenticar con biometría';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonSomethingWrong => 'Algo salió mal';

  @override
  String get commonLoading => 'Cargando…';

  @override
  String get windowMinimize => 'Minimizar';

  @override
  String get windowMaximize => 'Maximizar';

  @override
  String get windowRestore => 'Restaurar';

  @override
  String get windowClose => 'Cerrar';

  @override
  String get libraryTitle => 'Biblioteca';

  @override
  String get libraryEmptyState => 'Ningún snippet coincide con estos filtros';

  @override
  String get libraryFilterAll => 'Todos';

  @override
  String get difficultyBeginner => 'Principiante';

  @override
  String get difficultyIntermediate => 'Intermedio';

  @override
  String get difficultyAdvanced => 'Avanzado';

  @override
  String get difficultyExpert => 'Experto';

  @override
  String get categoryVariablesAndTypes => 'Variables y tipos';

  @override
  String get categoryConditionals => 'Condicionales';

  @override
  String get categoryLoops => 'Ciclos';

  @override
  String get categoryFunctions => 'Funciones';

  @override
  String get categoryStructs => 'Structs';

  @override
  String get categoryInterfaces => 'Interfaces';

  @override
  String get categorySlicesAndMaps => 'Slices y maps';

  @override
  String get categoryErrorHandling => 'Manejo de errores';

  @override
  String get categoryPointers => 'Punteros';

  @override
  String get categoryConcurrency => 'Concurrencia';

  @override
  String get categoryGenerics => 'Genéricos';

  @override
  String get categoryModernGo => 'Go moderno';

  @override
  String get categoryIdiomaticFormatting => 'Formato idiomático';

  @override
  String get categorySearchingAlgorithms => 'Algoritmos de búsqueda';

  @override
  String get categorySortingAlgorithms => 'Algoritmos de ordenamiento';

  @override
  String get categoryGraphAlgorithms => 'Algoritmos de grafos';

  @override
  String get categoryDomainModeling => 'Modelado de dominio';

  @override
  String get categoryHexagonalPorts => 'Puertos hexagonales';

  @override
  String get categoryApplicationUseCases => 'Casos de uso de aplicación';

  @override
  String get categoryPersistenceAdapters => 'Adaptadores de persistencia';

  @override
  String get categoryRestAdapters => 'Adaptadores REST';

  @override
  String get categoryTestingWithFakes => 'Pruebas con dobles falsos';

  @override
  String get categoryTuiArchitecture => 'Arquitectura TUI';

  @override
  String get categoryTuiStyling => 'Estilos de terminal';

  @override
  String get categoryTuiComponents => 'Componentes TUI';

  @override
  String get categoryTuiAdapter => 'Adaptador TUI';

  @override
  String get categoryHttpServers => 'Servidor HTTP';

  @override
  String get categoryHttpClients => 'Cliente HTTP';

  @override
  String get categoryHttpTesting => 'Tests HTTP';

  @override
  String get categorySqlPersistence => 'Persistencia SQL';

  @override
  String get categoryShellCommands => 'Comandos de shell';

  @override
  String get categoryPipesAndRedirection => 'Pipes y redirección';

  @override
  String get categoryTextProcessing => 'Procesamiento de texto';

  @override
  String get categorySystemAdministration => 'Administración (Arch)';

  @override
  String get categorySqlBasics => 'Fundamentos SQL';

  @override
  String get categorySqlSchema => 'Schema y setup';

  @override
  String get categorySqlQueries => 'Consultas';

  @override
  String get categorySqlFiltering => 'Filtrado';

  @override
  String get categorySqlAggregation => 'Agregación';

  @override
  String get categorySqlJoins => 'Joins';

  @override
  String get categorySqlModifications => 'Modificar datos';

  @override
  String get categorySqlAdvancedQueries => 'Consultas avanzadas';

  @override
  String get categorySearchAndIndexing => 'Búsqueda e indexación';

  @override
  String get categoryRegularExpressions => 'Expresiones regulares';

  @override
  String get categoryFileOperations => 'CRUD de archivos';

  @override
  String get categorySshClient => 'Cliente SSH';

  @override
  String get categorySshServer => 'Servidor SSH';

  @override
  String get categoryShellProfiles => 'Perfiles del shell';

  @override
  String get categoryClassesAndObjects => 'Clases y objetos';

  @override
  String get categoryModules => 'Módulos';

  @override
  String get categoryArraysAndStrings => 'Arreglos y strings';

  @override
  String get categoryMemoryManagement => 'Gestión de memoria';

  @override
  String get categoryPreprocessor => 'Preprocesador';

  @override
  String get categoryFileIO => 'Archivos (I/O)';

  @override
  String get categoryTemplates => 'Plantillas';

  @override
  String get categoryStlContainers => 'Contenedores STL';

  @override
  String get categoryBlocksAndProcs => 'Bloques y procs';

  @override
  String get categoryCollections => 'Colecciones';

  @override
  String get categoryNilSafety => 'Seguridad ante nil';

  @override
  String get categoryCssSelectors => 'Selectores';

  @override
  String get categoryCssBoxModel => 'Modelo de caja';

  @override
  String get categoryCssColorsAndTypography => 'Color y tipografía';

  @override
  String get categoryCssLayout => 'Layout';

  @override
  String get categoryCssPositioning => 'Posicionamiento';

  @override
  String get categoryCssCustomProperties => 'Propiedades personalizadas';

  @override
  String get categoryCssResponsive => 'Diseño adaptable';

  @override
  String get categoryCssTransitionsAndAnimations =>
      'Transiciones y animaciones';

  @override
  String get categoryPatternMatching => 'Coincidencia de patrones';

  @override
  String get categoryDelegatesAndEvents => 'Delegados y eventos';

  @override
  String get categoryLinq => 'LINQ';

  @override
  String get categoryAsyncProgramming => 'Async y await';

  @override
  String get categoryOptionals => 'Opcionales';

  @override
  String get categoryClosures => 'Closures';

  @override
  String get categoryEnumsAndPatternMatching => 'Enums y patrones';

  @override
  String get categoryCodable => 'Codable y JSON';

  @override
  String get categoryPropertyWrappers => 'Property wrappers';

  @override
  String get categoryNullSafety => 'Seguridad frente a nulos';

  @override
  String get categoryDataClasses => 'Clases de datos';

  @override
  String get categoryLambdas => 'Lambdas';

  @override
  String get categoryExtensions => 'Funciones de extensión';

  @override
  String get categoryCoroutines => 'Corrutinas';

  @override
  String get categoryDjangoProject => 'Estructura del proyecto';

  @override
  String get categoryDjangoModels => 'Modelos';

  @override
  String get categoryDjangoViews => 'Vistas y URLs';

  @override
  String get categoryDjangoTemplates => 'Plantillas';

  @override
  String get categoryDjangoForms => 'Formularios';

  @override
  String get categoryDjangoAdmin => 'Admin';

  @override
  String get categoryDjangoTesting => 'Tests';

  @override
  String get categoryDjangoRelationships => 'Relaciones';

  @override
  String get categoryDjangoOrm => 'Consultas ORM';

  @override
  String get categoryDjangoMigrations => 'Migraciones';

  @override
  String get categoryDjangoRestSetup => 'Configuración de DRF';

  @override
  String get categoryDjangoSerializers => 'Serializers';

  @override
  String get categoryDjangoRestViews => 'Vistas de API';

  @override
  String get categoryDjangoRestAuth => 'Autenticación y permisos';

  @override
  String get categoryDjangoRestFiltering => 'Paginación y filtros';

  @override
  String get categoryDjangoRestTesting => 'Tests de API';

  @override
  String get categoryRecordsAndPatterns => 'Registros y patrones';

  @override
  String get categoryPhpBasics => 'Fundamentos de PHP';

  @override
  String get categoryPhpStrings => 'Strings';

  @override
  String get categoryPhpConditionals => 'Condicionales';

  @override
  String get categoryPhpLoops => 'Ciclos';

  @override
  String get categoryPhpArrays => 'Arreglos';

  @override
  String get categoryPhpFunctions => 'Funciones';

  @override
  String get categoryPhpClasses => 'Clases y objetos';

  @override
  String get categoryPhpEnums => 'Enums';

  @override
  String get categoryPhpErrorHandling => 'Manejo de errores';

  @override
  String get categoryPhpNamespaces => 'Namespaces';

  @override
  String get categoryPhpSuperglobals => 'Superglobales';

  @override
  String get categoryPhpForms => 'Formularios y validación';

  @override
  String get categoryPhpSessions => 'Sesiones y cookies';

  @override
  String get categoryPhpDatabase => 'Base de datos (PDO)';

  @override
  String get categoryPhpJson => 'JSON y APIs';

  @override
  String get categoryPhpFiles => 'Archivos';

  @override
  String get categoryPhpSearching => 'Búsqueda';

  @override
  String get categoryPhpSorting => 'Ordenamiento';

  @override
  String get categoryPhpGraphs => 'Grafos';

  @override
  String get categoryGitBasics => 'Fundamentos de Git';

  @override
  String get categoryGitCommits => 'Commits';

  @override
  String get categoryGitBranching => 'Ramas y merges';

  @override
  String get categoryGitRemotes => 'Remotos';

  @override
  String get categoryGitHistory => 'Historial';

  @override
  String get categoryGitUndo => 'Deshacer cambios';

  @override
  String get categoryGitCollaboration => 'Colaboración';

  @override
  String get categoryGitObjects => 'Objetos';

  @override
  String get categoryGitRefs => 'Referencias y HEAD';

  @override
  String get categoryGitMaintenance => 'Mantenimiento';

  @override
  String get categoryLinuxBasics => 'Fundamentos de Linux';

  @override
  String get categoryLinuxFiles => 'Archivos y rutas';

  @override
  String get categoryPermissions => 'Permisos';

  @override
  String get categoryUsersAndGroups => 'Usuarios y grupos';

  @override
  String get categoryProcesses => 'Procesos';

  @override
  String get categoryPackages => 'Paquetes';

  @override
  String get categoryServices => 'Servicios';

  @override
  String get categoryLogs => 'Registros';

  @override
  String get categoryStorage => 'Almacenamiento';

  @override
  String get categoryNetworking => 'Redes';

  @override
  String get categoryScheduling => 'Programación de tareas';

  @override
  String get categoryBackupAndArchives => 'Respaldos';

  @override
  String get categoryDockerBasics => 'Fundamentos de Docker';

  @override
  String get categoryDockerImages => 'Imágenes';

  @override
  String get categoryDockerFiles => 'Dockerfiles';

  @override
  String get categoryDockerContainers => 'Contenedores';

  @override
  String get categoryDockerVolumes => 'Volúmenes y datos';

  @override
  String get categoryDockerNetworking => 'Redes en Docker';

  @override
  String get categoryDockerRegistries => 'Registros';

  @override
  String get categoryDockerCompose => 'Compose';

  @override
  String get categoryDockerMaintenance => 'Depuración y mantenimiento';

  @override
  String get categoryWorkflowBasics => 'Fundamentos de workflows';

  @override
  String get categoryWorkflowTriggers => 'Disparadores y eventos';

  @override
  String get categoryJobsAndSteps => 'Jobs y pasos';

  @override
  String get categoryExpressionsAndContexts => 'Expresiones y contextos';

  @override
  String get categoryRunnersAndMatrix => 'Runners y matrices';

  @override
  String get categorySecretsAndVariables => 'Secretos y variables';

  @override
  String get categoryCachingAndArtifacts => 'Caché y artefactos';

  @override
  String get categoryReusableAndComposite => 'Reutilizables y compuestas';

  @override
  String get categoryContainersAndDocker => 'Contenedores y Docker';

  @override
  String get categoryPipelinePatterns => 'Patrones de pipelines';

  @override
  String get categorySecurityHardening => 'Seguridad';

  @override
  String get categoryDeploymentsAndReleases => 'Despliegues y releases';

  @override
  String get categoryCiOperations => 'Operación de CI';

  @override
  String get categoryLanguageEvolution => 'Evolución del lenguaje';

  @override
  String get categoryModernIdioms => 'Modismos modernos';

  @override
  String get categoryGenericMethods => 'Métodos genéricos';

  @override
  String get categoryIterators => 'Iteradores';

  @override
  String get categoryJsonV2 => 'JSON v2';

  @override
  String get categoryModernStdlib => 'Stdlib moderna';

  @override
  String get categoryApiDesign => 'Diseño de API';

  @override
  String get categoryErrorPatterns => 'Patrones de error';

  @override
  String get categoryConcurrencyPatterns => 'Patrones de concurrencia';

  @override
  String get categoryGoroutineLeaks => 'Fugas de goroutines';

  @override
  String get categoryAdvancedTesting => 'Testing avanzado';

  @override
  String get categoryPerformanceProfiling => 'Rendimiento y perfilado';

  @override
  String get categoryObservability => 'Observabilidad';

  @override
  String get categoryGoTooling => 'Tooling de Go';

  @override
  String get languageGo => 'Go';

  @override
  String get languageBash => 'Bash';

  @override
  String get languageSql => 'SQL';

  @override
  String get languageRust => 'Rust';

  @override
  String get languagePython => 'Python';

  @override
  String get languageJavascript => 'JavaScript';

  @override
  String get languageTypescript => 'TypeScript';

  @override
  String get languageHaskell => 'Haskell';

  @override
  String get languageC => 'C';

  @override
  String get languageCpp => 'C++';

  @override
  String get languageJava => 'Java';

  @override
  String get languageCrystal => 'Crystal';

  @override
  String get languageCss => 'CSS';

  @override
  String get languageCsharp => 'C#';

  @override
  String get languageSwift => 'Swift';

  @override
  String get languageKotlin => 'Kotlin';

  @override
  String get languageDart => 'Dart';

  @override
  String get languagePhp => 'PHP';

  @override
  String get languageGit => 'Git';

  @override
  String get languageLinux => 'Linux';

  @override
  String get languageDocker => 'Docker';

  @override
  String get languageGithubActions => 'GitHub Actions';

  @override
  String get languageGoBlurb => 'Simple y rápido — ideal para backend y nube.';

  @override
  String get languageBashBlurb =>
      'Automatiza tu flujo y domina la terminal de Linux.';

  @override
  String get languageSqlBlurb =>
      'Consulta y modela datos — el idioma de toda base de datos.';

  @override
  String get languageRustBlurb =>
      'Programación de sistemas segura, sin recolector de basura.';

  @override
  String get languagePythonBlurb =>
      'Sintaxis clara — la reina de datos, IA y scripting.';

  @override
  String get languageJavascriptBlurb =>
      'El lenguaje de la web, del frontend al backend.';

  @override
  String get languageTypescriptBlurb =>
      'JavaScript con tipos estáticos — código más seguro y autodocumentado.';

  @override
  String get languageHaskellBlurb =>
      'Funcional y puro — valores, tipos y sin efectos secundarios.';

  @override
  String get languageCBlurb =>
      'Cerca del metal — el lenguaje sobre el que se construyen los sistemas operativos.';

  @override
  String get languageCppBlurb =>
      'Rendimiento y control — clases, plantillas y la STL.';

  @override
  String get languageJavaBlurb =>
      'Escribe una vez, ejecuta en todas partes — el clásico orientado a objetos.';

  @override
  String get languageCrystalBlurb =>
      'Sintaxis tipo Ruby, compilada y con inferencia de tipos — rápida sin ceremonia.';

  @override
  String get languageCssBlurb =>
      'La hoja de estilos de la web — cascada, especificidad y layout.';

  @override
  String get languageCsharpBlurb =>
      'Moderno, orientado a objetos y rápido — de apps y juegos a la nube.';

  @override
  String get languageSwiftBlurb =>
      'Seguro, rápido y expresivo — el lenguaje moderno de las plataformas de Apple.';

  @override
  String get languageKotlinBlurb =>
      'Conciso, seguro frente a nulos y multiplataforma — el lenguaje detrás del Android moderno.';

  @override
  String get languageDartBlurb =>
      'Seguro frente a nulos y asíncrono — el lenguaje detrás de Flutter.';

  @override
  String get languagePhpBlurb =>
      'El motor del lado servidor de la web — pragmático, dinámico y en todas partes.';

  @override
  String get languageGitBlurb => 'Registra cada cambio y colabora sin miedo.';

  @override
  String get languageLinuxBlurb =>
      'Entiende y opera el sistema bajo cada servidor y contenedor.';

  @override
  String get languageDockerBlurb => 'Empaquétalo una vez, ejecútalo donde sea.';

  @override
  String get languageGithubActionsBlurb =>
      'El motor CI/CD de GitHub — flujos YAML que construyen, prueban y despliegan tu código.';

  @override
  String get snippetPracticeAction => 'Practicar';

  @override
  String get practiceZenTitle => 'Práctica Zen';

  @override
  String practiceLiveLives(int count) {
    return '$count vidas restantes';
  }

  @override
  String practiceLiveScore(int score) {
    return 'Puntos $score';
  }

  @override
  String practiceLiveMultiplier(int multiplier) {
    return '×$multiplier';
  }

  @override
  String practiceLiveSnippets(int count) {
    return '$count superados';
  }

  @override
  String get practiceResultTitle => 'Sesión completa';

  @override
  String get practiceResultSurvivalTitle => 'Ronda terminada';

  @override
  String get practiceResultNetSpeed => 'Velocidad neta';

  @override
  String get practiceResultRawSpeed => 'Velocidad bruta';

  @override
  String get practiceResultAccuracy => 'Precisión';

  @override
  String get practiceResultConsistency => 'Consistencia';

  @override
  String get practiceResultStreak => 'Racha más larga';

  @override
  String get practiceResultSurvivalSnippets => 'Snippets superados';

  @override
  String get practiceResultSurvivalScore => 'Puntaje';

  @override
  String get practiceResultSurvivalBestMultiplier => 'Mejor multiplicador';

  @override
  String get practiceResultWeakestChars =>
      'Caracteres más débiles de esta sesión';

  @override
  String get practiceResultDone => 'Listo';

  @override
  String practiceResultScorePassed(int score) {
    return '$score/10 — ¡Aprobado!';
  }

  @override
  String practiceResultScoreFailed(int score) {
    return '$score/10 — Aún no, inténtalo de nuevo';
  }

  @override
  String get practiceResultRetry => 'Reintentar';

  @override
  String get practiceResultRetrySave => 'Reintentar guardado';

  @override
  String get practiceResultContinue => 'Continuar';

  @override
  String get practiceResultLearnMoreTitle => '¿Qué acabas de escribir?';

  @override
  String get compilerFlavorPerfect => 'Build exitoso — 0 errores, 0 warnings.';

  @override
  String get compilerFlavorGreat => 'Compiló con un par de warnings menores.';

  @override
  String get compilerFlavorGood => 'Build exitoso tras varios parches.';

  @override
  String get compilerFlavorRough => 'Corrió, pero con algunos bugs conocidos.';

  @override
  String get compilerFlavorBad =>
      'panic: runtime error — recuperado. Inténtalo de nuevo.';

  @override
  String get practiceModePickerTitle => 'Elige un modo';

  @override
  String get practiceModeZen => 'Zen';

  @override
  String get practiceModeZenSubtitle =>
      'Sin límite de tiempo, sin presión — solo practica.';

  @override
  String get practiceModeSprint30 => 'Sprint · 30s';

  @override
  String get practiceModeSprint60 => 'Sprint · 60s';

  @override
  String get practiceModeSprint120 => 'Sprint · 120s';

  @override
  String get practiceModeSprintSubtitle =>
      'Compite contra el reloj — maximiza los caracteres correctos.';

  @override
  String get practiceModePrecision => 'Prueba de precisión';

  @override
  String get practiceModePrecisionSubtitle =>
      'Saca más de 7/10 (80%+ de precisión) para aprobar.';

  @override
  String get practiceModeSurvival => 'Supervivencia';

  @override
  String get practiceModeSurvivalSubtitle =>
      '5 vidas, snippets infinitos — un error cuesta un corazón.';

  @override
  String get practiceHubQuickModesTitle => 'Práctica rápida';

  @override
  String get practiceHubBrowseAllAction => 'Explorar todos los snippets';

  @override
  String get practiceHubNoSnippetsAvailable =>
      'Aún no hay snippets disponibles.';

  @override
  String get dailyChallengeCardTitle => 'Reto diario';

  @override
  String get dailyChallengeCardSubtitle =>
      'El snippet compartido de hoy — todos reciben el mismo.';

  @override
  String dailyChallengeCardAlreadyPlayed(int score) {
    return 'Ya jugado hoy — puntaje $score/10';
  }

  @override
  String dailyChallengeCardStreakLabel(int days) {
    return '${days}d';
  }

  @override
  String get progressEmptyState =>
      'Termina una sesión de práctica para ver tu progreso aquí.';

  @override
  String get progressTabOverview => 'Resumen';

  @override
  String get progressTabWeaknesses => 'Debilidades';

  @override
  String get progressTabActivity => 'Actividad';

  @override
  String get progressTabHistory => 'Historial';

  @override
  String progressLevelLabel(int level) {
    return 'Nivel $level';
  }

  @override
  String progressTotalXp(int xp) {
    return '$xp XP';
  }

  @override
  String progressStreakLabel(int days) {
    return 'Racha de $days días';
  }

  @override
  String get progressWeaknessTitle => 'Tus puntos débiles';

  @override
  String get progressWeaknessCharacters => 'Caracteres';

  @override
  String get progressWeaknessFingers => 'Dedos';

  @override
  String get progressWeaknessNgrams => 'Combinaciones';

  @override
  String get progressWeaknessKeyTransitions => 'Transiciones de teclas';

  @override
  String get progressWeaknessEmpty => 'Aún no hay suficientes datos';

  @override
  String get progressHeatmapTitle => 'Mapa de calor del teclado';

  @override
  String get progressMasteryTitle => 'Dominio';

  @override
  String get progressMasteryEmpty =>
      'Completa sesiones de Precisión para empezar a certificar categorías';

  @override
  String get progressMasteryCertified => 'Dominado';

  @override
  String get progressMasteryNotYet => 'Aún no dominado';

  @override
  String get progressHistoryTitle => 'Historial personal';

  @override
  String get progressHistoryEmpty => 'Aún no hay historial para esta categoría';

  @override
  String progressHistoryAverage(int speed, int accuracy) {
    return 'Promedio: $speed ppm · $accuracy% de precisión';
  }

  @override
  String get progressJsonEntryButton => 'Ver JSON sin procesar';

  @override
  String get progressJsonScreenTitle => 'Estadísticas (JSON)';

  @override
  String get progressJsonCopyButton => 'Copiar';

  @override
  String get progressJsonCopiedMessage => 'Copiado al portapapeles';

  @override
  String get progressJsonExportButton => 'Exportar';

  @override
  String progressJsonExportedMessage(String path) {
    return 'Guardado en $path';
  }

  @override
  String get progressJsonExportError =>
      'No se pudieron exportar las estadísticas';

  @override
  String get progressFingerLeftPinky => 'Meñique izquierdo';

  @override
  String get progressFingerLeftRing => 'Anular izquierdo';

  @override
  String get progressFingerLeftMiddle => 'Medio izquierdo';

  @override
  String get progressFingerLeftIndex => 'Índice izquierdo';

  @override
  String get progressFingerRightIndex => 'Índice derecho';

  @override
  String get progressFingerRightMiddle => 'Medio derecho';

  @override
  String get progressFingerRightRing => 'Anular derecho';

  @override
  String get progressFingerRightPinky => 'Meñique derecho';

  @override
  String get progressFingerThumb => 'Pulgar';

  @override
  String get progressTrendImproving => 'Mejorando';

  @override
  String get progressTrendWorsening => 'Empeorando';

  @override
  String get progressTrendStable => 'Estable';

  @override
  String get progressKeySpace => 'Espacio';

  @override
  String get progressKeyTab => 'Tab';

  @override
  String get progressKeyEnter => 'Intro';

  @override
  String get progressKeyBackspace => 'Retroceso';

  @override
  String get progressKeyDelete => 'Suprimir';

  @override
  String get progressKeyArrowLeft => 'Flecha izquierda';

  @override
  String get progressKeyArrowRight => 'Flecha derecha';

  @override
  String get progressKeyShiftLeft => 'Mayús izquierda';

  @override
  String get progressKeyShiftRight => 'Mayús derecha';

  @override
  String get progressActivityTitle => 'Actividad';

  @override
  String get progressActivityMostPracticedCategories =>
      'Categorías más practicadas';

  @override
  String get progressActivityLowestScoringCategories =>
      'Categorías con puntaje más bajo';

  @override
  String get progressActivityMostPracticedExercises =>
      'Ejercicios más practicados';

  @override
  String get progressActivityLowestScoringExercises =>
      'Ejercicios con puntaje más bajo';

  @override
  String progressActivitySessionCount(int count) {
    return '$count sesiones';
  }

  @override
  String progressActivityScoreLabel(int score) {
    return 'Puntaje: $score';
  }

  @override
  String get learningPathsTitle => 'Rutas de aprendizaje';

  @override
  String get learningPathsEmptyState =>
      'Aún no hay rutas de aprendizaje disponibles.';

  @override
  String get learningPathsLessonListTitle => 'Lecciones';

  @override
  String get learningPathsContinueAction => 'Continuar lección';

  @override
  String get learningPathsShareLessonAction => 'Compartir este ejercicio';

  @override
  String get learningLessonLocked => 'Bloqueada';

  @override
  String get learningLessonUnlocked => 'Desbloqueada';

  @override
  String get learningLessonCompleted => 'Completada';

  @override
  String get practiceLanguageChangeAction => 'Cambiar lenguaje';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String achievementUnlockedToast(String title) {
    return 'Logro desbloqueado: $title';
  }

  @override
  String get achievementCeroErroresTitle => 'Cero Errores';

  @override
  String get achievementCeroErroresDescription =>
      'Termina una sesión con 100% de precisión y sin correcciones';

  @override
  String get achievementAmbidiestroTitle => 'Ambidiestro';

  @override
  String get achievementAmbidiestroDescription =>
      'Termina una sesión de 100+ caracteres con un balance de manos casi perfecto';

  @override
  String get achievementMaratonistaBronzeTitle => 'Maratonista · Bronce';

  @override
  String get achievementMaratonistaSilverTitle => 'Maratonista · Plata';

  @override
  String get achievementMaratonistaGoldTitle => 'Maratonista · Oro';

  @override
  String achievementMaratonistaDescription(int count) {
    return 'Escribe $count caracteres correctos en total';
  }

  @override
  String achievementCategoryMasteryTitle(String category, String difficulty) {
    return 'Dominio · $category · $difficulty';
  }

  @override
  String get achievementCategoryMasteryDescription =>
      'Certifica el dominio de una categoría y dificultad';

  @override
  String achievementStreakTitle(int days) {
    return 'Racha de $days días';
  }

  @override
  String achievementStreakDescription(int days) {
    return 'Practica $days días seguidos';
  }

  @override
  String achievementsUnlockedCount(int unlocked, int total) {
    return '$unlocked de $total desbloqueados';
  }

  @override
  String get achievementsMilestonesSectionTitle => 'Hitos';

  @override
  String get achievementsCategoryMasterySectionTitle => 'Dominio de categorías';

  @override
  String get achievementsCategoryMasteryLegend =>
      'Cada fila: Principiante, Intermedio, Avanzado, Experto';

  @override
  String get onboardingSkip => 'Omitir';

  @override
  String get onboardingNext => 'Siguiente';

  @override
  String get onboardingGetStarted => 'Comenzar';

  @override
  String get onboardingWelcomeTitle => 'Código real, no relleno';

  @override
  String get onboardingWelcomeDescription =>
      'Practica mecanografía con snippets reales de Go — la sintaxis que de verdad escribes en el trabajo, no frases al azar.';

  @override
  String get onboardingMetricsTitle => 'Entiende exactamente qué te cuesta';

  @override
  String get onboardingMetricsDescription =>
      'Velocidad, precisión, por dedo y por carácter — cada sesión te muestra qué mejorar, y por qué.';

  @override
  String get onboardingPathsTitle => 'Progresa a tu ritmo';

  @override
  String get onboardingPathsDescription =>
      'Rutas de aprendizaje guiadas, XP y logros — totalmente sin conexión, cuando tú quieras.';

  @override
  String get onboardingReadyTitle => 'Sin fricción, nunca';

  @override
  String get onboardingReadyDescription =>
      'Solo un nombre de usuario — sin correo, sin contraseña. Empecemos a escribir.';

  @override
  String get onboardingAppearanceTitle => 'Hazla tuya';

  @override
  String get onboardingAppearanceDescription =>
      'Elige una paleta, el estilo de esquinas y el modo de color — puedes cambiar esto después en Ajustes.';

  @override
  String get onboardingDeviceTitle => 'Ya conocemos tu equipo';

  @override
  String get onboardingDeviceDescription =>
      'Detectamos tu plataforma y dispositivo automáticamente — no hay nada que configurar.';
}
