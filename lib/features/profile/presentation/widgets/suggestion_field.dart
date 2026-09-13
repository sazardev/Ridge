import 'package:flutter/material.dart';

import 'package:ridge/features/profile/presentation/keyboard_model_brand_matching.dart';

/// A text field backed by a curated [suggestions] list — the autocomplete
/// overlay narrows as the user types, but any value (including one not in
/// the list) is still accepted, since these are just a fast-completion
/// aid, not a closed set of valid answers. Shared by the profile form and
/// the dedicated keyboard editor.
class SuggestionField extends StatelessWidget {
  /// Creates a suggestion-backed text field.
  const new({
    required this.label,
    required this.icon,
    required this.initialValue,
    required this.suggestions,
    required this.onChanged,
    this.preferredPrefix,
    super.key,
  });

  /// The field's floating label.
  final String label;

  /// Leading icon shown inside the field.
  final IconData icon;

  /// The value the field starts with.
  final String initialValue;

  /// The full candidate pool.
  final List<String> suggestions;

  /// Called with the field's value on every keystroke/selection.
  final ValueChanged<String> onChanged;

  /// When set (e.g. the keyboard brand the user already picked), matches
  /// whose name starts with this — or one of its parenthesized aliases,
  /// see `brandTokens` — are shown ahead of the rest, so picking a brand
  /// first means its models surface without retyping the brand name.
  /// Never excludes anything: a query still searches every suggestion.
  final String? preferredPrefix;

  /// The most matches shown at once — plenty to scroll through, but a
  /// hard ceiling so a broad query (e.g. a single common letter) against
  /// a long suggestion list never has to lay out hundreds of rows just to
  /// render the first few.
  static const _maxOptions = 30;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const Iterable<String>.empty();
        final query = value.text.toLowerCase();
        final prefix = preferredPrefix;
        final pool = (prefix == null || prefix.isEmpty)
            ? suggestions
            : preferBrandMatches(suggestions, prefix);
        // Single pass: prefix matches ("Key" -> "Keychron...") are the
        // most relevant, so they're returned ahead of mid-string ones —
        // brand-preferred entries (see `pool` above) sort ahead within
        // each of those two groups too.
        final startsWith = <String>[];
        final contains = <String>[];
        for (final suggestion in pool) {
          final lower = suggestion.toLowerCase();
          if (lower.startsWith(query)) {
            startsWith.add(suggestion);
          } else if (lower.contains(query)) {
            contains.add(suggestion);
          }
        }
        return startsWith.followedBy(contains).take(_maxOptions);
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        );
      },
    );
  }
}
