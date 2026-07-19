class ExampleSentence {
  final String english;
  final String arabic;
  final String type;

  ExampleSentence({
    required this.english,
    required this.arabic,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'english': english,
    'arabic': arabic,
    'type': type,
  };

  factory ExampleSentence.fromJson(Map<String, dynamic> json) {
    return ExampleSentence(
      english: json['english'] as String,
      arabic: json['arabic'] as String,
      type: json['type'] as String,
    );
  }
}

class Word {
  final String english;
  final String arabic;
  final List<String> types;
  final bool hasBookmark;
  final List<String> folders;
  final List<ExampleSentence> sentences;

  Word({
    required this.english,
    required this.arabic,
    required this.types,
    this.hasBookmark = false,
    this.folders = const [],
    this.sentences = const [],
  });

  Map<String, dynamic> toJson() => {
    'english': english,
    'arabic': arabic,
    'types': types,
    'hasBookmark': hasBookmark,
    'folders': folders,
    'sentences': sentences.map((s) => s.toJson()).toList(),
  };

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      english: json['english'] as String,
      arabic: json['arabic'] as String,
      types: List<String>.from(json['types'] as List),
      hasBookmark: json['hasBookmark'] as bool? ?? false,
      folders: json['folders'] != null 
          ? List<String>.from(json['folders'] as List)
          : (json['folder'] != null ? [json['folder'] as String] : []),
      sentences: (json['sentences'] as List?)
          ?.map((e) => ExampleSentence.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}
