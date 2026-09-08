// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Just In Time';

  @override
  String get navTasks => 'Tareas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get tasksTitle => 'Just In Time';

  @override
  String get tasksEmptyTitle => 'Nada pendiente todavía';

  @override
  String get tasksEmptyBody =>
      'Agrega una tarea y dale un momento — aparecerá aquí, justo a tiempo.';

  @override
  String get tasksSectionOverdue => 'Vencidas';

  @override
  String get tasksSectionToday => 'Hoy';

  @override
  String get tasksSectionUpcoming => 'Próximas';

  @override
  String get tasksSectionDone => 'Completadas';

  @override
  String get tasksAdd => 'Nueva tarea';

  @override
  String get tasksAddSheetTitle => 'Nueva tarea';

  @override
  String get tasksEditSheetTitle => 'Editar tarea';

  @override
  String get tasksFieldTitle => 'Título';

  @override
  String get tasksFieldTitleHint => '¿Qué hay que hacer?';

  @override
  String get tasksFieldNotes => 'Notas';

  @override
  String get tasksFieldNotesHint => 'Agrega detalles (opcional)';

  @override
  String get tasksFieldDueDate => 'Fecha límite';

  @override
  String get tasksFieldDueDateNone => 'Sin fecha límite';

  @override
  String get tasksFieldPriority => 'Prioridad';

  @override
  String get priorityLow => 'Baja';

  @override
  String get priorityMedium => 'Media';

  @override
  String get priorityHigh => 'Alta';

  @override
  String get tasksSave => 'Guardar';

  @override
  String get tasksCancel => 'Cancelar';

  @override
  String get tasksDelete => 'Eliminar';

  @override
  String get tasksDeleteConfirmTitle => '¿Eliminar tarea?';

  @override
  String tasksDeleteConfirmBody(String title) {
    return '\"$title\" se eliminará de forma permanente.';
  }

  @override
  String get tasksMarkDone => 'Marcar como completada';

  @override
  String get tasksMarkUndone => 'Marcar como pendiente';

  @override
  String get tasksUndoSnackbar => 'Tarea eliminada';

  @override
  String get tasksUndoAction => 'Deshacer';

  @override
  String get tasksErrorEmptyTitle => 'Ponle un título a la tarea primero';

  @override
  String tasksCountRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tareas pendientes',
      one: '1 tarea pendiente',
      zero: 'Todo al día',
    );
    return '$_temp0';
  }

  @override
  String get settingsTitle => 'Ajustes';

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
  String get settingsAppLockSubtitle => 'Pide un PIN para abrir Just In Time';

  @override
  String get settingsChangePin => 'Cambiar PIN';

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
  String get lockTitle => 'Ingresa tu PIN';

  @override
  String get lockSubtitle => 'Just In Time está bloqueada';

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
  String get lockUnlock => 'Desbloquear';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonSomethingWrong => 'Algo salió mal';

  @override
  String get commonLoading => 'Cargando…';
}
