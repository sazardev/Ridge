import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

/// Shared OS-backed secure storage: Android Keystore-wrapped AES-GCM on
/// Android, libsecret on Linux. Feature-level infrastructure adapters build
/// their ports on top of this instead of touching the platform channel
/// directly, so only this one file knows which secure-storage backend runs.
@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}
