import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../theme/app_theme.dart';

class AddCardDialog extends StatefulWidget {
  final CardCategory category;
  final String? initialPhrase;
  final String? initialTranslation;
  final bool isEditing;

  const AddCardDialog({
    super.key,
    required this.category,
    this.initialPhrase,
    this.initialTranslation,
    this.isEditing = false,
  });

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  late final TextEditingController _phraseController;
  late final TextEditingController _translationController;
  final _formKey = GlobalKey<FormState>();

  Color get _categoryColor {
    switch (widget.category) {
      case CardCategory.green:
        return AppTheme.greenCard;
      case CardCategory.blue:
        return AppTheme.blueCard;
      case CardCategory.orange:
        return AppTheme.orangeCard;
    }
  }

  @override
  void initState() {
    super.initState();
    _phraseController = TextEditingController(text: widget.initialPhrase);
    _translationController = TextEditingController(text: widget.initialTranslation);
  }

  @override
  void dispose() {
    _phraseController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _categoryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(widget.isEditing ? 'Editar frase' : 'Nova frase'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.category.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phraseController,
                autofocus: true,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Frase em inglês',
                  hintText: 'Ex: How are you doing?',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _categoryColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite uma frase';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _translationController,
                maxLines: 3,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Tradução em português (opcional)',
                  hintText: 'Ex: Como você está?',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: _categoryColor.withValues(alpha: 0.6), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: _categoryColor,
          ),
          child: Text(widget.isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final phrase = _phraseController.text.trim();
      final translation = _translationController.text.trim();
      Navigator.pop(context, {
        'phrase': phrase,
        'translation': translation.isNotEmpty ? translation : null,
      });
    }
  }
}
