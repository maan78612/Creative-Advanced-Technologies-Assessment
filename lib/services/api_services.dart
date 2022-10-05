import 'dart:convert';

import 'package:assessment/constants/app_uri.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/utilities/api_functions.dart';

class APIServices {
  static Future<dynamic> search(
      List<int> imagesID, COCOExplorerData cocoExplorerData) async {
    await getImagesByID(ImagesID: imagesID).then((res) async {
      if (res is ErrorResponse) {
        return res;
      } else {
        setImagesData(res, cocoExplorerData);

        await getImagesSegment(ImagesID: imagesID).then((res) async {
          if (res is ErrorResponse) {
            return res;
          } else {
            setSegmentData(res, cocoExplorerData);

            await getImagesCaption(ImagesID: imagesID).then((res) {
              if (res is ErrorResponse) {
                return res;
              } else {
                setCaptionData(res, cocoExplorerData);
              }
            });
          }
        });
      }
    });

    return cocoExplorerData;
  }

  static void setSegmentData(res, COCOExplorerData cocoExplorerData) {
    List<ImagesSegment> imagesSegment = [];
    imagesSegment = List<ImagesSegment>.from(
        res.map((model) => ImagesSegment.fromJson(model)));

    print(imagesSegment.length);
    for (var i = 0; i < imagesSegment.length; i++) {
      cocoExplorerData.imagesSegment?.add(imagesSegment[i]);
    }
  }

  static void setCaptionData(res, COCOExplorerData cocoExplorerData) {
    List<ImagesCaptions> imagesCaptions = [];
    imagesCaptions = List<ImagesCaptions>.from(
        res.map((model) => ImagesCaptions.fromJson(model)));

    for (var i = 0; i < imagesCaptions.length; i++) {
      cocoExplorerData.imagesCaptions?.add(imagesCaptions[i]);
    }
  }

  static void setImagesData(res, COCOExplorerData cocoExplorerData) {
    List<ImageData> imagesByID = [];
    imagesByID =
        List<ImageData>.from(res.map((model) => ImageData.fromJson(model)));

    for (var i = 0; i < imagesByID.length; i++) {
      cocoExplorerData.imagesByID?.add(imagesByID[i]);
    }
  }

  static Future<dynamic> getImageIDsByCategoryID(List<int> categoryIds) async {
    ApiRequests api = ApiRequests();
    String url = Apis.dataSetURL;
    Map<String, dynamic> body = {
      "category_ids": categoryIds,
      "querytype": "getImagesByCats"
    };
    print("body is :$body");

    dynamic res = await api.postRequest(url: url, body: body);
    return res;
  }

  static Future<dynamic> getImagesByID({required List<int> ImagesID}) async {
    ApiRequests api = ApiRequests();
    String url = Apis.dataSetURL;
    Map<String, dynamic> body = {
      "image_ids": ImagesID,
      "querytype": "getImages"
    };
    print("body is :$body");

    dynamic res = await api.postRequest(url: url, body: body);
    return res;
  }

  static Future<dynamic> getImagesSegment({required List<int> ImagesID}) async {
    ApiRequests api = ApiRequests();
    String url = Apis.dataSetURL;
    Map<String, dynamic> body = {
      "image_ids": ImagesID,
      "querytype": "getInstances"
    };
    print("body is :$body");

    dynamic res = await api.postRequest(url: url, body: body);
    return res;
  }

  static Future<dynamic> getImagesCaption({required List<int> ImagesID}) async {
    ApiRequests api = ApiRequests();
    String url = Apis.dataSetURL;
    Map<String, dynamic> body = {
      "image_ids": ImagesID,
      "querytype": "getCaptions"
    };
    print("body is :$body");

    dynamic res = await api.postRequest(url: url, body: body);
    return res;
  }
}
