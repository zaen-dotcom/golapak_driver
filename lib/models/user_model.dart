class UserProfile {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }
}
