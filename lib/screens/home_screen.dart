// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_parameter_screen.dart';
import '../models/quiz.dart';
import '../models/language_direction.dart';
import 'dart:convert';
import '../widgets/quiz_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? quizzesJson = prefs.getString('quizzes');
    if (quizzesJson != null) {
      List decodedList = jsonDecode(quizzesJson) as List;
      _quizzes = decodedList.map((item) => Quiz.fromJson(item)).toList();
    } else {
      _quizzes = [];
    }
    setState(() {});
  }

  Future<void> _saveQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> quizzesMap =
        _quizzes.map((quiz) => quiz.toJson()).toList();
    String quizzesJson = jsonEncode(quizzesMap);
    await prefs.setString('quizzes', quizzesJson);
  }

  void _goToQuizParameter(Quiz quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizParameterScreen(
          quiz: quiz,
          onQuizzesUpdated: _saveQuizzes,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _duplicateQuiz(Quiz quiz) {
    setState(() {
      _quizzes.add(
        Quiz(
          name: '${quiz.name} (copie)',
          words: List.from(quiz.words),
          maxAttempts: quiz.maxAttempts,
          direction: quiz.direction,
          wordCount: quiz.wordCount,
        ),
      );
    });
    _saveQuizzes();
  }

  void _deleteQuiz(Quiz quiz) {
    setState(() {
      _quizzes.remove(quiz);
    });
    _saveQuizzes();
  }

  Future<void> _renameQuiz(Quiz quiz) async {
    String newName = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: quiz.name);
        return AlertDialog(
          title: const Text('Renommer le quiz'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nouveau nom'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, quiz.name),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (newName.isNotEmpty && newName != quiz.name) {
      setState(() {
        quiz.name = newName;
      });
      await _saveQuizzes();
    }
  }

  void _showQuizOptions(Quiz quiz) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Renommer'),
                onTap: () {
                  Navigator.pop(context);
                  _renameQuiz(quiz);
                },
              ),
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Dupliquer'),
                onTap: () {
                  Navigator.pop(context);
                  _duplicateQuiz(quiz);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Supprimer'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteQuiz(quiz);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addQuiz() {
    setState(() {
      _quizzes.add(
        Quiz(
          name: 'Nouveau Quiz',
          words: [],
          maxAttempts: 3,
          direction: LanguageDirection.random,
          wordCount: 10,
        ),
      );
    });
    _saveQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 30,
            onPressed: _addQuiz,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          final quiz = _quizzes[index];
          return QuizListItem(
            quiz: quiz,
            onTap: () => _goToQuizParameter(quiz),
            onLongPress: () => _showQuizOptions(quiz),
          );
        },
      ),
    );
  }
}
