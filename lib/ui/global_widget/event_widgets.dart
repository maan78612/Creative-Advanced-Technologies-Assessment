import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/image_data_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:assessment/ui/event/event_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


Widget eventCard(
    {required ImageObjectModel imageObjectModel,
      required AppProvider appProvider}) {
  return InkWell(
    onTap: () {
      /* create segmentations against catID then store value in SegmentationAgainstCatID model object*/

      Get.to(() => EventDetail(imageObject: imageObjectModel));
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Container(
      margin:
      EdgeInsets.only(top: 8.sp, left: 8.sp, right: 8.sp, bottom: 4.sp),
      padding: EdgeInsets.symmetric(horizontal: 8.sp),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (imageObjectModel.imageData.cocoUrl ?? "") != ""
                  ? eventImage(imageObjectModel, appProvider)
                  : errorImage(),
              SizedBox(width: 20.w),
              eventInfo(imageObjectModel.imagesCaptions),
              SizedBox(width: 20.w),
              Icon(Icons.arrow_forward_ios,
                  size: 15.sp, color: AppConfig.colors.themeColor),
              SizedBox(width: 10.w),
            ],
          ),
          Divider(),
        ],
      ),
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

Widget eventImage(ImageObjectModel imageObject, AppProvider appProvider) {
  double iconSize = 14.sp;
  return Stack(
    clipBehavior: Clip.none,
    children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8.sp),
          child: CachedNetworkImage(
            imageUrl: imageObject.imageData.cocoUrl ?? "",
            imageBuilder: (context, imageProvider) => Container(
              width: 50.sp,
              height: 50.sp,
              decoration: BoxDecoration(
                image:
                DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => errorImage(),
          )),
      if (appProvider.checkFavImageObject(imageObject))
        Positioned(
            left: -iconSize / 2.sp,
            top: -iconSize / 2.sp,
            child: Container(
              decoration: BoxDecoration(
                  color: AppConfig.colors.whiteColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.sp))),
              padding: EdgeInsets.all(1.sp),
              child: GestureDetector(
                onTap: () {
                  appProvider.tabFavIcon(imageObject);
                },
                child: Icon(Icons.favorite,
                    size: iconSize, color: AppConfig.colors.redColor),
              ),
            ))
    ],
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