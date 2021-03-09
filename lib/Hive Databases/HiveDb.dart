import 'dart:io';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:skensa/Hive%20Databases/Models/SoalModel.dart';

class HiveDb {
  static Future<void> hiveInit() async {
    Directory hiveDir = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(hiveDir.path);
    print("Hive Path: " + hiveDir.path);
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SoalModelAdapter());
    }
  }
}
