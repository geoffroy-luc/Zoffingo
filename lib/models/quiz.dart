import 'word.dart';
import 'language_direction.dart';

class Quiz {
  String name;
  List<Word> words;
  int maxAttempts;
  LanguageDirection direction;
  int wordCount;

  Quiz({
    required this.name,
    required this.words,
    this.maxAttempts = 3, // Valeur par défaut
    this.direction = LanguageDirection.random, // Valeur par défaut
    this.wordCount = 10, // Valeur par défaut
  });

  // Convertir un objet Quiz en Map pour la sérialisation
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'words': words.map((word) => word.toJson()).toList(),
      'maxAttempts': maxAttempts,
      'direction': direction.index, // Stocker l'index de l'énumération
      'wordCount': wordCount,
    };
  }

  // Créer un objet Quiz à partir d'un Map (désérialisation)
  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      name: json['name'],
      words: (json['words'] as List)
          .map((wordJson) => Word.fromJson(wordJson))
          .toList(),
      maxAttempts: json['maxAttempts'] ?? 3,
      direction: LanguageDirection
          .values[json['direction'] ?? 2], // Valeur par défaut : random
      wordCount: json['wordCount'] ?? 10,
    );
  }
}
