import 'package:ongo_desk/features/create_post/domain/entity/category_entity.dart'; // Assuming this is the path

abstract interface class ICategoryDataSource {
  Future<List<CategoryEntity>> getAllCategories();
}
