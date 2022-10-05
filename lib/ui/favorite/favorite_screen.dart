import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/image_data_model.dart';
import 'package:assessment/provider/app_provider.dart';

import 'package:assessment/ui/global_widget/event_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Categories> categories = [];

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.sp),
            title(title: "Favorite Categories"),
            SizedBox(height: 10.sp),
            categoriesTab(appProvider, categories),
            SizedBox(height: 10.sp),
            title(title: "Favorite Items"),
            Expanded(
              child: ListView.builder(
                itemCount: appProvider.favoriteImageObjects.length,
                itemBuilder: (_, index) {
                  ImageObjectModel favImageObject =
                  appProvider.favoriteImageObjects[index];

                  return eventCard(
                      imageObjectModel: favImageObject,
                      appProvider: appProvider);
                },
              ),
            ),
            SizedBox(height: 10.sp),
          ],
        ),
      );
    });
  }

  Text title({required String title}) {
    return Text(
      "$title:",
      style: latoBlack.copyWith(
          fontSize: 22.sp, color: AppConfig.colors.themeColor),
    );
  }

  void getCategories() {
    AppProvider appProvider = Provider.of<AppProvider>(Get.context!);
    List<int> catID = [];
    appProvider.categoryList.forEach((cat) {
      appProvider.favoriteImageObjects.forEach((fav) {
        fav.imagesSegment.forEach((seg) {
          if (catID.contains(seg.categoryId)) {
            print("already ");
          } else {
            catID.add(seg.categoryId!);
          }
        });
      });
    });

    print("number of categories in this image ${catID.length}");
    catID.forEach((cID) {
      categories.add(
          appProvider.categoryList.where((element) => element.id == cID).first);
    });
  }

  Widget categoriesTab(AppProvider appProvider, List<Categories> catList) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.sp),
      child: Wrap(
        children: List.generate(catList.length, (index) {
          Categories cat = catList[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.sp),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: Image.network(
                cat.image,
                width: 50.sp,
                height: 50.sp,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}
