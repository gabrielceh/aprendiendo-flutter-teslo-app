class User {
  final String id;
  final String email;
  final String fullName;
  final String token;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.token,
    required this.roles,
  });

  bool get isAdmin => roles.contains('admin');
}