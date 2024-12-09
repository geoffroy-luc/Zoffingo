import 'package:flutter/material.dart';
import '../models/quiz.dart';
import '../models/language_direction.dart';

class QuizListItem extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const QuizListItem({
    super.key,
    required this.quiz,
    required this.onTap,
    required this.onLongPress,
  });

  String _getDirectionText(LanguageDirection direction) {
    switch (direction) {
      case LanguageDirection.englishToKorean:
        return 'Anglais → Coréen';
      case LanguageDirection.koreanToFrench:
        return 'Coréen → Anglais';
      case LanguageDirection.random:
        return 'Aléatoire';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      quiz.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${quiz.wordCount} mots',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _getDirectionText(quiz.direction),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Essais max: ${quiz.maxAttempts}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
