import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ongo_desk/app/constant/hive/hive_table_constant.dart';
import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';
import 'package:uuid/uuid.dart';

part 'tag_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.tagTableId)
class TagHiveModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int issuesCount;

  @HiveField(4)
  final bool? isActive;

  TagHiveModel({
    String? id,
    required this.name,
    required this.description,
    required this.issuesCount,
    this.isActive,
  }) : id = id ?? const Uuid().v4();

  factory TagHiveModel.fromEntity(TagEntity entity) {
    return TagHiveModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      issuesCount: entity.issuesCount,
      isActive: entity.isActive,
    );
  }

  TagEntity toEntity() {
    return TagEntity(
      id: id,
      name: name,
      description: description,
      issuesCount: issuesCount,
      isActive: isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        issuesCount,
        isActive,
      ];
}
