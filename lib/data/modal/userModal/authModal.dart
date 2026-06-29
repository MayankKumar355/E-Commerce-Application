class UserModel {
  /// Backend filled
  final String id;
  final String name;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String phoneNumber;
  final String profilePic;
  final bool isVerified;

  // Constructor
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.phoneNumber,
    required this.profilePic,
    required this.isVerified,
  });

  String get fullName => '$firstName $lastName'.trim();

  static UserModel empty() => UserModel(
    id: '',
    name: '',
    email: '',
    firstName: '',
    lastName: '',
    username: '',
    phoneNumber: '',
    profilePic: 'https://flaticon.com',
    isVerified: false,
  );

  // Json parsing
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilePic: json['profilePic'] ?? 'https://flaticon.com',
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phoneNumber': phoneNumber,
      'profilePic': profilePic,
      'isVerified': isVerified,
    };
  }
}
