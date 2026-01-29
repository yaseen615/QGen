import 'package:hive/hive.dart';

part 'subject.g.dart';

/// Chapter model for organizing questions
@HiveType(typeId: 2)
class Chapter extends HiveObject {
  @HiveField(0)
  final int number;

  @HiveField(1)
  String name;

  Chapter({required this.number, required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chapter && other.number == number && other.name == name;
  }

  @override
  int get hashCode => number.hashCode ^ name.hashCode;

  Map<String, dynamic> toJson() {
    return {'number': number, 'name': name};
  }

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(number: json['number'], name: json['name']);
  }
}

/// Subject model for organizing questions
@HiveType(typeId: 1)
class Subject extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  List<Chapter> chapters;

  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime createdAt;

  Subject({
    required this.id,
    required this.name,
    required this.chapters,
    this.description,
    required this.createdAt,
  });

  Subject copyWith({
    String? name,
    List<Chapter>? chapters,
    String? description,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      chapters: chapters ?? this.chapters,
      description: description ?? this.description,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'chapters': chapters.map((c) => c.toJson()).toList(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      chapters: (json['chapters'] as List)
          .map((c) => Chapter.fromJson(c))
          .toList(),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
