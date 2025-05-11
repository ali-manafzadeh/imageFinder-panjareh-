import 'package:hive_flutter/adapters.dart';

class AppPreferences {
  static late Box boxOfData;

  static Future<void> initHive() async {
    await Hive.initFlutter();

    boxOfData = await Hive.openBox("data");
  }

// saving user choice about theme selection

  static bool get isModeDark => boxOfData.get("isModeDark") ?? false;
  static set isModeDark(bool value) => boxOfData.put("isModeDark", value);

  // saving user choice about theme selection

  static bool get backgroundImageColor =>
      boxOfData.get("backgroundImageColor") ?? false;
  static set backgroundImageColor(bool value) =>
      boxOfData.put("backgroundImageColor", value);

  //  grind number
  static int get GridNumber => boxOfData.get("GridNumber") ?? 1;
  static set GridNumber(int value) => boxOfData.put("GridNumber", value);
}
