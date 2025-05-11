import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_finder/core/network/client.dart';
import 'package:image_finder/module/home/repository/home_repository.dart';
import 'package:image_finder/module/home/repository/home_repository_impl.dart';
import 'package:image_finder/module/seach_photo/repository/search_repository_impl.dart';
import 'module/seach_photo/repository/search_repository.dart';

class MainModule {
  /// Main Module for initialize GetIt (DI)
  static void init() {
    /// main client for PexelAPI
    GetIt.I.registerLazySingleton(
      () => Dio().initClient("https://api.pexels.com/v1/"),
    );

    GetIt.I.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(client: GetIt.I.get()),
    );

    GetIt.I.registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(client: GetIt.I.get()),
    );
  }
}
