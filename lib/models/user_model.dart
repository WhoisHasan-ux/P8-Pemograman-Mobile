//Model class untuk user data login
class UserModel {
  String id;
  String email;
  String fullName;
  String phone;
  String avatarUrl;
  String role;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.avatarUrl,
    required this.role,
  });

  //Mengubah data JSON user dari API menjadi object UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString() ?? json['name']?.toString() ?? 'User',
      phone: json['phone']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? json['avatar_url']?.toString() ?? '',
      role: json['role'] is Map ? (json['role']['name'] ?? 'user').toString() : (json['role']?.toString() ?? ''),
    );
  }

  // Mengubah object UserModel menjadi bentuk JSON (Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'role': role,
    };
  }
}
