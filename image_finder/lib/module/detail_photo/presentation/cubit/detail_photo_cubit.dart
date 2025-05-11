import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:http/http.dart' as http;
import 'package:image_finder/Edit%20image%20Pro/imageEditPro.dart';
import 'package:image_finder/core/bloc/download_status.dart';

// import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:share_plus/share_plus.dart';

part 'detail_photo_state.dart';
part 'detail_photo_cubit.freezed.dart';

// final mediaStorePlugin = MediaStore();

class DetailPhotoCubit extends Cubit<DetailPhotoState> {
  final dio = Dio();

  /// set `null`to save in relativePath [MediaStore.appFolder]
  String? relativePath = "ImageFinder";
  // ImageUtility imageUtility = ImageUtility();
  Uint8List? imageData;
  // String fileName = '';
  Future<Uint8List> readImageAsUint8List(String imagePath) async {
    try {
      File file = File(imagePath);
      Uint8List uint8List = await file.readAsBytes();
      return uint8List;
    } catch (e) {
      print("Error reading image as Uint8List: $e");
      return Uint8List(0); // Return an empty Uint8List in case of error
    }
  }

  void main() async {
    String imagePath =
        '/path/to/your/image.jpg'; // Replace with your actual image path
    Uint8List imageData = await readImageAsUint8List(imagePath);

    // Now you can use the Uint8List (imageData) as needed.
    // For example, you might want to display it using an Image widget in Flutter.
  }

  DetailPhotoCubit() : super(const DetailPhotoState());

  void sharePhoto(String photoUrl) async {
    if (state.shareStatus == DownloadStatus.downloading) return;

    try {
      emit(state.copyWith(shareStatus: DownloadStatus.downloading));

      final response = await http.get(Uri.parse(photoUrl));
      final bytes = response.bodyBytes;

      final temp = await getTemporaryDirectory();
      final path = "${temp.path}/shared_image.jpeg";
      File(path).writeAsBytesSync(bytes);

      if (response.statusCode == 200) {
        emit(state.copyWith(shareStatus: DownloadStatus.success));
        // await Share.shareFiles([path]);
      }
    } catch (e) {
      emit(state.copyWith(shareStatus: DownloadStatus.failed));
    } finally {
      emit(state.copyWith(shareStatus: DownloadStatus.initial));
    }
  }

  void downloadPhoto(
      BuildContext context, String photoUrl, bool editProBool) async {
    if (state.downloadStatus == DownloadStatus.downloading) return;

    final date = DateTime.now().millisecondsSinceEpoch;
    final directory = await _getDirectory();

    if (directory == null) return;

    try {
      final path = directory.path;
      final file = File("$path/$date.jpeg");
      emit(state.copyWith(downloadStatus: DownloadStatus.downloading));
      print('images path is ${file.path}');
      final response = await dio.download(
        photoUrl,
        file.path,
        deleteOnError: true,
      );
      if (response.statusCode == 200) {
        emit(state.copyWith(
          downloadStatus: DownloadStatus.success,
        ));
        // photo edit pro
        // Trigger media scanner to scan the file immediately

        if (editProBool == true) {
          // Future.delayed(Duration(milliseconds: 100), () async {
          //   // Your code to be executed after the delay
          //   File filePath = File(file.path);
          //   // imageData = await readImageAsUint8List(filePath);
          //   await imageUtility.loadImage(filePath);
          //   await imageUtility.editImage(context);
          //   print("Task completed after 1 second");
          // });

          // loadImage(file);
        } else {
          File oldImageFile = File('${file.path}');
          if (oldImageFile.existsSync()) {
            // await ImageGallerySaver.saveFile(file.path);

            // final Uri? uri = await mediaStorePlugin.getFileUri(
            //   fileName: "$date.jpeg",
            //   dirType: DirType.photo,
            //   dirName: DirType.photo.defaults,
            //   relativePath: relativePath,
            // );

            // final String? status = (await mediaStorePlugin.saveFile(
            //   tempFilePath: oldImageFile.path,
            //   dirType: DirType.photo,
            //   dirName: DirType.photo.defaults,
            //   relativePath: relativePath,
            // )) as String?;
          }
        }
      }
    } catch (e) {
      emit(state.copyWith(downloadStatus: DownloadStatus.failed));
    } finally {
      emit(state.copyWith(downloadStatus: DownloadStatus.initial));
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    int platformSDKVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      // platformSDKVersion = await mediaStorePlugin.getPlatformSDKInt() ?? 0;
    } on PlatformException {
      platformSDKVersion = -1;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
  }

  Future<Directory?> _getDirectory() async {
    initPlatformState();
    await WidgetsFlutterBinding.ensureInitialized();
    List<Permission> permissions = [
      Permission.storage,
    ];
    // if ((await mediaStorePlugin.getPlatformSDKInt()) >= 33) {
    //   permissions.add(Permission.photos);
    // }

    await permissions.request();
    // we are not checking the status as it is an example app. You should (must) check it in a production app

    // You have set this otherwise it throws AppFolderNotSetException
    // MediaStore.appFolder = "ImageFinder";

    Directory directory = await getApplicationSupportDirectory();

    if (Platform.isAndroid) {
      if (!await directory.exists()) {
        directory.create(recursive: true);
      }

      return directory;
    }
  }
}
