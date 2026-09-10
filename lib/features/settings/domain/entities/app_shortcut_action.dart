/// A user-customizable global keyboard shortcut action (STACK.md §2.5's
/// "el teclado es el input principal de toda la app"). Each maps to
/// exactly one `ShortcutBinding` in `AppSettings.shortcutBindings`.
enum AppShortcutAction {
  /// Jump to the Practice/Learning-paths section (shell branch 0).
  goToPractice,

  /// Jump to the Progress section (shell branch 1).
  goToProgress,

  /// Jump to the Free Practice section (shell branch 2).
  goToFreePractice,

  /// Jump to the Profile section (shell branch 3).
  goToProfile,

  /// Jump to the Settings section (shell branch 4).
  goToSettings,

  /// Cycle to the next shell section, wrapping around.
  cycleNextSection,

  /// Cycle to the previous shell section, wrapping around.
  cyclePreviousSection,

  /// Cycle to the next tab on a tabbed screen (currently only the
  /// Progress screen), wrapping around.
  cycleNextTab,

  /// Cycle to the previous tab on a tabbed screen, wrapping around.
  cyclePreviousTab,
}
