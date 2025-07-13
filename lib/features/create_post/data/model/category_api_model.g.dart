// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryApiModel _$CategoryApiModelFromJson(Map<String, dynamic> json) =>
    CategoryApiModel(
      id: json['_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      issuesCount: (json['issuesCount'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CategoryApiModelToJson(CategoryApiModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      if (instance.issuesCount case final value?) 'issuesCount': value,
      if (instance.isActive case final value?) 'isActive': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };
