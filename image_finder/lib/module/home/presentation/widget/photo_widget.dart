// import 'package:editor_image/core/bloc/bloc_status.dart';
// import 'package:editor_image/core/route/app_route_name.dart';
// import 'package:editor_image/core/theme/app_color.dart';
// import 'package:editor_image/module/home/presentation/cubit/home_cubit.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:photo_editor/core/bloc/bloc_status.dart';
// import 'package:photo_editor/core/route/app_route_name.dart';
// import 'package:photo_editor/core/theme/app_color.dart';
// import 'package:photo_editor/module/home/presentation/cubit/home_cubit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_finder/core/bloc/bloc_status.dart';
import 'package:image_finder/core/component/dialog/showImage_dialog.dart';
import 'package:image_finder/core/route/app_route_name.dart';
import 'package:image_finder/core/theme/app_color.dart';
import 'package:image_finder/module/detail_photo/presentation/cubit/detail_photo_cubit.dart';
import 'package:image_finder/module/home/presentation/cubit/home_cubit.dart';
import 'package:shimmer/shimmer.dart';

class PhotosWidget extends StatelessWidget {
  final int currentCategory;
  const PhotosWidget({super.key, required this.currentCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailPhotoCubit(),
      child: PhotosLayer(
        currentCategory: currentCategory,
      ),
    );
  }
}

class PhotosLayer extends StatelessWidget {
  const PhotosLayer({Key? key, required this.currentCategory})
      : super(key: key);
  final int currentCategory;

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.photosStatus != BlocStatus.success && state.photos.isEmpty) {
          return PhotosLoading(currentCategory: currentCategory);
        }

        return SliverGrid(
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: currentCategory == 0
                ? 1
                : currentCategory == 1
                    ? 2
                    : currentCategory == 2
                        ? 3
                        : 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              if (currentCategory == 1) QuiltedGridTile(2, 1),
              QuiltedGridTile(1, 1),
              if (currentCategory == 0) QuiltedGridTile(1, 1),
              if (currentCategory == 2) QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              if (currentCategory == 3) QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return GestureDetector(
                onLongPress: () {
                  CustomDialog.show(context, state.photos[index],
                      // Replace with the actual image URL
                      () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pushNamed(
                      context,
                      AppRouteName.detailPhoto,
                      arguments: state.photos[index],
                    );
                    // Add your button tap logic here
                    print('Confirm button tapped!');
                  });
                },
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRouteName.detailPhoto,
                    arguments: state.photos[index],
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                        margin: EdgeInsets.all(0.5),
                        child: CachedNetworkImage(
                          errorListener: (e) {
                            if (e is SocketException) {
                              print(
                                  'Error with ${e.address} and message ${e.message}');
                            } else {
                              print('Image Exception is: ${e.runtimeType}');
                            }
                          },
                          imageUrl: state.photos[index].src.portrait,
                          fit: BoxFit.cover,

                          //     (context, child, loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return Center(
                          //     child: CircularProgressIndicator(
                          //       color: Colors.grey,
                          //       value: loadingProgress.expectedTotalBytes !=
                          //               null
                          //           ? loadingProgress
                          //                   .cumulativeBytesLoaded /
                          //               (loadingProgress
                          //                       .expectedTotalBytes ??
                          //                   1)
                          //           : null,
                          //     ),
                          //   );
                          // },

                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),

                          errorWidget: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: AppColor.primaryColor,
                              ),
                            );
                          },
                        )),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: Text(
                        currentCategory == 2 || currentCategory == 3
                            ? ''
                            : state.photos[index].photographer,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              );
            },
            childCount: state.photos.length,
          ),
        );
      },
    );
  }
}

class PhotosLoading extends StatelessWidget {
  final int currentCategory;
  const PhotosLoading({super.key, required this.currentCategory});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverQuiltedGridDelegate(
        crossAxisCount: currentCategory == 0
            ? 1
            : currentCategory == 1
                ? 2
                : currentCategory == 2
                    ? 3
                    : 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        repeatPattern: QuiltedGridRepeatPattern.inverted,
        pattern: [
          if (currentCategory == 1) QuiltedGridTile(2, 1),
          QuiltedGridTile(1, 1),
          if (currentCategory == 0) QuiltedGridTile(1, 1),
          if (currentCategory == 2) QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          if (currentCategory == 3) QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
          QuiltedGridTile(1, 1),
        ],
      ),

      //  SliverQuiltedGridDelegate(
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 8,
      //   crossAxisSpacing: 8,
      //   repeatPattern: QuiltedGridRepeatPattern.inverted,
      //   pattern: const [
      //     QuiltedGridTile(2, 1),
      //     QuiltedGridTile(1, 1),
      //   ],
      // ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              color: Colors.white,
            ),
          );
        },
        childCount: currentCategory == 1
            ? 5
            : currentCategory == 0
                ? 2
                : currentCategory == 2
                    ? 15
                    : 5,
      ),
    );
  }
}
