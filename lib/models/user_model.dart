class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isOnline;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isOnline = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      isOnline: map['isOnline'] ?? false,
    );
  }
}
