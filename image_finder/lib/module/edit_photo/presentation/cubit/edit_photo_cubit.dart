import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_finder/core/bloc/download_status.dart';
import 'package:image_finder/module/detail_photo/presentation/cubit/detail_photo_cubit.dart';
import 'package:image_finder/module/edit_photo/model/dragable_widget_child.dart';
import 'package:image_finder/module/edit_photo/presentation/widget/dragable_widget.dart';
// import 'package:media_store_plus/media_store_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'edit_photo_state.dart';
part 'edit_photo_cubit.freezed.dart';

// final mediaStorePlugin = MediaStore();

class EditPhotoCubit extends Cubit<EditPhotoState> {
  EditPhotoCubit() : super(const EditPhotoState());
  String? relativePath = "ImageFinder";
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

  void changeEditState(EditState editState) {
    emit(state.copyWith(editState: editState));
  }

  void changeOpacityLayer(double value) {
    emit(state.copyWith(opacityLayer: value));
  }

  void addWidget(DragableWidget widget) {
    emit(state.copyWith(
      editState: EditState.idle,
      widgets: List.from(state.widgets)..add(widget),
    ));
  }

  void editWidget(int widgetId, DragableWidgetChild widget) {
    var index = state.widgets.indexWhere((e) => e.widgetId == widgetId);
    if (index == -1) return;

    state.widgets[index].child = widget;

    emit(state.copyWith(
      editState: EditState.idle,
      widgets: List.from(state.widgets),
    ));
  }

  void changeDownloadStatus(DownloadStatus status) {
    emit(state.copyWith(downloadStatus: status));
  }

  void changeShareStatus(DownloadStatus status) {
    emit(state.copyWith(shareStatus: status));
  }

  void deleteWidget(int widgetId) {
    emit(state.copyWith(
      widgets: List.of(state.widgets)
        ..removeWhere((e) => e.widgetId == widgetId),
    ));
  }

  void downloadImage(Uint8List? image) async {
    emit(state.copyWith(downloadStatus: DownloadStatus.downloading));

    final date = DateTime.now().millisecondsSinceEpoch;
    final directory = await _getDirectory();

    if (directory == null) return;

    try {
      if (image == null) {
        emit(state.copyWith(downloadStatus: DownloadStatus.failed));
        return;
      }
      final path = directory.path;
      final file = await File("$path/$date.jpeg").create();
      await file.writeAsBytes(image);
      print('images path is ${file.path}');
      emit(state.copyWith(downloadStatus: DownloadStatus.success));
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
    } catch (e) {
      print(' the error is $e');
      emit(state.copyWith(downloadStatus: DownloadStatus.failed));
    } finally {
      emit(state.copyWith(downloadStatus: DownloadStatus.initial));
    }
  }

  void shareImage(Uint8List? image) async {
    emit(state.copyWith(shareStatus: DownloadStatus.downloading));

    final date = DateTime.now().millisecondsSinceEpoch;
    final directory = await getTemporaryDirectory();

    try {
      if (image == null) {
        emit(state.copyWith(shareStatus: DownloadStatus.failed));
        return;
      }

      final path = directory.path;
      final file = await File("$path/$date.jpeg").create();
      await file.writeAsBytes(image);
      emit(state.copyWith(shareStatus: DownloadStatus.success));
      // await Share.shareFiles([file.path]);
    } catch (e) {
      emit(state.copyWith(shareStatus: DownloadStatus.failed));
    } finally {
      emit(state.copyWith(shareStatus: DownloadStatus.initial));
    }
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
