import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
enum CardCategory {
  @HiveField(0)
  green,
  @HiveField(1)
  blue,
  @HiveField(2)
  orange,
}

extension CardCategoryExtension on CardCategory {
  String get displayName {
    switch (this) {
      case CardCategory.green:
        return 'Green Cards';
      case CardCategory.blue:
        return 'Blue Cards';
      case CardCategory.orange:
        return 'Orange Cards';
    }
  }

  String get description {
    switch (this) {
      case CardCategory.green:
        return 'Perguntas / Iniciadoras de conversa';
      case CardCategory.blue:
        return 'Respostas / Reações';
      case CardCategory.orange:
        return 'Despedidas';
    }
  }
}

@HiveType(typeId: 1)
class ConversationCard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String phrase;

  @HiveField(2)
  final CardCategory category;

  @HiveField(3)
  bool isUsed;

  @HiveField(4)
  final String? translation;

  ConversationCard({
    required this.id,
    required this.phrase,
    required this.category,
    this.isUsed = false,
    this.translation,
  });

  ConversationCard copyWith({
    String? id,
    String? phrase,
    CardCategory? category,
    bool? isUsed,
    String? translation,
  }) {
    return ConversationCard(
      id: id ?? this.id,
      phrase: phrase ?? this.phrase,
      category: category ?? this.category,
      isUsed: isUsed ?? this.isUsed,
      translation: translation ?? this.translation,
    );
  }
}
