import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_model.dart';
import '../providers/cards_provider.dart';
import '../widgets/card_tile.dart';
import '../widgets/add_card_dialog.dart';
import '../theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CategoryTab extends StatelessWidget {
  final CardCategory category;

  const CategoryTab({super.key, required this.category});

  Color get _categoryColor {
    switch (category) {
      case CardCategory.green:
        return AppTheme.greenCard;
      case CardCategory.blue:
        return AppTheme.blueCard;
      case CardCategory.orange:
        return AppTheme.orangeCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CardsProvider>(
      builder: (context, provider, child) {
        final cards = provider.getCardsByCategory(category);
        final usedCount = provider.getUsedCount(category);
        final totalCount = provider.getTotalCount(category);

        if (provider.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: _categoryColor),
          );
        }

        if (cards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: _categoryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma frase ainda',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toque no + para adicionar',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // Header with progress and reset
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  // Progress indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: _categoryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$usedCount / $totalCount usadas',
                          style: TextStyle(
                            color: _categoryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Reset button
                  if (usedCount > 0)
                    TextButton.icon(
                      onPressed: () => _confirmReset(context, provider),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Reset'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            // Cards list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 88),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return CardTile(
                    card: card,
                    onToggleUsed: () => provider.toggleUsed(card.id),
                    onEdit: () => _editCard(context, provider, card),
                    onDelete: () => provider.deleteCard(card.id),
                  )
                      .animate(delay: (50 * index).ms)
                      .fadeIn(duration: 300.ms, curve: Curves.easeOut)
                      .slideX(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _editCard(
    BuildContext context,
    CardsProvider provider,
    ConversationCard card,
  ) async {
    final result = await showDialog<Map<String, String?>>(
      context: context,
      builder: (context) => AddCardDialog(
        category: category,
        initialPhrase: card.phrase,
        initialTranslation: card.translation,
        isEditing: true,
      ),
    );

    if (result != null) {
      provider.updateCard(
        card.id,
        result['phrase']!,
        translation: result['translation'],
      );
    }
  }

  void _confirmReset(BuildContext context, CardsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Resetar categoria'),
          content: Text(
            'Deseja desmarcar todas as frases de "${category.displayName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                provider.resetAllCards(category);
              },
              style: FilledButton.styleFrom(
                backgroundColor: _categoryColor,
              ),
              child: const Text('Resetar'),
            ),
          ],
        );
      },
    );
  }
}
