// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TagHiveModelAdapter extends TypeAdapter<TagHiveModel> {
  @override
  final int typeId = 2;

  @override
  TagHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TagHiveModel(
      id: fields[0] as String?,
      name: fields[1] as String,
      description: fields[2] as String,
      issuesCount: fields[3] as int,
      isActive: fields[4] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, TagHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.issuesCount)
      ..writeByte(4)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
