import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CategoriesGridView extends StatefulWidget {
  @override
  _CategoriesGridViewState createState() => _CategoriesGridViewState();
}

class _CategoriesGridViewState extends State<CategoriesGridView> {
  int rowLength = 0;
  var serviceWidth = 70.w;
  int pageCount = 0;
  int selectedIndex = 0;
  late int lastPageItemLength;
  PageController pageController = PageController();
  int perPageItem = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);

    var num1 = Get.width / serviceWidth;
    rowLength = num1.toInt();
    perPageItem = rowLength + rowLength;

    var num =
        (Provider.of<AppProvider>(context, listen: false).categoryList.length /
            perPageItem);
    pageCount = num.isInt ? num.toInt() : num.toInt() + 1;

    var reminder = Provider.of<AppProvider>(context, listen: false)
        .categoryList
        .length
        .remainder(perPageItem);
    lastPageItemLength = reminder == 0 ? perPageItem : reminder;

    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 130.h,
            child: PageView.builder(
                controller: pageController,
                itemCount: pageCount,
                onPageChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                itemBuilder: (_, pageIndex) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: List.generate(
                          (pageCount - 1) != pageIndex
                              ? perPageItem
                              : lastPageItemLength, (index) {
                        num t = index + (pageIndex * perPageItem);
                        Categories categories = appProvider
                            .categoryList[index + (pageIndex * perPageItem)];
                        return categoriesTab(categories, appProvider);
                      }),
                    ),
                  );
                }),
          ),
          SizedBox(height: 5.h),
          categorySlider(),
        ],
      );
    });
  }

  Row categorySlider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        categorySliderButton(
            onTab: () {
              if (selectedIndex >= 1) {
                pageController.animateToPage(selectedIndex - 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              }
            },
            icon: Icon(Icons.arrow_back_ios, size: 20.sp)),
        Text(
          "${selectedIndex + 1}/${pageCount}",
          textAlign: TextAlign.center,
          style: latoBold.copyWith(fontSize: 18.sp),
        ),
        categorySliderButton(
            onTab: () {
              if (selectedIndex <= pageCount) {
                pageController.animateToPage(selectedIndex + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              }
            },
            icon: Icon(Icons.arrow_forward_ios, size: 20.sp)),
      ],
    );
  }

  GestureDetector categorySliderButton(
      {required Function onTab, required Widget icon}) {
    return GestureDetector(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppConfig.colors.whiteColor,
              backgroundColor: AppConfig.colors.themeColor,
            ),
            onPressed: () {
              onTab();
            },
            child: icon));
  }

  GestureDetector categoriesTab(
      Categories categories, AppProvider appProvider) {
    return GestureDetector(
      onTap: () {
        appProvider.addTAgs(categories);
      },
      child: SizedBox(
        width: serviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: serviceWidth / 8),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.sp),
                  child: CachedNetworkImage(
                    imageUrl: categories.image ?? "",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50.sp,
                      height: 50.sp,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => errorImage(),
                  )),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget errorImage() {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child: Image.asset(
        AppConfig.images.noImage,
        fit: BoxFit.contain,
        width: 50.sp,
        height: 50.sp,
      ),
    );
  }
}

extension NumExtensions on num {
  bool get isInt => (this % 1) == 0;
}
