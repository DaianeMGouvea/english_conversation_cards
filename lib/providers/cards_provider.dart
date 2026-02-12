import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/card_model.dart';
import '../data/initial_cards.dart';

class CardsProvider extends ChangeNotifier {
  static const String _boxName = 'conversation_cards';
  static const String _settingsBoxName = 'settings';
  static const String _initializedKey = 'cards_initialized';
  static const _uuid = Uuid();

  VoidCallback? onCardPracticed;

  late Box<ConversationCard> _cardsBox;
  late Box _settingsBox;
  
  List<ConversationCard> _cards = [];
  bool _isLoading = true;

  List<ConversationCard> get cards => _cards;
  bool get isLoading => _isLoading;

  List<ConversationCard> getCardsByCategory(CardCategory category) {
    return _cards.where((card) => card.category == category).toList();
  }

  int getUsedCount(CardCategory category) {
    return getCardsByCategory(category).where((c) => c.isUsed).length;
  }

  int getTotalCount(CardCategory category) {
    return getCardsByCategory(category).length;
  }

  Future<void> loadCards() async {
    _isLoading = true;
    notifyListeners();

    try {
      _cardsBox = await Hive.openBox<ConversationCard>(_boxName);
      _settingsBox = await Hive.openBox(_settingsBoxName);
      
      final initialized = _settingsBox.get(_initializedKey, defaultValue: false);

      if (!initialized) {
        final initialCards = getInitialCards();
        for (final card in initialCards) {
          await _cardsBox.put(card.id, card);
        }
        await _settingsBox.put(_initializedKey, true);
      }
      
      _cards = _cardsBox.values.toList();
    } catch (e) {
      debugPrint('Error loading cards: $e');
      _cards = getInitialCards();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCard(String phrase, CardCategory category, {String? translation}) async {
    final newCard = ConversationCard(
      id: _uuid.v4(),
      phrase: phrase,
      category: category,
      translation: translation,
    );
    await _cardsBox.put(newCard.id, newCard);
    _cards = _cardsBox.values.toList();
    notifyListeners();
  }

  Future<void> updateCard(String id, String newPhrase, {String? translation}) async {
    final card = _cardsBox.get(id);
    if (card != null) {
      final updatedCard = card.copyWith(phrase: newPhrase, translation: translation);
      await _cardsBox.put(id, updatedCard);
      _cards = _cardsBox.values.toList();
      notifyListeners();
    }
  }

  Future<void> deleteCard(String id) async {
    await _cardsBox.delete(id);
    _cards = _cardsBox.values.toList();
    notifyListeners();
  }

  Future<void> toggleUsed(String id) async {
    final card = _cardsBox.get(id);
    if (card != null) {
      final newIsUsed = !card.isUsed;
      final updatedCard = card.copyWith(isUsed: newIsUsed);
      await _cardsBox.put(id, updatedCard);
      _cards = _cardsBox.values.toList();
      notifyListeners();

      if (newIsUsed && onCardPracticed != null) {
        onCardPracticed!();
      }
    }
  }

  Future<void> resetAllCards(CardCategory category) async {
    for (final card in _cardsBox.values) {
      if (card.category == category && card.isUsed) {
        final updatedCard = card.copyWith(isUsed: false);
        await _cardsBox.put(card.id, updatedCard);
      }
    }
    _cards = _cardsBox.values.toList();
    notifyListeners();
  }

  Future<void> resetAllCardsGlobally() async {
    for (final card in _cardsBox.values) {
      if (card.isUsed) {
        final updatedCard = card.copyWith(isUsed: false);
        await _cardsBox.put(card.id, updatedCard);
      }
    }
    _cards = _cardsBox.values.toList();
    notifyListeners();
  }
}
