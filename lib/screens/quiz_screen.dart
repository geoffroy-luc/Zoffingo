import 'package:flutter/material.dart';
import '../models/word.dart';
import 'result_screen.dart';
import 'dart:math';
import '../models/language_direction.dart';

class QuizScreen extends StatefulWidget {
  final List<Word> words;
  final LanguageDirection direction;
  final int maxAttempts;

  const QuizScreen({
    super.key,
    required this.words,
    required this.direction,
    required this.maxAttempts,
  });

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  int _score = 0;
  int _currentIndex = 0;
  int _attemptsLeft = 0;
  bool _isAnswerCorrect = false;
  bool _showAnswerFeedback = false;
  String _userAnswer = '';
  List<String> _remainingTranslations = [];
  late bool _askInEnglish;
  late List<Word> _wordsToTest;
  final _random = Random();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _wordsToTest = List.from(widget.words)..shuffle();
    _setDirectionForCurrentWord();
  }

  void _setDirectionForCurrentWord() {
    if (_currentIndex >= _wordsToTest.length) return;

    Word currentWord = _wordsToTest[_currentIndex];
    switch (widget.direction) {
      case LanguageDirection.englishToKorean:
        _askInEnglish = true;
        _remainingTranslations = [currentWord.korean];
        break;
      case LanguageDirection.koreanToFrench:
        _askInEnglish = false;
        _remainingTranslations = List.from(currentWord.english);
        break;
      case LanguageDirection.random:
        _askInEnglish = _random.nextBool();
        if (_askInEnglish) {
          _remainingTranslations = [currentWord.korean];
        } else {
          _remainingTranslations = List.from(currentWord.english);
        }
        break;
    }

    _attemptsLeft = _remainingTranslations.length * widget.maxAttempts;
  }

  void _checkAnswer() {
    final currentWord = _wordsToTest[_currentIndex];
    _userAnswer = _userAnswer.trim().toLowerCase();

    if (_askInEnglish) {
      // Traduction de Anglais vers Coréen
      String correctAnswer = currentWord.korean.toLowerCase();
      bool isCorrect = _userAnswer == correctAnswer;

      if (isCorrect) {
        setState(() {
          _isAnswerCorrect = true;
          _showAnswerFeedback = true;
          _score++;

          _remainingTranslations.removeWhere(
              (translation) => translation.toLowerCase() == correctAnswer);

          _attemptsLeft--;
        });
      } else {
        setState(() {
          _isAnswerCorrect = false;
          _showAnswerFeedback = true;

          _attemptsLeft--;
        });
      }
    } else {
      // Traduction de Coréen vers Anglais
      List<String> correctAnswers =
          currentWord.english.map((e) => e.toLowerCase()).toList();
      bool isCorrect = correctAnswers.contains(_userAnswer);

      if (isCorrect) {
        setState(() {
          _isAnswerCorrect = true;
          _showAnswerFeedback = true;
          _score++;

          _remainingTranslations.removeWhere(
              (translation) => translation.toLowerCase() == _userAnswer);

          _attemptsLeft--;
        });
      } else {
        setState(() {
          _isAnswerCorrect = false;
          _showAnswerFeedback = true;

          _attemptsLeft--;
        });
      }
    }

    // **Retirer les appels à _moveToNextWord() ici**
  }

  void _nextStep() {
    _answerController.clear();
    setState(() {
      _userAnswer = '';
      _showAnswerFeedback = false;
    });

    // Vérifier si toutes les traductions ont été saisies ou si les essais sont épuisés
    if (_remainingTranslations.isEmpty || _attemptsLeft <= 0) {
      _moveToNextWord();
    } else {
      // Il reste des traductions à saisir pour le même mot
      // Rien à faire ici, l'utilisateur peut continuer à répondre
    }
  }

  void _moveToNextWord() {
    _currentIndex++;
    if (_currentIndex < _wordsToTest.length) {
      _setDirectionForCurrentWord();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultScreen(score: _score, total: _wordsToTest.length),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // **Assurer que _currentIndex est valide avant d'accéder à _wordsToTest[_currentIndex]**
    if (_currentIndex >= _wordsToTest.length) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentWord = _wordsToTest[_currentIndex];
    bool multipleAnswers = !_askInEnglish && currentWord.english.length > 1;
    final wordToShow =
        _askInEnglish ? currentWord.english.first : currentWord.korean;

    String instruction;
    if (_askInEnglish) {
      instruction = 'Traduisez ce mot anglais en coréen:';
    } else {
      if (multipleAnswers) {
        int step =
            currentWord.english.length - _remainingTranslations.length + 1;
        instruction =
            'Traduisez ce mot coréen en anglais:\n(Étape $step/${currentWord.english.length})';
      } else {
        instruction = 'Traduisez ce mot coréen en anglais:';
      }
    }

    String correctAnswer;
    if (_askInEnglish) {
      correctAnswer = currentWord.korean;
    } else {
      if (multipleAnswers) {
        correctAnswer = _remainingTranslations.join(', ');
      } else {
        correctAnswer = currentWord.english.first;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              instruction,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              wordToShow,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _answerController,
              enabled: !_showAnswerFeedback,
              decoration: const InputDecoration(
                labelText: 'Votre réponse',
              ),
              onChanged: (value) {
                _userAnswer = value;
              },
              onSubmitted: (_) {
                if (!_showAnswerFeedback) {
                  _checkAnswer();
                }
              },
            ),
            const SizedBox(height: 16),
            if (!_showAnswerFeedback)
              ElevatedButton(
                onPressed: _checkAnswer,
                child: const Text('Valider'),
              ),
            if (_showAnswerFeedback)
              Column(
                children: [
                  Text(
                    _isAnswerCorrect
                        ? 'Correct!'
                        : 'Faux! La bonne réponse est: $correctAnswer.',
                    style: TextStyle(
                      color: _isAnswerCorrect ? Colors.green : Colors.red,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _nextStep,
                    child: _remainingTranslations.isNotEmpty
                        ? const Text('Traduction suivante')
                        : const Text('Mot suivant'),
                  ),
                ],
              ),
            const Spacer(),
            // Afficher le nombre d'essais restants
            Text(
              'Essais restants: $_attemptsLeft',
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: $_score / ${_wordsToTest.length}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
