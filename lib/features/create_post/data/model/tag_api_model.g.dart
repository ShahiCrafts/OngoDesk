// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagApiModel _$TagApiModelFromJson(Map<String, dynamic> json) => TagApiModel(
      name: json['name'] as String,
      description: json['description'] as String,
      issuesCount: (json['issuesCount'] as num).toInt(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      id: json['id'] as String?,
    );

Map<String, dynamic> _$TagApiModelToJson(TagApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'issuesCount': instance.issuesCount,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'id': instance.id,
    };
