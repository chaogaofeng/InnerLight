import 'dart:typed_data';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _player = AudioPlayer();
  final Map<String, Uint8List> _soundCache = {};

  Future<void> init() async {
    // Generate and cache sounds in memory
    _cacheSound('bead', 1200, 0.03, 'square');
    _cacheSound('fish', 700, 0.15, 'sine');
    _cacheSound(
      'bell',
      220,
      4.0,
      'bell',
      decay: true,
    ); // Lower freq for bell base
  }

  Future<void> play(String sfxId) async {
    // Lazy generation if missing
    if (!_soundCache.containsKey(sfxId)) {
      if (sfxId == 'bead') _cacheSound('bead', 1200, 0.03, 'square');
      if (sfxId == 'fish') _cacheSound('fish', 700, 0.15, 'sine');
      if (sfxId == 'bell') _cacheSound('bell', 220, 4.0, 'bell', decay: true);
    }

    final bytes = _soundCache[sfxId];
    if (bytes != null) {
      // Stop previous to allow rapid re-triggering (important for beads)
      await _player.stop();
      await _player.play(BytesSource(bytes), mode: PlayerMode.lowLatency);
    }
  }

  void _cacheSound(
    String id,
    double freq,
    double durationSec,
    String type, {
    bool decay = false,
  }) {
    final bytes = _createWavBytes(freq, durationSec, type, decay);
    _soundCache[id] = bytes;
  }

  Uint8List _createWavBytes(
    double freq,
    double durationSec,
    String type,
    bool decay,
  ) {
    const int sampleRate = 44100;
    const int numChannels = 1;
    final int numSamples = (durationSec * sampleRate).toInt();
    final int byteRate = sampleRate * numChannels * 2; // 16-bit
    final int blockAlign = numChannels * 2;
    final int dataSize = numSamples * blockAlign;
    final int fileSize = 36 + dataSize;

    final buffer = ByteData(fileSize + 8);
    int offset = 0;

    // RIFF header
    _writeString(buffer, offset, 'RIFF');
    offset += 4;
    buffer.setUint32(offset, fileSize, Endian.little);
    offset += 4;
    _writeString(buffer, offset, 'WAVE');
    offset += 4;

    // fmt chunk
    _writeString(buffer, offset, 'fmt ');
    offset += 4;
    buffer.setUint32(offset, 16, Endian.little);
    offset += 4; // chunk size
    buffer.setUint16(offset, 1, Endian.little);
    offset += 2; // PCM
    buffer.setUint16(offset, numChannels, Endian.little);
    offset += 2;
    buffer.setUint32(offset, sampleRate, Endian.little);
    offset += 4;
    buffer.setUint32(offset, byteRate, Endian.little);
    offset += 4;
    buffer.setUint16(offset, blockAlign, Endian.little);
    offset += 2;
    buffer.setUint16(offset, 16, Endian.little);
    offset += 2; // bits per sample

    // data chunk
    _writeString(buffer, offset, 'data');
    offset += 4;
    buffer.setUint32(offset, dataSize, Endian.little);
    offset += 4;

    // Samples
    for (int i = 0; i < numSamples; i++) {
      final t = i / sampleRate;
      double sample = 0;

      if (type == 'sine') {
        sample = sin(2 * pi * freq * t);
      } else if (type == 'square') {
        sample = (sin(2 * pi * freq * t) >= 0) ? 1.0 : -1.0;
      }

      // Envelope
      if (decay) {
        // Exponential decay
        sample *= exp(-3 * t);
      } else {
        // Simple attack/release
        if (t < 0.01) {
          sample *= (t / 0.01);
        } else if (t > durationSec - 0.01) {
          sample *= ((durationSec - t) / 0.01);
        }
      }

      // Volume
      sample *= 0.5;

      // 16-bit signed integer (-32768 to 32767)
      final int value = (sample * 32767).clamp(-32768, 32767).toInt();
      buffer.setInt16(offset, value, Endian.little);
      offset += 2;
    }

    return buffer.buffer.asUint8List();
  }

  void _writeString(ByteData buffer, int offset, String s) {
    for (int i = 0; i < s.length; i++) {
      buffer.setUint8(offset + i, s.codeUnitAt(i));
    }
  }
}
