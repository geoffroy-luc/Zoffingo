class Word {
  List<String> english;
  String korean;

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
      korean: json['korean'],
    );
  }
}
