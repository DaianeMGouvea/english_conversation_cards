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
    // Configurações para iOS
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );

    // Definir idioma en-US
    await _flutterTts.setLanguage("en-US");

    // Buscar e selecionar a melhor voz disponível
    await _selectBestVoice();

    // Configurar para voz mais natural
    await _flutterTts.setSpeechRate(0.5);  // Velocidade natural (0.0-1.0)
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.1);       // Tom ligeiramente mais alto = mais feminino/natural

    _isInitialized = true;
  }

  Future<void> _selectBestVoice() async {
    try {
      List<dynamic> voices = await _flutterTts.getVoices;

      // Prioridade: vozes enhanced/premium > vozes femininas > qualquer en-US
      // Palavras-chave para vozes de alta qualidade
      final enhancedKeywords = [
        'enhanced',
        'premium',
        'neural',
        'wavenet',
        'network',
        'hq',
      ];

      // Vozes femininas preferidas
      final femaleVoices = [
        'samantha',           // iOS - alta qualidade
        'karen',              // iOS
        'victoria',           // iOS
        'en-us-x-sfg',        // Android Google TTS feminina
        'en-us-x-tpf',        // Android 
        'en-us-x-iom',        // Android
      ];

      Map<String, String>? selectedVoice;
      Map<String, String>? enhancedVoice;
      Map<String, String>? femaleVoice;
      Map<String, String>? fallbackVoice;

      for (var voice in voices) {
        if (voice is Map) {
          String name = (voice['name']?.toString() ?? '').toLowerCase();
          String locale = voice['locale']?.toString() ?? '';

          // Verificar se é en-US
          bool isEnUS = locale.contains('en-US') || 
                        locale.contains('en_US') ||
                        locale == 'en-US';

          if (!isEnUS) continue;

          // Guardar como fallback
          fallbackVoice ??= {
            'name': voice['name']?.toString() ?? '',
            'locale': locale,
          };

          // Verificar se é enhanced
          for (String keyword in enhancedKeywords) {
            if (name.contains(keyword)) {
              enhancedVoice = {
                'name': voice['name']?.toString() ?? '',
                'locale': locale,
              };
              break;
            }
          }

          // Verificar se é voz feminina preferida
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

      // Selecionar na ordem de prioridade
      selectedVoice = enhancedVoice ?? femaleVoice ?? fallbackVoice;

      // Aplicar a voz selecionada
      if (selectedVoice != null) {
        await _flutterTts.setVoice(selectedVoice);
        print('TTS: Voz selecionada: ${selectedVoice['name']}');
      }
    } catch (e) {
      print('TTS: Erro ao selecionar voz: $e');
    }
  }

  Future<void> speak(String text) async {
    // Aguarda inicialização se necessário
    if (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Garante que pare qualquer fala anterior antes de começar uma nova
    await _flutterTts.stop();
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
