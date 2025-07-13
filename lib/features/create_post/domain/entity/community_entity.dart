import 'package:equatable/equatable.dart';

class CommunityEntity extends Equatable {
  final String? id;

  final String name;

  final String description;

  final int issuesCount;

  final bool? isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CommunityEntity({
    this.id,
    required this.name,
    required this.description,
    required this.issuesCount,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

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
