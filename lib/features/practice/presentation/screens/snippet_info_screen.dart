import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:just_in_time/core/i18n/gen/app_localizations.dart';
import 'package:just_in_time/core/theme/app_motion.dart';
import 'package:just_in_time/core/theme/app_shapes.dart';
import 'package:just_in_time/core/theme/app_typography.dart';
import 'package:just_in_time/core/widgets/inline_code_text.dart';
import 'package:just_in_time/features/content/domain/entities/snippet.dart';
import 'package:just_in_time/features/content/domain/services/syntax_tokenizer.dart';
import 'package:just_in_time/features/content/presentation/content_labels.dart';
import 'package:just_in_time/features/content/presentation/syntax_colors.dart';

/// Full-screen "what did you just type?" reading view, pushed from the
/// result screen's fixed footer info button — a comfortable, unhurried
/// place to actually read the just-typed code (fully syntax-highlighted,
/// no capture mechanics, no typed/untyped dimming) alongside its
/// explanation, instead of squinting at a small collapsed card.
class SnippetInfoScreen extends StatefulWidget {
  /// Creates the info screen for [snippet].
  const new({required this.snippet, super.key});

  /// The just-completed snippet to explain.
  final Snippet snippet;

  @override
  State<SnippetInfoScreen> createState() => _SnippetInfoScreenState();
}

class _SnippetInfoScreenState extends State<SnippetInfoScreen> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Jumps the reading scroll view — shared by Home/End (start/end) and
  /// PageUp/PageDown (one 80%-of-viewport increment at a time), same
  /// increment convention as `KeyboardScrollShortcuts` uses everywhere
  /// else; this screen can't just wrap in that widget since it already
  /// owns the outer `Focus(autofocus: true)` this class' doc explains,
  /// and nesting a second autofocusing `Focus` inside would only ever
  /// steal focus right back from itself.
  void _animateTo(double offset) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _scrollController.animateTo(
      offset.clamp(position.minScrollExtent, position.maxScrollExtent),
      duration: AppMotion.spatialFast,
      curve: AppMotion.spatial,
    );
  }

  void _page({required bool forward}) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final increment = position.viewportDimension * 0.8;
    _animateTo(position.pixels + (forward ? increment : -increment));
  }

  @override
  Widget build(BuildContext context) {
    final snippet = widget.snippet;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final syntaxColors = SyntaxColors.fromScheme(theme.colorScheme);
    final tokenTypes = SyntaxTokenizers.forLanguage(snippet.language)
        .classify(snippet.code);
    final tldr = snippet.tldrFor(context);
    final explanation = snippet.explanationFor(context);

    // Escape backs out here too, mirroring every other screen in the
    // practice flow (`PracticeSessionScreen`) — a `Focus` with
    // `autofocus` is required since nothing else in this read-only
    // screen would otherwise claim focus for the shortcut to bubble
    // through. Home/End/PageUp/PageDown ride along on the same
    // `Focus`/`CallbackShortcuts` pair rather than a nested
    // `KeyboardScrollShortcuts` (see `_animateTo`'s doc for why).
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).maybePop(),
        const SingleActivator(LogicalKeyboardKey.home): () =>
            _animateTo(double.negativeInfinity),
        const SingleActivator(LogicalKeyboardKey.end): () =>
            _animateTo(double.infinity),
        const SingleActivator(LogicalKeyboardKey.pageUp): () =>
            _page(forward: false),
        const SingleActivator(LogicalKeyboardKey.pageDown): () =>
            _page(forward: true),
      },
      child: Focus(
        autofocus: true,
        child: Scaffold(
          appBar: AppBar(title: Text(snippet.titleFor(context))),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(snippet.difficulty.label(l10n))),
                      Chip(label: Text(snippet.category.label(l10n))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: ShapeDecoration(
                      shape: AppShapes.of(context).largeShape,
                      color: theme.colorScheme.surfaceContainerHigh,
                    ),
                    child: SelectableText.rich(
                      TextSpan(
                        style: (theme.textTheme.bodyLarge ?? const TextStyle())
                            .copyWith(fontFamily: AppFonts.mono, height: 1.6),
                        children: [
                          for (var i = 0; i < snippet.code.length; i++)
                            TextSpan(
                              text: snippet.code[i],
                              style: TextStyle(
                                color: syntaxColors.forType(tokenTypes[i]),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (tldr.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        shape: AppShapes.of(context).mediumShape,
                        color: theme.colorScheme.primaryContainer,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // A literal key-cap-style label, not
                                  // translated content — same treatment
                                  // as "ENTER"/"R" elsewhere in this app.
                                  'TL;DR',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer
                                        .withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                InlineCodeText(
                                  tldr,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  accentColor:
                                      theme.colorScheme.onPrimaryContainer,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (explanation.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    InlineCodeText(
                      explanation,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
