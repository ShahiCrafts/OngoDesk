// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesHiveModelAdapter
    extends TypeAdapter<NotificationPreferencesHiveModel> {
  @override
  final int typeId = 1;

  @override
  NotificationPreferencesHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferencesHiveModel(
      email: fields[0] as bool,
      inApp: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferencesHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.inApp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AuthHiveModelAdapter extends TypeAdapter<AuthHiveModel> {
  @override
  final int typeId = 0;

  @override
  AuthHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthHiveModel(
      userId: fields[0] as String?,
      username: fields[1] as String?,
      fullName: fields[2] as String,
      email: fields[3] as String,
      password: fields[4] as String,
      googleId: fields[5] as String?,
      role: fields[6] as String?,
      emailVerified: fields[7] as bool?,
      isBanned: fields[8] as bool?,
      isActive: fields[9] as bool?,
      notificationPreferences: fields[10] as NotificationPreferencesHiveModel?,
      ogdPoints: fields[11] as int?,
      bio: fields[12] as String?,
      location: fields[13] as String?,
      profileImage: fields[14] as String?,
      lastLogin: fields[15] as DateTime?,
      createdAt: fields[16] as DateTime?,
      updatedAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthHiveModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.password)
      ..writeByte(5)
      ..write(obj.googleId)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.emailVerified)
      ..writeByte(8)
      ..write(obj.isBanned)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.notificationPreferences)
      ..writeByte(11)
      ..write(obj.ogdPoints)
      ..writeByte(12)
      ..write(obj.bio)
      ..writeByte(13)
      ..write(obj.location)
      ..writeByte(14)
      ..write(obj.profileImage)
      ..writeByte(15)
      ..write(obj.lastLogin)
      ..writeByte(16)
      ..write(obj.createdAt)
      ..writeByte(17)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
