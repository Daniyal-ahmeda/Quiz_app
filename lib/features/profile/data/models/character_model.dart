class Character {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final DateTime createdAt;
  final DateTime lastModified;
  final Map<String, int> stats;
  final List<String> skills;

  Character({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.createdAt,
    required this.lastModified,
    required this.stats,
    required this.skills,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      createdAt: DateTime.parse(json['createdAt']),
      lastModified: DateTime.parse(json['lastModified']),
      stats: Map<String, int>.from(json['stats']),
      skills: List<String>.from(json['skills']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
      'lastModified': lastModified.toIso8601String(),
      'stats': stats,
      'skills': skills,
    };
  }
}
