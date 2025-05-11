import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_finder/core/extension/string_extension.dart';
import 'package:image_finder/core/theme/app_color.dart';
import 'package:image_finder/module/detail_photo/presentation/cubit/detail_photo_cubit.dart';
import 'package:image_finder/module/home/model/photo/photo_model.dart';
import 'package:shimmer/shimmer.dart';

class CustomDialog {
  static void show(
      BuildContext context, PhotoItemModel photo, Function Detail) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Adjust the border radius as needed
          ),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.all(0),
                  child: ClipRRect(
                      // clip the image to a circle
                      borderRadius: BorderRadius.circular(12),
                      child: ClipRRect(
                        // clip the image to a circle
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          errorListener: (e) {
                            if (e is SocketException) {
                              print(
                                  'Error with ${e.address} and message ${e.message}');
                            } else {
                              print('Image Exception is: ${e.runtimeType}');
                            }
                          },
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.white,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                          width: double.infinity,
                          imageUrl: photo.src.portrait,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.broken_image_rounded,
                                color: AppColor.primaryColor,
                              ),
                            );
                          },
                        ),
                      )),
                ),
                SizedBox(height: 16.0),
                Text(
                  '${photo.photographer}',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 16.0),
                // ElevatedButton(
                //   onPressed: () {
                //     onConfirm();
                //   },
                //   child: Text('Confirm'),
                // ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(int.parse(
                                        "0xFF${photo.avgColor.substring(1)}"))),
                                shape: BoxShape.circle,
                                color: photo.avgColor.toColor(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(photo.avgColor,
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(1),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // context.read<DetailPhotoCubit>().downloadPhoto(
                            //     context, photo.src.original, false);
                            Detail();
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(15)),
                            ),
                          ),
                          icon:
                              Icon(CupertinoIcons.forward, color: Colors.black),
                          label: Text("جزئیات ",
                              style: TextStyle(
                                fontFamily: "vazir",
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
