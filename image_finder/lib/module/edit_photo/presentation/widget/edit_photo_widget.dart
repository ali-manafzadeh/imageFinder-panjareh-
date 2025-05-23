import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_finder/core/theme/app_color.dart';
import 'package:image_finder/module/edit_photo/presentation/cubit/edit_photo_cubit.dart';
import 'package:image_finder/module/home/model/photo/photo_model.dart';
import 'package:shimmer/shimmer.dart';

class EditPhotoWidget extends StatelessWidget {
  const EditPhotoWidget({
    super.key,
    required this.photo,
  });

  final PhotoItemModel photo;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        OriginalImage(photo: photo),

        ///
        ComponentLayer(),
      ],
    );
  }
}

class OriginalImage extends StatelessWidget {
  const OriginalImage({
    super.key,
    required this.photo,
  });

  final PhotoItemModel photo;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      errorListener: (e) {
        if (e is SocketException) {
          print('Error with ${e.address} and message ${e.message}');
        } else {
          print('Image Exception is: ${e.runtimeType}');
        }
      },
      imageUrl: photo.src.original,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        // if (downloadProgress == null) {
        //   return widget;
        // }

        return CachedNetworkImage(
          errorListener: (e) {
            if (e is SocketException) {
              print('Error with ${e.address} and message ${e.message}');
            } else {
              print('Image Exception is: ${e.runtimeType}');
            }
          },
          imageUrl: photo.src.portrait,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
            ),
          ),
          // loadingBuilder: (context, child, loadingProgress) {
          //   if (loadingProgress == null) {
          //     return child;
          //   }
          //   return Center(
          //     child: CircularProgressIndicator(
          //       value: loadingProgress.expectedTotalBytes != null
          //           ? loadingProgress.cumulativeBytesLoaded /
          //               loadingProgress.expectedTotalBytes!
          //           : null,
          //     ),
          //   );
          // },
          errorWidget: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image_rounded,
                color: AppColor.primaryColor,
              ),
            );
          },
        );
      },
      errorWidget: (context, error, stackTrace) {
        return Center(
          child: Icon(
            Icons.broken_image_rounded,
            color: AppColor.primaryColor,
          ),
        );
      },
    );
  }
}

class ComponentLayer extends StatelessWidget {
  const ComponentLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditPhotoCubit, EditPhotoState>(
      buildWhen: (p, c) {
        return p.opacityLayer != c.opacityLayer || p.widgets != c.widgets;
      },
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            /// opacity layer
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(state.opacityLayer),
              ),
            ),

            ///
            for (var i = 0; i < state.widgets.length; i++)
              Align(
                key: UniqueKey(),
                alignment: Alignment.center,
                child: state.widgets[i],
              ),
          ],
        );
      },
    );
  }
}
