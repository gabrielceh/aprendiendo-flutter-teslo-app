

class UserResponse {
    final String id;
    final String email;
    final String fullName;
    final bool isActive;
    final List<String> roles;
    final String token;

    UserResponse({
        required this.id,
        required this.email,
        required this.fullName,
        required this.isActive,
        required this.roles,
        required this.token,
    });

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        id: json["id"],
        email: json["email"],
        fullName: json["fullName"],
        isActive: json["isActive"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        token: json["token"],
    );

}