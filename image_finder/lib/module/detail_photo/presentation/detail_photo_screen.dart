import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_finder/core/extension/string_extension.dart';
import 'package:image_finder/sharePreference/appPreferences.dart';
import 'package:image_finder/themes/backgroundColor_textColor.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/bloc/download_status.dart';
import '../../../core/component/dialog/loading_dialog.dart';
import '../../../core/component/dialog/success_dialog.dart';
import '../../../core/component/snackbar/info_snackbar.dart';
import '../../../core/route/app_route_name.dart';
import '../../../core/theme/app_color.dart';
import '../../home/model/photo/photo_model.dart';
import 'cubit/detail_photo_cubit.dart';

class DetailPhotoScreen extends StatelessWidget {
  const DetailPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailPhotoCubit(),
      child: const DetailPhotoLayout(),
    );
  }
}

class DetailPhotoLayout extends StatefulWidget {
  const DetailPhotoLayout({super.key});

  @override
  State<DetailPhotoLayout> createState() => _DetailPhotoLayoutState();
}

class _DetailPhotoLayoutState extends State<DetailPhotoLayout> {
  late PhotoItemModel photo;
  late Color backgroundColor;
  late Color textColor;
  //  swich for change background
  late bool isSwitched;
  @override
  void didChangeDependencies() {
    photo = ModalRoute.of(context)?.settings.arguments as PhotoItemModel;
    backgroundColor = AppPreferences.backgroundImageColor
        ? Color(int.parse("0xFF${photo.avgColor.substring(1)}"))
        : !AppPreferences.isModeDark
            ? Colors.white
            : const Color.fromARGB(221, 16, 16, 16);
    isSwitched = AppPreferences.backgroundImageColor;
    textColor = ColorUtils.getTextColor(backgroundColor);

    super.didChangeDependencies();
  }

  int orbit = 1;

  List<Widget> ListDetailPhotoScreen(
      Orientation orientation, BoxConstraints constraints, Color textColor) {
    return [
      // Add your common widgets here
      // For example:
      Expanded(
        flex: orientation == Orientation.portrait && constraints.maxWidth <= 600
            ? 65
            : (orientation == Orientation.landscape &&
                    constraints.maxWidth > 600)
                ? 5
                : 5, // 70% of the available space
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (orientation == Orientation.landscape &&
                  constraints.maxWidth > 600)
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.5,
          child: CachedNetworkImage(
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
              if (downloadProgress == null) {
                return widget;
              }

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
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Shimmer.fromColors(
                  baseColor: backgroundColor,
                  highlightColor: Colors.white,
                  child: Container(
                    color: backgroundColor,
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
              );
            },
            errorWidget: (context, url, error) {
              return Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  color: AppColor.primaryColor,
                ),
              );
            },
          ),
        ),
      ),
      const SizedBox(height: 16),
      Expanded(
        flex: orientation == Orientation.portrait && constraints.maxWidth <= 600
            ? 35
            : (orientation == Orientation.landscape &&
                    constraints.maxWidth > 600)
                ? 5
                : 5,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo.photographer,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: textColor, // Set your desired color here
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (photo.alt != null && photo.alt?.isNotEmpty == true) ...[
                      Text(
                        photo.alt ?? "",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: textColor, // Set your desired color here
                            ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            border: Border.all(color: textColor),
                            shape: BoxShape.circle,
                            color: photo.avgColor.toColor(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          photo.avgColor,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                color: textColor, // Set your desired color here
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color:
                                textColor), // Set your desired border color here
                      ),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouteName.editPhoto,
                            arguments: photo,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: Icon(Icons.edit, color: textColor),
                        label: Text("ادیت عکس",
                            style: TextStyle(
                                color: textColor,
                                fontFamily: "vazir",
                                fontWeight: FontWeight.w600)
                            // Theme.of(context).textTheme.titleSmall!.copyWith(
                            //       color:
                            //           textColor, // Set your desired text color here
                            //     ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color:
                                  textColor), // Set your desired border color here
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            context.read<DetailPhotoCubit>().downloadPhoto(
                                context, photo.src.original, false);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Icon(CupertinoIcons.cloud_download,
                              color: textColor),
                          label: Text(
                            "دانلود",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color:
                                    textColor, // Set your desired text color here  )
                                fontFamily: "vazir"),
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DetailPhotoCubit, DetailPhotoState>(
      listener: (context, state) {
        if (state.shareStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.shareStatus == DownloadStatus.success) {
          Navigator.pop(context);
        }

        if (state.downloadStatus == DownloadStatus.downloading) {
          showLoadingDialog(context);
        }
        if (state.downloadStatus == DownloadStatus.success) {
          Navigator.pop(context);
          showSuccessDialog(context, "دانلود موفقیت امیز بود");
        }

        if (state.shareStatus == DownloadStatus.failed ||
            state.downloadStatus == DownloadStatus.failed) {
          Navigator.pop(context);
          showInfoSnackBar(
            context,
            "Something wrong when downloading photo, please try again!",
          );
        }
      },
      child: Scaffold(
          // background color
          backgroundColor: backgroundColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              splashRadius: 20,
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: textColor,
              ),
            ),
            centerTitle: false,
            title: Text("جزئیات عکس",
                style: TextStyle(
                  fontFamily: "vazir",
                  color: textColor, // Set your desired color here
                  fontSize: 18,
                  // fontWeight: FontWeight.w400
                )),
            actions: [
              Transform.scale(
                scale:
                    0.75, // Adjust the scale factor based on the desired size
                child: Switch(
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      print("app preference ${AppPreferences.isModeDark}");
                      AppPreferences.backgroundImageColor =
                          !AppPreferences.backgroundImageColor;

                      isSwitched = !isSwitched;
                      // switch and change the color
                      if (value) {
                        backgroundColor = Color(
                            int.parse("0xFF${photo.avgColor.substring(1)}"));
                        textColor = ColorUtils.getTextColor(backgroundColor);
                      } else {
                        backgroundColor = !AppPreferences.isModeDark
                            ? Colors.white
                            : Colors.black54;
                        textColor = ColorUtils.getTextColor(backgroundColor);
                      }
                    });
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  context.read<DetailPhotoCubit>().sharePhoto(photo.src.large);
                },
                splashRadius: 20,
                icon: Icon(
                  Icons.share_outlined,
                  color: textColor,
                ),
              ),
            ],
          ),
          body: OrientationBuilder(builder: (context, orientation) {
            return LayoutBuilder(builder: (context, constraints) {
              if (orientation == Orientation.landscape &&
                  constraints.maxWidth > 600) {
                return Row(
                    children: ListDetailPhotoScreen(
                        orientation, constraints, textColor));
              } else if (orientation == Orientation.landscape &&
                  constraints.maxWidth <= 600) {
                return Column(
                  children: ListDetailPhotoScreen(
                      orientation, constraints, textColor),
                );
              } else {
                return Column(
                    children: ListDetailPhotoScreen(
                        orientation, constraints, textColor));
              }
            });
          })),
    );
  }
}
