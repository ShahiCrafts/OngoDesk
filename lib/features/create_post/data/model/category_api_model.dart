import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart'; // Assuming this is the path

part 'category_api_model.g.dart';

@JsonSerializable(includeIfNull: false)
class CategoryApiModel extends Equatable {
  // Maps the '_id' field from MongoDB to 'id' in Dart.
  @JsonKey(name: '_id')
  final String? id;

  final String name;
  final String? description;
  final int? issuesCount;
  final bool? isActive;

  // Maps the 'timestamps' from Mongoose.
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryApiModel({
    this.id,
    required this.name,
    this.description,
    this.issuesCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Connects the generated `fromJson` constructor.
  factory CategoryApiModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryApiModelFromJson(json);

  /// Connects the generated `toJson` method.
  Map<String, dynamic> toJson() => _$CategoryApiModelToJson(this);

  /// Converts the API model object to a domain [CategoryEntity].
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      // Use default values from the schema if the API model fields are null.
      description: description ?? '',
      issuesCount: issuesCount ?? 0,
      isActive: isActive ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Creates an API model from a domain [CategoryEntity].
  /// This is used when you need to send data to the API.
  factory CategoryApiModel.fromEntity(CategoryEntity entity) {
    return CategoryApiModel(
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
        id,
        name,
        description,
        issuesCount,
        isActive,
        createdAt,
        updatedAt,
      ];
}
