import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_finder/Edit%20image%20Pro/imageEditPro.dart';
import 'package:image_finder/core/bloc/bloc_status.dart';
import 'package:image_finder/core/component/snackbar/info_snackbar.dart';
import 'package:image_finder/core/route/app_route_name.dart';
import 'package:image_finder/core/theme/app_color.dart';
import 'package:image_finder/module/home/presentation/cubit/home_cubit.dart';
import 'package:image_finder/module/home/presentation/widget/collection_widget.dart';
import 'package:image_finder/module/home/presentation/widget/photo_widget.dart';
import 'package:image_finder/sharePreference/appPreferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        repo: GetIt.I.get(),
      )
        ..getCollection()
        ..getPhotos(),
      child: const HomeLayout(),
    );
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final refreshController = RefreshController();
  late int currentIconIndex;
  final List<IconData> icons = [
    Bootstrap.image,
    Bootstrap.grid_1x2,
    Bootstrap.grid_3x3_gap_fill,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentIconIndex = AppPreferences.GridNumber;
  }

  void _changeIcon() {
    setState(() {
      currentIconIndex = (currentIconIndex + 1) % icons.length;
      AppPreferences.GridNumber = currentIconIndex;
    });
  }

  // ImageUtility imageUtility = ImageUtility();
  Uint8List? imageData;
  String fileName = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        /// listener for pull request
        if (state.collectionStatus == BlocStatus.success &&
            state.photosStatus == BlocStatus.success) {
          if (refreshController.isRefresh) {
            refreshController.refreshCompleted();
          }
          if (refreshController.isLoading) {
            refreshController.loadComplete();
          }
        }

        if (state.collectionStatus == BlocStatus.error ||
            state.photosStatus == BlocStatus.error) {
          if (refreshController.isRefresh) {
            refreshController.refreshCompleted();
          }
          if (refreshController.isLoading) {
            refreshController.loadComplete();
          }

          showInfoSnackBar(context, "Something went wrong, please try again!");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SmartRefresher(
            controller: refreshController,
            header: CustomHeader(
              builder: (context, mode) {
                if (mode == RefreshStatus.idle) {
                  return const SizedBox();
                }
                return Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
            footer: CustomFooter(
              builder: (context, mode) {
                if (mode == LoadStatus.idle) {
                  return const SizedBox();
                }
                return Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                      strokeWidth: 2,
                    ),
                  ),
                );
              },
            ),
            enablePullUp: true,
            onRefresh: () {
              context.read<HomeCubit>().getCollection(showLoading: false);
              context.read<HomeCubit>().getPhotos(showLoading: false);
            },
            enablePullDown: true,
            onLoading: () {
              context.read<HomeCubit>().getNextPhotos();
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  centerTitle: false,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.changeThemeMode(AppPreferences.isModeDark
                                  ? ThemeMode.light
                                  : ThemeMode.dark);
                              print(
                                  "app preference ${AppPreferences.isModeDark}");
                              AppPreferences.isModeDark =
                                  !AppPreferences.isModeDark;
                            },
                            icon: Icon(!AppPreferences.isModeDark
                                ? Icons.brightness_2_outlined
                                : Icons.sunny),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          "پنجره",
                          // style: Theme.of(context).textTheme.headlineSmall,
                          style: TextStyle(
                              fontFamily: "vazir",
                              fontSize: 33,
                              color: !AppPreferences.isModeDark
                                  ? Colors.grey[600]
                                  : Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),

                      // Text('فونت ساحل',
                      //     style: PersianFonts.Sahel.copyWith(
                      //       fontSize: 23.0,
                      //     )),

                      // IconButton(
                      //     onPressed: () async {
                      //       String picturesDirectoryPath =
                      //           '/storage/emulated/0/Pictures/Pexel'; // Update this path
                      //       List<String> picturePaths =
                      //           await getAllPicturesInDirectory(
                      //               picturesDirectoryPath);

                      //       if (picturePaths.isNotEmpty) {
                      //         print("List of picture paths:");
                      //         for (var path in picturePaths) {
                      //           print(path);
                      //         }

                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) =>
                      //                 LinkGallery(theMyList: picturePaths),
                      //           ),
                      //         );
                      //       } else {
                      //         print(
                      //             "No pictures found in the specified directory.");
                      //       }
                      //     },
                      //     icon: Icon(
                      //       Icons.image,
                      //       size: 44,
                      //     ))
                    ],
                  ),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(76),
                    child: Container(
                      height: 76,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AppRouteName.search);
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          margin:
                              // const EdgeInsets.symmetric(horizontal: 16),
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.search,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8),
                              Text(" ... جستجوی کلمه کلیدی",
                                  style: TextStyle(
                                      fontFamily: "vazir",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey)
                                  //  Theme.of(context)
                                  //     .textTheme
                                  //     .bodyMedium
                                  //,     ?.copyWith(color: Colors.black),
                                  )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CollectionWidget(),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(icons[currentIconIndex]),
                          onPressed: _changeIcon,
                        ),
                        Container()
                        // Container(
                        //   padding: EdgeInsets.symmetric(horizontal: 12),
                        //   child: Text("عکس ها",
                        //       style: TextStyle(
                        //           fontFamily: "vazir",
                        //           fontSize: 22,
                        //           color: !AppPreferences.isModeDark
                        //               ? Colors.grey[600]
                        //               : Colors.white,
                        //           fontWeight: FontWeight.w600)),
                        // ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: PhotosWidget(
                    currentCategory: currentIconIndex,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<String>> getAllPicturesInDirectory(String directoryPath) async {
  try {
    // Get the list of files in the specified directory
    Directory directory = Directory(directoryPath);
    List<FileSystemEntity> files = directory.listSync();

    // Extract the paths of picture files
    List<String> picturePaths = [];
    for (var file in files) {
      if (file is File && _isImageFile(file.path)) {
        picturePaths.add(file.path);
      }
    }

    return picturePaths;
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

bool _isImageFile(String path) {
  // You can customize this function to check for specific image file extensions
  List<String> validExtensions = ['.jpeg', '.jpg', '.png', '.gif', '.bmp'];
  for (var extension in validExtensions) {
    if (path.toLowerCase().endsWith(extension)) {
      return true;
    }
  }
  return false;
}

class MyImageList extends StatelessWidget {
  final List<String> imagePaths;

  MyImageList({required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image List Example'),
      ),
      body: ListView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.file(
              File(imagePaths[index]),
              // You can set other properties like width, height, fit, etc.
            ),
          );
        },
      ),
    );
  }
}
