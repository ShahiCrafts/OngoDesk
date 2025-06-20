import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ongo_desk/app/constant/hive/hive_table_constant.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.notificationPreferenceId)
class NotificationPreferencesHiveModel extends Equatable {
  @HiveField(0)
  final bool email;

  @HiveField(1)
  final bool inApp;

  const NotificationPreferencesHiveModel({
    required this.email,
    required this.inApp,
  });

  // Convert from Entity to Hive Model
  factory NotificationPreferencesHiveModel.fromEntity(
    NotificationPreferencesEntity entity,
  ) {
    return NotificationPreferencesHiveModel(
      email: entity.email,
      inApp: entity.inApp,
    );
  }

  // Convert from Hive Model to Entity
  NotificationPreferencesEntity toEntity() {
    return NotificationPreferencesEntity(email: email, inApp: inApp);
  }

  @override
  List<Object?> get props => [email, inApp];
}

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String? username;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String? googleId;

  @HiveField(5)
  final String role;

  @HiveField(6)
  final bool? emailVerified;

  @HiveField(7)
  final bool? isBanned;

  @HiveField(8)
  final bool? isActive;

  @HiveField(9)
  final NotificationPreferencesHiveModel? notificationPreferences;

  @HiveField(10)
  final int? ogdPoints;

  @HiveField(11)
  final String? bio;

  @HiveField(12)
  final String? location;

  @HiveField(13)
  final String? profileImage;

  @HiveField(14)
  final DateTime? lastLogin;

  @HiveField(15)
  final DateTime? createdAt;

  @HiveField(16)
  final DateTime? updatedAt;

  // Constructor
  AuthHiveModel({
    String? userId,
    required this.username,
    required this.email,
    required this.password,
    this.googleId,
    required this.role,
    required this.emailVerified,
    required this.isBanned,
    required this.isActive,
    this.notificationPreferences,
    required this.ogdPoints,
    this.bio,
    this.location,
    this.profileImage,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  }) : userId = const Uuid().v4();

  factory AuthHiveModel.fromEntity(UserEntity entity) {
    return AuthHiveModel(
      userId: entity.id,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      googleId: entity.googleId,
      role: entity.role,
      emailVerified: entity.emailVerified,
      isBanned: entity.isBanned,
      isActive: entity.isActive,
      notificationPreferences:
          entity.notificationPreferences != null
              ? NotificationPreferencesHiveModel.fromEntity(
                entity.notificationPreferences!,
              )
              : null,
      ogdPoints: entity.ogdPoints,
      bio: entity.bio,
      location: entity.location,
      profileImage: entity.profileImage,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      username: username,
      email: email,
      password: password,
      googleId: googleId,
      role: role,
      emailVerified: emailVerified,
      isBanned: isBanned,
      isActive: isActive,
      notificationPreferences:
          notificationPreferences?.toEntity() ??
          const NotificationPreferencesEntity(),
      ogdPoints: ogdPoints,
      bio: bio,
      location: location,
      profileImage: profileImage,
      lastLogin: lastLogin,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    username,
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
