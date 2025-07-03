// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthApiModel _$AuthApiModelFromJson(Map<String, dynamic> json) => AuthApiModel(
      id: json['_id'] as String?,
      username: json['username'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      googleId: json['googleId'] as String?,
      role: json['role'] as String?,
      emailVerified: json['emailVerified'] as bool?,
      isBanned: json['isBanned'] as bool?,
      isActive: json['isActive'] as bool?,
      notificationPreferences: json['notificationPreferences'] == null
          ? null
          : NotificationPreferences.fromJson(
              json['notificationPreferences'] as Map<String, dynamic>),
      ogdPoints: (json['ogdPoints'] as num?)?.toInt(),
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      profileImage: json['profileImage'] as String?,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AuthApiModelToJson(AuthApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'email': instance.email,
      'password': instance.password,
      'googleId': instance.googleId,
      'role': instance.role,
      'emailVerified': instance.emailVerified,
      'isBanned': instance.isBanned,
      'isActive': instance.isActive,
      'notificationPreferences': instance.notificationPreferences,
      'ogdPoints': instance.ogdPoints,
      'bio': instance.bio,
      'location': instance.location,
      'profileImage': instance.profileImage,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

NotificationPreferences _$NotificationPreferencesFromJson(
        Map<String, dynamic> json) =>
    NotificationPreferences(
      email: json['email'] as bool?,
      inApp: json['inApp'] as bool?,
    );

Map<String, dynamic> _$NotificationPreferencesToJson(
        NotificationPreferences instance) =>
    <String, dynamic>{
      'email': instance.email,
      'inApp': instance.inApp,
    };
