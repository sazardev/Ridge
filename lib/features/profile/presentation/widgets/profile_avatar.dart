import 'package:flutter/material.dart';

/// The Profile screen's avatar: the GitHub profile picture when a handle is
/// set, falling back to the username's initial while it loads, when the
/// device is offline, or when GitHub has no avatar to give — the offline
/// guest profile must never depend on a network round-trip to render.
class ProfileAvatar extends StatelessWidget {
  /// Creates the avatar for [username], preferring the GitHub picture of
  /// [githubUsername] when one has been set.
  const new({required this.username, this.githubUsername, super.key});

  /// The Guest Profile's display name, source of the fallback initial.
  final String username;

  /// The (already normalized) GitHub handle whose avatar to show, or `null`
  /// to always show the initial.
  final String? githubUsername;

  static const _radius = 42.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Container(
        width: 96,
        height: 96,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colorScheme.primary, colorScheme.tertiary],
          ),
        ),
        child: CircleAvatar(
          backgroundColor: colorScheme.surface,
          child: CircleAvatar(
            radius: _radius,
            backgroundColor: colorScheme.primaryContainer,
            child: _initialOrPhoto(context),
          ),
        ),
      ),
    );
  }

  Widget _initialOrPhoto(BuildContext context) {
    final fallback = _initial(context);
    final handle = githubUsername;
    if (handle == null || handle.isEmpty) return fallback;

    return ClipOval(
      child: Image.network(
        'https://github.com/$handle.png?size=200',
        width: _radius * 2,
        height: _radius * 2,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) =>
            progress == null ? child : fallback,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }

  Widget _initial(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Text(
      username.isEmpty ? '?' : username[0].toUpperCase(),
      style: textTheme.headlineMedium?.copyWith(
        color: colorScheme.onPrimaryContainer,
      ),
    );
  }
}
