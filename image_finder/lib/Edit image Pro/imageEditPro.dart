// import 'dart:typed_data';
// import 'dart:io';
// // import 'package:editor_image/core/component/dialog/success_dialog.dart';
// // import 'package:editor_image/module/detail_photo/presentation/cubit/detail_photo_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_finder/core/component/dialog/success_dialog.dart';
// import 'package:image_finder/module/detail_photo/presentation/cubit/detail_photo_cubit.dart';
// import 'package:media_store_plus/media_store_plus.dart';
// // import 'package:image_gallery_saver/image_gallery_saver.dart';

// class ImageUtility {
//   Uint8List? imageData;
//   String fileName = '';
//   String? relativePath = "ImageFinder";
//   Future<void> loadImage(File file) async {
//     imageData = File(file.path).readAsBytesSync();
//     fileName = file.path.split('/').last;

//     print("The image file name is $fileName");

//     // You can add more logic here if needed
//   }

//   Future<void> editImage(BuildContext context) async {
//     if (imageData != null) {
//       String directoryPath = '/storage/emulated/0/Pictures/imageFinder/';

//       // Create the directory if it doesn't exist
//       Directory directory = Directory(directoryPath);
//       if (!directory.existsSync()) {
//         directory.createSync(recursive: true);
//       }

//       // Use a unique file name for the edited image
//       String editedFileName = 'edited_$fileName';
//       String imagePath = '$directoryPath$editedFileName';

//       // Check if the old image file exists and delete it
//       File oldImageFile = File('$directoryPath$fileName');
//       if (oldImageFile.existsSync()) {
//         oldImageFile.deleteSync();
//       }



//       if (editedImage != null) {
//         // Save the edited image to the specified path
//         File(imagePath).writeAsBytesSync(editedImage);
//         File oldImageFile = File('${imagePath}');
//         if (oldImageFile.existsSync()) {
//           // await ImageGallerySaver.saveFile(imagePath);

//           final String? status = await mediaStorePlugin.saveFile(
//             tempFilePath: imagePath,
//             dirType: DirType.photo,
//             dirName: DirType.photo.defaults,
//             relativePath: relativePath,
//           );

//           // oldImageFile.deleteSync();
//         }
//         // Trigger media scanner to scan the file immediately
//         // await _scanFile(imagePath);

//         showSuccessDialog(context, 'Edit Successful');
//       }
//     } else {
//       // Handle the case where no image is selected
//     }
//   }
// }
