import 'package:equatable/equatable.dart';

class NotificationPreferencesEntity extends Equatable {
  final bool email;
  final bool inApp;

  const NotificationPreferencesEntity({this.email = true, this.inApp = true});

  @override
  List<Object?> get props => [email, inApp];

  Map<String, dynamic> toJson() {
    return {'email': email, 'inApp': inApp};
  }

  factory NotificationPreferencesEntity.fromJson(Map<String, dynamic> map) {
    return NotificationPreferencesEntity(
      email: map['email'] ?? true,
      inApp: map['inApp'] ?? true,
    );
  }
}

class UserEntity extends Equatable {
  final String? id;
  final String? username;
  final String fullName;
  final String email;
  // FIX: Made the password optional
  final String? password;
  final String? googleId;
  final String? role;
  final bool? emailVerified;
  final bool? isBanned;
  final bool? isActive;
  final NotificationPreferencesEntity? notificationPreferences;
  final int? ogdPoints;
  final String? bio;
  final String? location;
  final String? profileImage;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    this.id,
    this.username,
    required this.fullName,
    required this.email,
    // FIX: Password is no longer required in the constructor
    this.password,
    this.googleId,
    this.role,
    this.emailVerified = false,
    this.isBanned = false,
    this.isActive = true,
    this.notificationPreferences = const NotificationPreferencesEntity(),
    this.ogdPoints = 0,
    this.bio,
    this.location,
    this.profileImage,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      // Only include password in JSON if it's not null
      if (password != null) 'password': password,
      'googleId': googleId,
      'role': role,
      'emailVerified': emailVerified,
      'isBanned': isBanned,
      'isActive': isActive,
      'notificationPreferences': notificationPreferences?.toJson(),
      'ogdPoints': ogdPoints,
      'bio': bio,
      'location': location,
      'profileImage': profileImage,
      'lastLogin': lastLogin?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Creates an object from a JSON map
  factory UserEntity.fromJson(Map<String, dynamic> map) {
    return UserEntity(
      // The 'id' from the server is often '_id'
      id: map['id'] ?? map['_id'],
      username: map['username'],
      fullName: map['fullName'],
      email: map['email'],
      // FIX: The password field is not expected from the server, so it's omitted.
      // password: map['password'], // This line is removed.
      googleId: map['googleId'],
      role: map['role'],
      emailVerified: map['emailVerified'],
      isBanned: map['isBanned'],
      isActive: map['isActive'],
      notificationPreferences: map['notificationPreferences'] != null
          ? NotificationPreferencesEntity.fromJson(
              map['notificationPreferences'],
            )
          : null,
      ogdPoints: map['ogdPoints'],
      bio: map['bio'],
      location: map['location'],
      profileImage: map['profileImage'],
      lastLogin:
          map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        fullName,
        email,
        password,
        googleId,
        role,
        emailVerified,
        isBanned,
        isActive,
        notificationPreferences,
        ogdPoints,
        bio,
        location,
        profileImage,
        lastLogin,
        createdAt,
        updatedAt,
      ];
}