import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// A failure reported by a callable Cloud Function, carrying its
/// machine-readable status (`invalid-argument`, `already-exists`,
/// `permission-denied`, ...) so callers can map it to an `AppFailure`.
class CallableFunctionException implements Exception {
  /// Creates the exception from the function's own error payload.
  const new({required this.status, required this.message});

  /// The canonical gRPC-style status the function threw with.
  final String status;

  /// The human-readable message (English, server-side).
  final String message;

  @override
  String toString() => 'CallableFunctionException($status): $message';
}

/// Minimal client for the Firebase *callable* HTTPS protocol
/// (`{"data": ...}` in, `{"result": ...}` out — the documented wire
/// format every Firebase Functions SDK speaks).
///
/// Deliberately hand-rolled in pure Dart instead of using
/// `cloud_functions`: that plugin has no Windows implementation, and
/// Ridge needs one uniform auth path across Android, Web and Windows
/// (STACK.md §5.2). The protocol is stable, the two functions it calls
/// are simple request/response, and being plain `package:http` it is
/// trivially fakeable in tests.
class CallableFunctionsClient {
  /// Creates the client for the given [projectId]/[region]; [httpClient]
  /// is injectable for tests.
  new({required this.projectId, required this.region, http.Client? httpClient})
    : _http = httpClient ?? http.Client();

  /// The Firebase project hosting the functions.
  final String projectId;

  /// The Cloud Functions region they are deployed to.
  final String region;

  final http.Client _http;

  /// How long to wait for a response before giving up — these are
  /// interactive auth flows, so hanging is worse than failing.
  static const _timeout = Duration(seconds: 20);

  /// Invokes the callable function [name] with [data], optionally
  /// authenticated with [idToken] (a Firebase ID token), returning its
  /// `result` map.
  ///
  /// Throws [CallableFunctionException] when the function answered with
  /// an error payload, and [TimeoutException]/[http.ClientException] on
  /// the transport failing.
  Future<Map<String, Object?>> call(
    String name, {
    Map<String, Object?> data = const {},
    String? idToken,
  }) async {
    final uri = Uri.https('$region-$projectId.cloudfunctions.net', '/$name');
    final response = await _http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            if (idToken != null) 'Authorization': 'Bearer $idToken',
          },
          body: jsonEncode({'data': data}),
        )
        .timeout(_timeout);

    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw CallableFunctionException(
        status: 'internal',
        message: 'Malformed response (HTTP ${response.statusCode})',
      );
    }
    if (decoded is! Map<String, Object?>) {
      throw const CallableFunctionException(
        status: 'internal',
        message: 'Malformed response body',
      );
    }

    final error = decoded['error'];
    if (error is Map<String, Object?>) {
      throw CallableFunctionException(
        status: error['status'] as String? ?? 'internal',
        message: error['message'] as String? ?? 'Unknown function error',
      );
    }

    final result = decoded['result'];
    if (result is Map<String, Object?>) return result;
    return const {};
  }
}
