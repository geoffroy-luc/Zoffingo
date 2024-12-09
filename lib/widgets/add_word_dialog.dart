import 'package:flutter/material.dart';
import '../models/word.dart';

class AddWordDialog extends StatefulWidget {
  final List<String>? initialEnglish;
  final String? initialKorean;

  const AddWordDialog({super.key, this.initialEnglish, this.initialKorean});

  @override
  AddWordDialogState createState() => AddWordDialogState();
}

class AddWordDialogState extends State<AddWordDialog> {
  late TextEditingController _englishController;
  late TextEditingController _koreanController;

  void _submit() {
    final englishInput = _englishController.text.trim();
    final koreanWord = _koreanController.text.trim();

    if (englishInput.isNotEmpty && koreanWord.isNotEmpty) {
      // Séparer les traductions anglaises par des virgules
      List<String> englishTranslations = englishInput
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      Navigator.of(context)
          .pop(Word(english: englishTranslations, korean: koreanWord));
    }
  }

  @override
  void initState() {
    super.initState();
    _englishController = TextEditingController(
      text: widget.initialEnglish?.join(', ') ?? '',
    );
    _koreanController = TextEditingController(text: widget.initialKorean ?? '');
  }

  @override
  void dispose() {
    _englishController.dispose();
    _koreanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un mot'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _englishController,
            decoration: const InputDecoration(
                labelText: 'Mots en anglais (séparés par des virgules)'),
          ),
          TextField(
            controller: _koreanController,
            decoration: const InputDecoration(labelText: 'Mot en coréen'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}