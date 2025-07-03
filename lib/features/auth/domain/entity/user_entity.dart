import 'package:equatable/equatable.dart';

class NotificationPreferencesEntity extends Equatable {
  final bool email;
  final bool inApp;

  const NotificationPreferencesEntity({this.email = true, this.inApp = true});

  @override
  List<Object?> get props => [email, inApp];
}

class UserEntity extends Equatable {
  final String? id;
  final String? username;
  final String fullName;
  final String email;
  final String password;
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
    required this.password,
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
