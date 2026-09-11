/// Reorders [suggestions] so entries matching [brand] (via
/// [brandTokens]) come first — a soft preference, not a filter: a model
/// sold under a different name than its manufacturer (e.g. "ErgoDox EZ"
/// for brand "ZSA (ErgoDox/Moonlander/Voyager)") must still be reachable
/// by typing its own name, so nothing is ever excluded, only
/// reprioritized. Used by `EditProfileScreen`'s keyboard model field so
/// picking a brand first means its models surface without retyping the
/// brand name.
List<String> preferBrandMatches(List<String> suggestions, String brand) {
  final tokens = brandTokens(brand);
  bool matchesBrand(String model) {
    final lower = model.toLowerCase();
    return tokens.any((token) => lower.startsWith(token.toLowerCase()));
  }

  final preferred = <String>[];
  final rest = <String>[];
  for (final suggestion in suggestions) {
    (matchesBrand(suggestion) ? preferred : rest).add(suggestion);
  }
  return [...preferred, ...rest];
}

/// The literal name tokens to prefix-match model suggestions against for
/// [brand]: the primary name, plus any alternate names spelled out in
/// parentheses (e.g. "ZSA (ErgoDox/Moonlander/Voyager)" ->
/// `["ZSA", "ErgoDox", "Moonlander", "Voyager"]`) — some brands sell
/// products under a different name than the manufacturer's own (see
/// `kKeyboardBrandSuggestions` in `profile_suggestions.dart`).
List<String> brandTokens(String brand) {
  final parenStart = brand.indexOf('(');
  if (parenStart == -1) return [brand.trim()];

  final primary = brand.substring(0, parenStart).trim();
  final parenEnd = brand.indexOf(')', parenStart);
  if (parenEnd == -1) return [primary];

  final aliases = brand
      .substring(parenStart + 1, parenEnd)
      .split('/')
      .map((alias) => alias.trim())
      .where((alias) => alias.isNotEmpty);
  return [primary, ...aliases];
}
