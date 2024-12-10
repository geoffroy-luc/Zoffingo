import 'package:flutter/material.dart';
import '../models/word.dart';

class AddWordDialog extends StatefulWidget {
  final List<String>? initialEnglish;
  final List<String>? initialKorean;

  const AddWordDialog({super.key, this.initialEnglish, this.initialKorean});

  @override
  AddWordDialogState createState() => AddWordDialogState();
}

class AddWordDialogState extends State<AddWordDialog> {
  late TextEditingController _englishController;
  late TextEditingController _koreanController;

  void _submit() {
    final englishInput = _englishController.text.trim();
    final koreanInput = _koreanController.text.trim();

    if (englishInput.isNotEmpty && koreanInput.isNotEmpty) {
      List<String> englishTranslations = englishInput
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      List<String> koreanTranslations = koreanInput
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      Navigator.of(context)
          .pop(Word(english: englishTranslations, korean: koreanTranslations));
    }
  }

  @override
  void initState() {
    super.initState();
    _englishController = TextEditingController(
      text: widget.initialEnglish?.join(', ') ?? '',
    );
    _koreanController = TextEditingController(
      text: widget.initialKorean?.join(', ') ?? '',
    );
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
            decoration: const InputDecoration(labelText: 'Mots en anglais'),
          ),
          TextField(
            controller: _koreanController,
            decoration: const InputDecoration(labelText: 'Mot en coréen'),
          ),
          const SizedBox(height: 20),
          const Text(
            '*si plusieurs significations, séparez les avec de virgules',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Ajouter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
