// Regenerates the synthesized keystroke sound packs under
// `assets/sounds/<pack>/`. Run with `dart run tool/generate_sound_packs.dart`
// whenever a pack's waveform parameters below change. The `mechanical` pack
// is hand-recorded (not synthesized) and is left untouched by this script.
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const _sampleRate = 44100;

void main() {
  _writePack('soft', click: _softClick(), reject: _softReject());
  _writePack(
    'typewriter',
    click: _typewriterClick(),
    reject: _typewriterReject(),
  );
  _writePack('arcade', click: _arcadeClick(), reject: _arcadeReject());
  _writePack('pop', click: _popClick(), reject: _popReject());
  stdout.writeln('Done.');
}

void _writePack(
  String name, {
  required List<double> click,
  required List<double> reject,
}) {
  final dir = Directory('assets/sounds/$name')..createSync(recursive: true);
  File('${dir.path}/key_click.wav').writeAsBytesSync(_buildWav(click));
  File('${dir.path}/key_reject.wav').writeAsBytesSync(_buildWav(reject));
  stdout
    ..writeln('Wrote ${dir.path}/key_click.wav (${click.length} samples)')
    ..writeln('Wrote ${dir.path}/key_reject.wav (${reject.length} samples)');
}

// ---- Pack definitions ------------------------------------------------

List<double> _softClick() =>
    _sine(freqHz: 500, durationMs: 35, amplitude: 0.35, decayRate: 26);

List<double> _softReject() => _mix([
  _sine(
    freqHz: 220,
    durationMs: 140,
    amplitude: 0.22,
    decayRate: 9,
    attackMs: 3,
  ),
  _sine(
    freqHz: 233,
    durationMs: 140,
    amplitude: 0.22,
    decayRate: 9,
    attackMs: 3,
  ),
]);

List<double> _typewriterClick() => _mix([
  _noiseBurst(durationMs: 14, decayRate: 90, smoothing: 0, seed: 7),
  _sine(
    freqHz: 2200,
    durationMs: 20,
    amplitude: 0.28,
    decayRate: 70,
    attackMs: 0.5,
  ),
]);

List<double> _typewriterReject() =>
    _noiseBurst(durationMs: 130, decayRate: 16, smoothing: 3, seed: 11);

List<double> _arcadeClick() =>
    _square(freqHz: 880, durationMs: 35, amplitude: 0.32, fadeOutMs: 12);

List<double> _arcadeReject() => [
  ..._square(freqHz: 440, durationMs: 60, amplitude: 0.32, fadeOutMs: 4),
  ..._square(freqHz: 220, durationMs: 60, amplitude: 0.32, fadeOutMs: 14),
];

List<double> _popClick() =>
    _sweep(startFreqHz: 300, endFreqHz: 900, durationMs: 30, decayRate: 5);

List<double> _popReject() => _sweep(
  startFreqHz: 500,
  endFreqHz: 150,
  durationMs: 150,
  amplitude: 0.32,
  decayRate: 3.5,
);

// ---- Synthesis primitives ---------------------------------------------

List<double> _sine({
  required double freqHz,
  required double durationMs,
  double amplitude = 0.4,
  double decayRate = 8,
  double attackMs = 2,
}) {
  final n = (_sampleRate * durationMs / 1000).round();
  final attackSamples = (_sampleRate * attackMs / 1000).round().clamp(1, n);
  return List.generate(n, (i) {
    final t = i / _sampleRate;
    final envelope = i < attackSamples
        ? i / attackSamples
        : math.exp(-decayRate * (i - attackSamples) / _sampleRate);
    return amplitude * envelope * math.sin(2 * math.pi * freqHz * t);
  });
}

List<double> _sweep({
  required double startFreqHz,
  required double endFreqHz,
  required double durationMs,
  double amplitude = 0.4,
  double decayRate = 6,
}) {
  final n = (_sampleRate * durationMs / 1000).round();
  var phase = 0.0;
  return List.generate(n, (i) {
    final progress = i / n;
    final freq = startFreqHz + (endFreqHz - startFreqHz) * progress;
    phase += 2 * math.pi * freq / _sampleRate;
    final envelope = math.exp(-decayRate * progress);
    return amplitude * envelope * math.sin(phase);
  });
}

List<double> _square({
  required double freqHz,
  required double durationMs,
  double amplitude = 0.4,
  double fadeOutMs = 5,
}) {
  final n = (_sampleRate * durationMs / 1000).round();
  final fadeSamples = (_sampleRate * fadeOutMs / 1000).round().clamp(1, n);
  return List.generate(n, (i) {
    final t = i / _sampleRate;
    final cyclePos = (freqHz * t) % 1.0;
    final square = cyclePos < 0.5 ? 1.0 : -1.0;
    final remaining = n - i;
    final envelope = remaining < fadeSamples ? remaining / fadeSamples : 1.0;
    return amplitude * envelope * square;
  });
}

List<double> _noiseBurst({
  required double durationMs,
  double amplitude = 0.4,
  double decayRate = 20,
  int smoothing = 1,
  int seed = 1,
}) {
  final n = (_sampleRate * durationMs / 1000).round();
  final rand = math.Random(seed);
  final raw = List.generate(n, (_) => rand.nextDouble() * 2 - 1);
  final smoothed = List<double>.filled(n, 0);
  for (var i = 0; i < n; i++) {
    var sum = 0.0;
    var count = 0;
    for (var k = -smoothing; k <= smoothing; k++) {
      final idx = i + k;
      if (idx >= 0 && idx < n) {
        sum += raw[idx];
        count++;
      }
    }
    smoothed[i] = sum / count;
  }
  return List.generate(n, (i) {
    final t = i / _sampleRate;
    final envelope = math.exp(-decayRate * t);
    return amplitude * envelope * smoothed[i];
  });
}

List<double> _mix(List<List<double>> layers) {
  final n = layers.map((l) => l.length).reduce(math.max);
  return List.generate(n, (i) {
    var sum = 0.0;
    for (final layer in layers) {
      if (i < layer.length) sum += layer[i];
    }
    return sum;
  });
}

// ---- WAV encoding -------------------------------------------------------

Uint8List _buildWav(List<double> samples) {
  final dataLength = samples.length * 2;
  final buffer = BytesBuilder();

  void writeString(String s) => buffer.add(s.codeUnits);
  void writeUint32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.little);
    buffer.add(b.buffer.asUint8List());
  }

  void writeUint16(int v) {
    final b = ByteData(2)..setUint16(0, v, Endian.little);
    buffer.add(b.buffer.asUint8List());
  }

  writeString('RIFF');
  writeUint32(36 + dataLength);
  writeString('WAVE');
  writeString('fmt ');
  writeUint32(16);
  writeUint16(1);
  writeUint16(1);
  writeUint32(_sampleRate);
  writeUint32(_sampleRate * 2);
  writeUint16(2);
  writeUint16(16);
  writeString('data');
  writeUint32(dataLength);
  for (final s in samples) {
    final clamped = s.clamp(-1.0, 1.0);
    final intSample = (clamped * 32767).round();
    final b = ByteData(2)..setInt16(0, intSample, Endian.little);
    buffer.add(b.buffer.asUint8List());
  }
  return buffer.toBytes();
}
