import 'dart:async';
import 'dart:convert';

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/image_data_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class EventDetail extends StatefulWidget {
  ImageObjectModel imageObject;

  EventDetail({required this.imageObject});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  late Size imageSize;
  List<SegmentationAgainstCatID> segmentationAgainstCatID = [];
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ui.Image image =
          await getImageSize(widget.imageObject.imageData.cocoUrl!);
      imageSize = Size(image.width.toDouble().sp, image.height.toDouble().sp);
      segmentationAgainstCatIDFunc();
      setState(() {
        isLoading = false;
      });

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConfig.colors.themeColor,
          centerTitle: true,
          title: Text(
            "Detail Screen",
            style: latoBlack.copyWith(
                fontSize: 18.sp, color: AppConfig.colors.whiteColor),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                appProvider.tabFavIcon(widget.imageObject);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: ImageIcon(
                  AssetImage(AppConfig.images.heart),
                  size: 25.sp,
                  color: appProvider.checkFavImageObject(widget.imageObject)
                      ? AppConfig.colors.redColor
                      : Color(0xffD9D4D5),
                ),
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.sp),
                    categoriesTab(appProvider),
                    SizedBox(height: 20.sp),
                    eventImage(widget.imageObject.imageData),
                    SizedBox(height: 20.sp),
                    eventInfo(widget.imageObject.imagesCaptions),
                  ],
                ),
              ),
      );
    });
  }

  Widget categoriesTab(AppProvider appProvider) {
    return Wrap(
      children: List.generate(segmentationAgainstCatID.length, (index) {
        SegmentationAgainstCatID seg = segmentationAgainstCatID[index];
        Categories cat = appProvider.categoryList
            .where((element) => element.id == seg.categoryID)
            .toList()
            .first;
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
    );
  }

  Future<ui.Image> getImageSize(String path) async {
    var completer = Completer<ImageInfo>();
    var img = new NetworkImage(path);
    img
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((info, _) {
      completer.complete(info);
    }));
    ImageInfo imageInfo = await completer.future;
    return imageInfo.image;
  }

  Widget eventInfo(List<ImagesCaptions> imageCaption) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Description:",
            style: latoBlack.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.titleColor),
            textAlign: TextAlign.start,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(imageCaption.length, (index) {
                String? text = imageCaption[index].caption;
                return Text(
                  text ?? "",
                  style: latoRegular.copyWith(
                      fontSize: 14.sp, color: AppConfig.colors.titleColor),
                  textAlign: TextAlign.start,
                );
              })),
        ],
      ),
    );
  }

  Widget eventImage(ImageData imageData) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.sp),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CachedNetworkImage(
              imageUrl: imageData.cocoUrl ?? "",
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
                width: imageSize.width.sp,
                height: imageSize.height.sp,
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Center(child: errorImage()),
            ),
            SizedBox(
              width: imageSize.width.sp,
              height: imageSize.height.sp,
              child: OverlayTutorialScope(
                enabled: true,
                overlayColor: Colors.blueAccent.withOpacity(.6),
                overlayChildren:
                    List.generate(segmentationAgainstCatID.length, (index) {
                  return OverlayTutorialHole(
                    enabled: true,
                    overlayTutorialEntry: OverlayTutorialCustomShapeEntry(
                      shapeBuilder: (rect, path) {
                        path = Path.combine(
                          PathOperation.difference,
                          path,
                          Path()
                            ..addPolygon(
                                segmentationAgainstCatID[index].offset, true),
                        );
                        return path;
                      },
                    ),
                    child: SizedBox.shrink(),
                  );
                }),
                child: SizedBox.shrink(),
              ),
            ),
          ],
        ));
  }

  Widget errorImage() {
    return Padding(
      padding: EdgeInsets.all(5.sp),
      child: Column(
        children: [
          Image.asset(
            AppConfig.images.noImage,
            fit: BoxFit.contain,
            height: 220.sp,
          ),
          Text(
            "Image not found",
            style: latoRegular.copyWith(
                fontSize: 16.sp, color: AppConfig.colors.grey),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  void segmentationAgainstCatIDFunc() {
    List<String> segmentString = [];
    List<int> catID = [];
    List<Offset> offset = [];

    print("image is is ${widget.imageObject.imageData.id}");
    /* Get number of segment categories in image*/
    widget.imageObject.imagesSegment.forEach((segments) {
      if (catID.contains(segments.categoryId!)) {
        print("already ");
      } else {
        catID.add(segments.categoryId!);
      }
    });

    print("number of categories in this image ${catID.length}");
    catID.forEach((categoryID) {
      widget.imageObject.imagesSegment.forEach((seg) {
        if (seg.categoryId == categoryID) {
          segmentString.add(seg.segmentation!);
        }
      });

      print("category is ${categoryID}");
      print(segmentString.length);
      List<double> segments = convertStringToList(segmentString);
      for (int x = 0; x < segments.length;) {
        // offset.add(Offset(segments[x] - 110.sp, segments[x + 1] + 25.sp));
        offset.add(Offset(segments[x] - imageSize.aspectRatio * 3,
            segments[x + 1] + imageSize.aspectRatio));
        x = x + 2;
      }
      segmentationAgainstCatID.add(SegmentationAgainstCatID(
          segmentation: segments, categoryID: categoryID, offset: offset));

      print(offset);
      segmentString = [];
      offset = [];
    });
  }

  List<double> convertStringToList(List<String> segmentString) {
    List<double> segment = [];
    segmentString.forEach((element) {
      var data = jsonDecode(element);
      print("data=$data");
      if (data.toString().contains("counts")) {
// data is not correct here
      } else {
        List<List<double>> imagesID = List<List<double>>.from(
            data.map((model) => List<double>.from(model)));
        imagesID.forEach((element) {
          element.forEach((e) {
            segment.add(e);
          });
        });
      }

      print("==========");
      print("segment= $segment");
    });

    return segment;
  }
}

class SegmentationAgainstCatID {
  int categoryID;
  List<double> segmentation;
  List<Offset> offset;

  SegmentationAgainstCatID(
      {required this.segmentation,
      required this.categoryID,
      required this.offset});
}
