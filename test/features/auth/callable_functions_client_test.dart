// Unit tests for `CallableFunctionsClient` — the hand-rolled client for
// the Firebase callable HTTPS protocol (chosen over `cloud_functions`
// for Windows parity, see the file's own doc). A `MockClient` pins the
// request shape (regional URL, `{"data": ...}` envelope, bearer token)
// and the response unwrapping, with no network involved.
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ridge/features/auth/infrastructure/callable_functions_client.dart';

void main() {
  CallableFunctionsClient clientReturning(
    Map<String, Object?> body, {
    void Function(http.Request request)? onRequest,
  }) {
    return CallableFunctionsClient(
      projectId: 'ridge-typing',
      region: 'southamerica-east1',
      httpClient: MockClient((request) async {
        onRequest?.call(request);
        return http.Response(jsonEncode(body), 200);
      }),
    );
  }

  test('posts the data envelope to the regional callable URL', () async {
    late http.Request captured;
    final client = clientReturning({
      'result': {'ok': true},
    }, onRequest: (request) => captured = request);

    final result = await client.call('register', data: {'username': 'omar'});

    expect(
      captured.url.toString(),
      'https://southamerica-east1-ridge-typing.cloudfunctions.net/register',
    );
    expect(captured.headers['Content-Type'], 'application/json');
    expect(jsonDecode(captured.body), {
      'data': {'username': 'omar'},
    });
    expect(result, {'ok': true});
  });

  test('adds the bearer token only when one is given', () async {
    late http.Request withToken;
    late http.Request withoutToken;
    await clientReturning(
      {'result': <String, Object?>{}},
      onRequest: (request) => withToken = request,
    ).call('deleteAccount', idToken: 'id-token-1');
    await clientReturning({
      'result': <String, Object?>{},
    }, onRequest: (request) => withoutToken = request).call('register');

    expect(withToken.headers['Authorization'], 'Bearer id-token-1');
    expect(withoutToken.headers.containsKey('Authorization'), isFalse);
  });

  test('maps a function error payload to CallableFunctionException', () async {
    final client = clientReturning({
      'error': {
        'status': 'already-exists',
        'message': 'Username already taken',
      },
    });

    expect(
      () => client.call('register'),
      throwsA(
        isA<CallableFunctionException>()
            .having((e) => e.status, 'status', 'already-exists')
            .having((e) => e.message, 'message', 'Username already taken'),
      ),
    );
  });

  test('throws on a malformed body', () async {
    final client = CallableFunctionsClient(
      projectId: 'ridge-typing',
      region: 'southamerica-east1',
      httpClient: MockClient((_) async => http.Response('not json', 500)),
    );

    expect(
      () => client.call('register'),
      throwsA(isA<CallableFunctionException>()),
    );
  });

  test('returns an empty map when the function has no result body', () async {
    final client = clientReturning({'result': null});

    expect(await client.call('register'), isEmpty);
  });
}
