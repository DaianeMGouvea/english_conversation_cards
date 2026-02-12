import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../theme/app_theme.dart';
import '../services/tts_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardTile extends StatefulWidget {
  final ConversationCard card;
  final VoidCallback onToggleUsed;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardTile({
    super.key,
    required this.card,
    required this.onToggleUsed,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> with SingleTickerProviderStateMixin {
  double _dragOffset = 0;
  bool _showTranslation = false;
  
  Color get _categoryColor {
    switch (widget.card.category) {
      case CardCategory.green:
        return AppTheme.greenCard;
      case CardCategory.blue:
        return AppTheme.blueCard;
      case CardCategory.orange:
        return AppTheme.orangeCard;
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dx;
      _dragOffset = _dragOffset.clamp(-150.0, 150.0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 50) {
      setState(() {
        _showTranslation = !_showTranslation;
      });
    }
    setState(() {
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTranslation = widget.card.translation != null && widget.card.translation!.isNotEmpty;
    
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: widget.card.isUsed ? 0.5 : 1.0,
      child: Card(
        child: GestureDetector(
          onHorizontalDragUpdate: hasTranslation ? _onHorizontalDragUpdate : null,
          onHorizontalDragEnd: hasTranslation ? _onHorizontalDragEnd : null,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              TtsService().speak(widget.card.phrase);
            },
            onLongPress: () => _showOptionsDialog(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _showTranslation 
                      ? _categoryColor.withValues(alpha: 0.6)
                      : _categoryColor.withValues(alpha: 0.3),
                  width: _showTranslation ? 2 : 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: widget.card.isUsed,
                            onChanged: (_) => widget.onToggleUsed(),
                            activeColor: _categoryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        )
                            .animate(target: widget.card.isUsed ? 1 : 0)
                            .scaleXY(end: 1.2, duration: 100.ms, curve: Curves.easeOut)
                            .then()
                            .scaleXY(end: 1.0, duration: 100.ms, curve: Curves.easeIn),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.card.phrase,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              decoration: widget.card.isUsed 
                                  ? TextDecoration.lineThrough 
                                  : TextDecoration.none,
                              color: widget.card.isUsed 
                                  ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                                  : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (hasTranslation && !widget.card.isUsed)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              _showTranslation 
                                  ? Icons.translate 
                                  : Icons.swipe_rounded,
                              size: 18,
                              color: _categoryColor.withValues(alpha: 0.5),
                            ),
                          ),
                        if (!widget.card.isUsed)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Icon(
                              Icons.volume_up_rounded,
                              size: 20,
                              color: _categoryColor.withValues(alpha: 0.6),
                            ),
                          ),
                        Container(
                          width: 8,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _categoryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: hasTranslation
                          ? Padding(
                              padding: const EdgeInsets.only(
                                left: 56,
                                top: 4,
                                bottom: 4,
                                right: 16,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _categoryColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.translate,
                                      size: 16,
                                      color: _categoryColor,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.card.translation!,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: _categoryColor.withValues(alpha: 0.9),
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      crossFadeState: _showTranslation
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 200),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    widget.card.phrase,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ListTile(
                  leading: Icon(
                    widget.card.isUsed 
                        ? Icons.check_circle_outline 
                        : Icons.radio_button_unchecked,
                    color: _categoryColor,
                  ),
                  title: Text(
                    widget.card.isUsed ? 'Marcar como não usada' : 'Marcar como usada'
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onToggleUsed();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit_outlined, color: Colors.blue.shade600),
                  title: const Text('Editar'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onEdit();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red.shade600),
                  title: Text(
                    'Deletar',
                    style: TextStyle(color: Colors.red.shade600),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja deletar esta frase?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }
}

