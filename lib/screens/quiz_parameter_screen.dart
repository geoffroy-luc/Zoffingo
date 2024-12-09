// quiz_parameter_screen.dart

import 'package:flutter/material.dart';
import 'words_screen.dart';
import 'quiz_screen.dart';
import '../models/quiz.dart';
import '../models/language_direction.dart';
import '../models/word.dart';

class QuizParameterScreen extends StatefulWidget {
  final Quiz quiz;
  final Future<void> Function() onQuizzesUpdated;

  const QuizParameterScreen({
    super.key,
    required this.quiz,
    required this.onQuizzesUpdated,
  });

  @override
  QuizParameterScreenState createState() => QuizParameterScreenState();
}

class QuizParameterScreenState extends State<QuizParameterScreen> {
  int _wordCount = 10;
  LanguageDirection _direction = LanguageDirection.random;
  int _maxAttempts = 3;

  @override
  void initState() {
    super.initState();
    if (widget.quiz.words.isNotEmpty) {
      _wordCount =
          widget.quiz.wordCount.clamp(1, widget.quiz.words.length).toInt();
    } else {
      _wordCount = 0;
    }
    _direction = widget.quiz.direction;
    _maxAttempts = widget.quiz.maxAttempts;
  }

  void _startQuiz() {
    if (widget.quiz.words.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun mot disponible pour ce quiz.')),
      );
      return;
    }

    List<Word> selectedWords = List.from(widget.quiz.words);
    selectedWords.shuffle();
    selectedWords = selectedWords.take(_wordCount).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          words: selectedWords,
          direction: _direction,
          maxAttempts: _maxAttempts,
        ),
      ),
    );
  }

  void _goToWordsScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordsScreen(
          quiz: widget.quiz,
          onQuizzesUpdated: widget.onQuizzesUpdated,
        ),
      ),
    ).then((_) {
      if (widget.quiz.words.length < _wordCount) {
        setState(() {
          _wordCount =
              widget.quiz.words.isNotEmpty ? widget.quiz.words.length : 0;
        });
      }
    });
  }

  void _saveParameters() async {
    if (widget.quiz.name.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom du quiz ne peut pas être vide.')),
      );
      return;
    }

    setState(() {
      widget.quiz.wordCount = _wordCount;
      widget.quiz.direction = _direction;
      widget.quiz.maxAttempts = _maxAttempts;
    });

    await widget.onQuizzesUpdated();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paramètres enregistrés.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double maxValue =
        widget.quiz.words.isNotEmpty ? widget.quiz.words.length.toDouble() : 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres - ${widget.quiz.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sélecteur du nombre de mots
            Text('Nombre de mots : (${widget.quiz.words.length} disponibles)'),
            Slider(
              value: _wordCount.toDouble(),
              min: widget.quiz.words.isEmpty ? 0 : 1,
              max: maxValue,
              divisions:
                  widget.quiz.words.isNotEmpty && widget.quiz.words.length > 1
                      ? widget.quiz.words.length - 1
                      : 1,
              label: '$_wordCount',
              onChanged: (value) {
                setState(() {
                  _wordCount = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),

            // Sélecteur de direction de traduction
            const Text(
              'Direction de traduction :',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<LanguageDirection>(
                  title: const Text('Anglais → Coréen'),
                  value: LanguageDirection.englishToKorean,
                  groupValue: _direction,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _direction = val;
                      });
                    }
                  },
                ),
                RadioListTile<LanguageDirection>(
                  title: const Text('Coréen → Anglais'),
                  value: LanguageDirection.koreanToFrench,
                  groupValue: _direction,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _direction = val;
                      });
                    }
                  },
                ),
                RadioListTile<LanguageDirection>(
                  title: const Text('Aléatoire'),
                  value: LanguageDirection.random,
                  groupValue: _direction,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _direction = val;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sélecteur pour le nombre d'essais max
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nombre d\'essais max:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<int>(
                  value: _maxAttempts,
                  items: [1, 2, 3].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _maxAttempts = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _goToWordsScreen,
                  child: const Text('Words'),
                ),
                ElevatedButton(
                  onPressed: _saveParameters,
                  child: const Text('SAVE'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _startQuiz,
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
