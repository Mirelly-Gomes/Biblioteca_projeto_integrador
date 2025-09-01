class AppUser {
  final String id;
  final String email;
  final String role;

  AppUser({required this.id, required this.email, required this.role});

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    email: json['email'] ?? '',
    role: json['role'] ?? 'user',
  );
}
