import 'dart:async';
import 'dart:convert';

import 'package:assessment/constants/app_constants.dart';
import 'package:assessment/constants/styles.dart';
import 'package:assessment/model_classes/categories_model.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/provider/app_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_tutorial/overlay_tutorial.dart';
import 'package:provider/provider.dart';

class EventDetail extends StatefulWidget {
  List<ImagesSegment> imageSegments;
  ImagesByID imageData;
  List<ImagesCaptions> imageCaptions;

  EventDetail(
      {required this.imageCaptions,
      required this.imageData,
      required this.imageSegments});

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  // late Size imageSize;

  bool isLoading = true;
  List<SegmentationAgainstCatID> segmentationAgainstCatID = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // imageSize = await _calculateImageDimension(widget.imageData.cocoUrl!);
      setState(() {
        isLoading = false;
      });
      // print(imageSize);
      segmentationAgainstCatIDFunc();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Detail Screen"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.sp),
                    categoriesTab(appProvider),
                    SizedBox(height: 20.sp),
                    eventImage(widget.imageData),
                    SizedBox(height: 20.sp),
                    eventInfo(widget.imageCaptions),
                    SizedBox(height: 20.h),
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
          padding: EdgeInsets.symmetric(horizontal: 4.sp),
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

            // CachedNetworkImage(
            //   imageUrl: cat.image,
            //   imageBuilder: (context, imageProvider) => Container(
            //     width: 50.sp,
            //     height: 50.sp,
            //     decoration: BoxDecoration(
            //       image:
            //           DecorationImage(image: imageProvider, fit: BoxFit.cover),
            //     ),
            //   ),
            //   placeholder: (context, url) => CircularProgressIndicator(),
            //   errorWidget: (context, url, error) => errorImage(),
            // )
          ),
        );
      }),
    );
  }

  Future<Size> _calculateImageDimension(String url) {
    setState(() {
      isLoading = true;
    });
    Completer<Size> completer = Completer();
    Image image = Image.network("$url");
    if (mounted)
      image.image.resolve(ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
            var myImage = image.image;
            Size size =
                Size(myImage.width.toDouble(), myImage.height.toDouble());
            completer.complete(size);
          },
        ),
      );

    return completer.future;
  }

  Widget eventInfo(List<ImagesCaptions> imageCaption) {
    return Expanded(
      child: Column(
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
    );
  }

  Widget eventImage(ImagesByID imageData) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8.sp),
            child: CachedNetworkImage(
              imageUrl: imageData.cocoUrl ?? "",
              imageBuilder: (context, imageProvider) => Container(
                height: 220.sp,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) =>
                  Center(child: errorImage()),
            )),
        OverlayTutorialScope(
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
                      ..addPolygon(segmentationAgainstCatID[index].offset, true),
                  );
                  return path;
                },
              ),
              child: SizedBox.shrink(),
            );
          }),
          child: SizedBox.shrink(),
        ),
      ],
    );
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

  List<double> convertStringToList(List<String> segmentString) {
    List<double> segment = [];
    segmentString.forEach((element) {
      var data = jsonDecode(element);
      List<List<double>> imagesID = List<List<double>>.from(
          data.map((model) => List<double>.from(model)));
      imagesID.forEach((element) {
        element.forEach((e) {
          segment.add(e);
        });
      });
    });

    return segment;
  }

  void segmentationAgainstCatIDFunc() {
    List<String> segmentString = [];
    List<int> catID = [];
    List<Offset> offset = [];
    print("image is is ${widget.imageData.id}");
    /* Get number of segment categories in image*/
    widget.imageSegments.forEach((segments) {
      if (catID.contains(segments.categoryId!)) {
        print("already ");
      } else {
        catID.add(segments.categoryId!);
      }
    });

    print("number of categories in this image ${catID.length}");
    catID.forEach((categoryID) {
      widget.imageSegments.forEach((seg) {
        if (seg.categoryId == categoryID) {
          segmentString.add(seg.segmentation!);
        }
      });

      print("category is ${categoryID}");
      print(segmentString.length);
      List<double> segments = convertStringToList(segmentString);
      for (int x = 0; x < segments.length;) {
        offset.add(Offset(segments[x], segments[x + 1]));
        x = x + 2;
      }
      segmentationAgainstCatID.add(SegmentationAgainstCatID(
          segmentation: segments, categoryID: categoryID, offset: offset));

      print(offset);
      segmentString = [];
      offset = [];
    });
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
