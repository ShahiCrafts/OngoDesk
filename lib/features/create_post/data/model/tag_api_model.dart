import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';

part 'tag_api_model.g.dart';

@JsonSerializable()
class TagApiModel extends Equatable {
  final String name;
  final String description;
  final int issuesCount;

  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? id;

  const TagApiModel({
    required this.name,
    required this.description,
    required this.issuesCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.id,
  });

  factory TagApiModel.fromJson(Map<String, dynamic> json) =>
      _$TagApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagApiModelToJson(this);

  TagEntity toEntity() {
    return TagEntity(
      id: id,
      name: name,
      description: description,
      issuesCount: issuesCount,
      isActive: isActive ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TagApiModel.fromEntity(TagEntity entity) {
    return TagApiModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      issuesCount: entity.issuesCount,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        issuesCount,
        isActive,
        createdAt,
        updatedAt,
        id,
      ];
}
