import 'package:flutter/material.dart';
import '../models/word.dart';
import '../models/quiz.dart';
import '../widgets/add_word_dialog.dart';

class WordsScreen extends StatefulWidget {
  final Quiz quiz;
  final Future<void> Function() onQuizzesUpdated;

  const WordsScreen(
      {super.key, required this.quiz, required this.onQuizzesUpdated});

  @override
  WordsScreenState createState() => WordsScreenState();
}

class WordsScreenState extends State<WordsScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _addWord(Word word) {
    setState(() {
      widget.quiz.words.add(word);
      widget.quiz.words.sort((a, b) {
        String aKey = a.english.isNotEmpty ? a.english.first : '';
        String bKey = b.english.isNotEmpty ? b.english.first : '';
        return aKey.compareTo(bKey);
      });
    });
    widget.onQuizzesUpdated();
  }

  void _removeWord(Word word) {
    setState(() {
      widget.quiz.words.remove(word);
    });
    widget.onQuizzesUpdated();
  }

  Future<void> _editWord(Word word) async {
    final editedWord = await showDialog<Word>(
      context: context,
      builder: (context) => AddWordDialog(
        initialEnglish: word.english,
        initialKorean: word.korean,
      ),
    );

    if (editedWord != null) {
      setState(() {
        int index = widget.quiz.words.indexOf(word);
        if (index != -1) {
          widget.quiz.words[index] = editedWord;
          widget.quiz.words.sort((a, b) {
            String aKey = a.korean.isNotEmpty ? a.korean.first : '';
            String bKey = b.korean.isNotEmpty ? b.korean.first : '';
            return aKey.compareTo(bKey);
          });
          widget.quiz.words.sort((a, b) {
            String aKey = a.english.isNotEmpty ? a.english.first : '';
            String bKey = b.english.isNotEmpty ? b.english.first : '';
            return aKey.compareTo(bKey);
          });
        }
      });
      widget.onQuizzesUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newWord = await showDialog<Word>(
                context: context,
                builder: (context) => const AddWordDialog(),
              );
              if (newWord != null) {
                _addWord(newWord);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.quiz.words.length,
        itemBuilder: (context, index) {
          final word = widget.quiz.words[index];
          return ListTile(
            title:
                Text('${word.english.join(', ')} - ${word.korean.join(', ')}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editWord(word),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _removeWord(word),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
