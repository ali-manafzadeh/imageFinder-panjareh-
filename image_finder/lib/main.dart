import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:image_finder/core/route/app_route.dart';
import 'package:image_finder/core/route/app_route_name.dart';
import 'package:image_finder/main_module.dart';
import 'package:image_finder/sharePreference/appPreferences.dart';

Future<void> main() async {
  MainModule.init();
  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences.initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Photo Editor App",
      theme: ThemeData(
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 3),
      ),
      themeMode: AppPreferences.isModeDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 3),
      ),
      initialRoute: AppRouteName.getStarted,
      onGenerateRoute: AppRoute.generate,
    );
  }
}

extension AppTheme on ThemeData {
  Color get lightTextColor =>
      AppPreferences.isModeDark ? Colors.white70 : Colors.black54;
  Color get bottomNavigationColor =>
      AppPreferences.isModeDark ? Colors.white12 : Colors.redAccent;
}
