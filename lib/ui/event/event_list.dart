import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/event/event_detail.dart';
import 'package:assessment/ui/event/widgets/categories.dart';
import 'package:assessment/ui/event/widgets/customTags.dart';
import 'package:assessment/ui/event/widgets/drop_down_search_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class EventList extends StatefulWidget {
  const EventList({Key? key}) : super(key: key);

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   Provider.of<AppProvider>(context, listen: false).searchByID();
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return ModalProgressHUD(
        inAsyncCall: appProvider.isLoading,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
              backgroundColor: AppConfig.colors.whiteColor,
              appBar: appBarCustom(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      children: List.generate(
                          appProvider.selectedCategories.length, (index) {
                        Categories cat = appProvider.selectedCategories[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: AppTagsCustom(
                            tag: cat.title,
                            onDeleted: () {
                              appProvider.removeTAgs(cat);
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10.sp),
                    if (appProvider.categoryList.isNotEmpty)
                      CategoriesGridView(),
                    SizedBox(height: 10.sp),
                    Column(
                        children: List.generate(
                            (appProvider.cocoExplorerData.imagesByID?.length) ??
                                0, (index) {
                      ImagesByID? imageDATA =
                          appProvider.cocoExplorerData.imagesByID![index];
                      List<ImagesCaptions> imageCaption = appProvider
                          .cocoExplorerData.imagesCaptions!
                          .where((element) => element.imageId == imageDATA.id)
                          .toList();
                      List<ImagesSegment> imageSegments = appProvider
                          .cocoExplorerData.imagesSegment!
                          .where((element) => element.imageId == imageDATA.id)
                          .toList();
                      return eventCard(
                          imageDATA, appProvider, imageCaption, imageSegments);
                    })),
                    SizedBox(height: 10.sp),
                  ],
                ),
              )),
        ),
      );
    });
  }

  PreferredSize appBarCustom() {
    return PreferredSize(
        preferredSize: Size.fromHeight(85.h), child: searchDropDown());
  }
}

Widget eventCard(ImagesByID imageData, AppProvider appProvider,
    List<ImagesCaptions> imageCaption, List<ImagesSegment> imageSegments) {
  return InkWell(
    onTap: () {
      Get.to(() => EventDetail(
          imageCaptions: imageCaption,
          imageData: imageData,
          imageSegments: imageSegments));
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin:
              EdgeInsets.only(top: 8.sp, left: 8.sp, right: 8.sp, bottom: 4.sp),
          padding: EdgeInsets.symmetric(horizontal: 8.sp),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (imageData.cocoUrl ?? "") != ""
                  ? eventImage(imageData, appProvider)
                  : errorImage(),
              SizedBox(width: 20.w),
              eventInfo(imageCaption),
            ],
          ),
        ),
        Divider(color: AppConfig.colors.grey),
      ],
    ),
  );
}

Widget eventInfo(List<ImagesCaptions> imageCaption) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (imageCaption.isNotEmpty)
          Text(
            "${imageCaption[0].caption}",
            overflow: TextOverflow.ellipsis,
            style: latoBold.copyWith(
                fontSize: 14.sp, color: AppConfig.colors.titleColor),
            textAlign: TextAlign.start,
            maxLines: 2,
          ),
      ],
    ),
  );
}

Widget eventImage(ImagesByID? imageData, AppProvider appProvider) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(8.sp),
      child: CachedNetworkImage(
        imageUrl: imageData?.cocoUrl ?? "",
        imageBuilder: (context, imageProvider) => Container(
          width: 50.sp,
          height: 50.sp,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => errorImage(),
      ));
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
