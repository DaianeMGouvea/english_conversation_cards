import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  late FlutterTts _flutterTts;
  bool _isInitialized = false;

  factory TtsService() {
    return _instance;
  }

  TtsService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playback, [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ], IosTextToSpeechAudioMode.defaultMode);

    await _flutterTts.setLanguage("en-US");

    await _selectBestVoice();

    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(
      1.1,
    );

    _isInitialized = true;
  }

  Future<void> _selectBestVoice() async {
    try {
      List<dynamic> voices = await _flutterTts.getVoices;

      final enhancedKeywords = [
        'enhanced',
        'premium',
        'neural',
        'wavenet',
        'network',
        'hq',
      ];

      final femaleVoices = [
        'samantha',
        'karen',
        'victoria',
        'en-us-x-sfg',
        'en-us-x-tpf',
        'en-us-x-iom',
      ];

      Map<String, String>? selectedVoice;
      Map<String, String>? enhancedVoice;
      Map<String, String>? femaleVoice;
      Map<String, String>? fallbackVoice;

      for (var voice in voices) {
        if (voice is Map) {
          String name = (voice['name']?.toString() ?? '').toLowerCase();
          String locale = voice['locale']?.toString() ?? '';

          bool isEnUS =
              locale.contains('en-US') ||
              locale.contains('en_US') ||
              locale == 'en-US';

          if (!isEnUS) continue;

          fallbackVoice ??= {
            'name': voice['name']?.toString() ?? '',
            'locale': locale,
          };

          for (String keyword in enhancedKeywords) {
            if (name.contains(keyword)) {
              enhancedVoice = {
                'name': voice['name']?.toString() ?? '',
                'locale': locale,
              };
              break;
            }
          }

          for (String female in femaleVoices) {
            if (name.contains(female)) {
              femaleVoice = {
                'name': voice['name']?.toString() ?? '',
                'locale': locale,
              };
              break;
            }
          }
        }
      }

      selectedVoice = enhancedVoice ?? femaleVoice ?? fallbackVoice;

      if (selectedVoice != null) {
        await _flutterTts.setVoice(selectedVoice);
      }
    } catch (e) {
      log('TTS: Erro ao selecionar voz: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    await _flutterTts.stop();
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
