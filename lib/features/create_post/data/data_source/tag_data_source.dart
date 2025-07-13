import 'package:ongo_desk/features/create_post/domain/entity/tag_entity.dart';

abstract interface class ITagDataSource {
  Future<List<TagEntity>> getAllTags();
  Future<void> updateTag(String id, TagEntity tag);
}
