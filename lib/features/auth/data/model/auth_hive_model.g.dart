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
      email: fields[2] as String,
      password: fields[3] as String,
      googleId: fields[4] as String?,
      role: fields[5] as String,
      emailVerified: fields[6] as bool?,
      isBanned: fields[7] as bool?,
      isActive: fields[8] as bool?,
      notificationPreferences: fields[9] as NotificationPreferencesHiveModel?,
      ogdPoints: fields[10] as int?,
      bio: fields[11] as String?,
      location: fields[12] as String?,
      profileImage: fields[13] as String?,
      lastLogin: fields[14] as DateTime?,
      createdAt: fields[15] as DateTime?,
      updatedAt: fields[16] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.googleId)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.emailVerified)
      ..writeByte(7)
      ..write(obj.isBanned)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.notificationPreferences)
      ..writeByte(10)
      ..write(obj.ogdPoints)
      ..writeByte(11)
      ..write(obj.bio)
      ..writeByte(12)
      ..write(obj.location)
      ..writeByte(13)
      ..write(obj.profileImage)
      ..writeByte(14)
      ..write(obj.lastLogin)
      ..writeByte(15)
      ..write(obj.createdAt)
      ..writeByte(16)
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
