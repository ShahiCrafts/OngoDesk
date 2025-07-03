import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ongo_desk/features/auth/domain/entity/user_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
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
  final NotificationPreferences? notificationPreferences;
  final int? ogdPoints;
  final String? bio;
  final String? location;
  final String? profileImage;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthApiModel({
    this.id,
    this.username,
    required this.fullName,
    required this.email,
    required this.password,
    this.googleId,
    this.role,
    this.emailVerified,
    this.isBanned,
    this.isActive,
    this.notificationPreferences,
    this.ogdPoints,
    this.bio,
    this.location,
    this.profileImage,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      fullName: fullName,
      email: email,
      password: password,
      googleId: googleId,
      role: role,
      emailVerified: emailVerified,
      isBanned: isBanned,
      isActive: isActive,
      ogdPoints: ogdPoints,
      bio: bio,
      location: location,
      profileImage: profileImage,
      lastLogin: lastLogin,
      createdAt: createdAt,
      updatedAt: updatedAt,
      notificationPreferences: notificationPreferences?.toEntity(),
    );
  }

  factory AuthApiModel.fromEntity(UserEntity entity) {
    return AuthApiModel(
      id: entity.id,
      username: entity.username,
      fullName: entity.fullName,
      email: entity.email,
      password: entity.password,
      googleId: entity.googleId,
      role: entity.role,
      emailVerified: entity.emailVerified,
      isBanned: entity.isBanned,
      isActive: entity.isActive,
      ogdPoints: entity.ogdPoints,
      bio: entity.bio,
      location: entity.location,
      profileImage: entity.profileImage,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      notificationPreferences: entity.notificationPreferences != null
          ? NotificationPreferences.fromEntity(entity.notificationPreferences!)
          : null,
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

@JsonSerializable()
class NotificationPreferences extends Equatable {
  final bool? email;
  final bool? inApp;

  const NotificationPreferences({
    this.email,
    this.inApp,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesToJson(this);

  NotificationPreferencesEntity toEntity() {
    return NotificationPreferencesEntity(
      email: email ?? true,
      inApp: inApp ?? true,
    );
  }

  factory NotificationPreferences.fromEntity(NotificationPreferencesEntity entity) {
    return NotificationPreferences(
      email: entity.email,
      inApp: entity.inApp,
    );
  }

  @override
  List<Object?> get props => [email, inApp];
}
