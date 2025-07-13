import 'package:hive_flutter/adapters.dart';
import 'package:ongo_desk/app/constant/hive/hive_table_constant.dart';
import 'package:ongo_desk/features/auth/data/model/auth_hive_model.dart';
import 'package:ongo_desk/features/create_post/data/model/tag_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    var dir = await getApplicationDocumentsDirectory();
    var path = '${dir.path}ongodesk_civic.db';
 
    Hive.init(path);
 
    Hive.registerAdapter(AuthHiveModelAdapter());
    Hive.registerAdapter(NotificationPreferencesHiveModelAdapter());
    Hive.registerAdapter(TagHiveModelAdapter());
  }
 
  Future<void> createAccount(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(
      HiveTableConstant.userBox,
    );
    await box.put(auth.email, auth);
  }

  Future<AuthHiveModel?> getUserByEmail(String email) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    final user = box.get(email);
    await box.close();
    return user;
  }

  Future<void> updateTag(TagHiveModel tag) async {
    var box = await Hive.openBox<TagHiveModel>(HiveTableConstant.tagBox);
    if (box.containsKey(tag.id)) {
      await box.put(tag.id, tag);
    } else {
      throw Exception('Tag not found');
    }
    await box.close();
  }

  Future<List<TagHiveModel>> fetchAllTags() async {
    var box = await Hive.openBox<TagHiveModel>(HiveTableConstant.tagBox);
    final tags = box.values.toList();
    await box.close();
    return tags;
  }
}