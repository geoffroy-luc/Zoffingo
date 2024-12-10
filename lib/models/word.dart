class Word {
  List<String> english;
  List<String> korean;

  Word({
    required this.english,
    required this.korean,
  });

  Map<String, dynamic> toJson() {
    return {
      'english': english,
      'korean': korean,
    };
  }

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      english: List<String>.from(json['english']),
      korean: List<String>.from(json['korean']),
    );
  }
}
