class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final int totalPoints;
  final int totalQuizCompleted;
  final List<String> bookmarkedIds;
  final DateTime createdAt;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.totalPoints = 0,
    this.totalQuizCompleted = 0,
    this.bookmarkedIds = const [],
    required this.createdAt,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      totalPoints: json['totalPoints'] ?? 0,
      totalQuizCompleted: json['totalQuizCompleted'] ?? 0,
      bookmarkedIds: List<String>.from(json['bookmarkedIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'totalPoints': totalPoints,
      'totalQuizCompleted': totalQuizCompleted,
      'bookmarkedIds': bookmarkedIds,
      'createdAt': createdAt.toIso8601String(),
      'profileImage': profileImage,
    };
  }
}
