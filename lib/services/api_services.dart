import 'dart:convert';

import 'package:assessment/constants/app_uri.dart';
import 'package:assessment/model_classes/data_model.dart';
import 'package:assessment/model_classes/error_response.dart';
import 'package:assessment/utilities/api_functions.dart';

class APIServices {
  static COCOExplorerData cocoExplorerData = COCOExplorerData();

  static Future<dynamic> search(List<int> categoryIds) async {
    dynamic res = await getImageIDsByCategoryID(categoryIds);
    if (res is ErrorResponse) {
      return res;
    } else {
      List<int> imagesID = List<int>.from(res);
      print("length of ImagesID is");
      print(imagesID.length);
      await getImagesByID(ImagesID: imagesID).then((res) async {
        if (res is ErrorResponse) {
          return res;
        } else {
          cocoExplorerData.imagesByID = List<ImagesByID>.from(
              res.map((model) => ImagesByID.fromJson(model)));
          await getImagesSegment(ImagesID: imagesID).then((res) async {
            if (res is ErrorResponse) {
              return res;
            } else {
              cocoExplorerData.imagesSegment = List<ImagesSegment>.from(
                  res.map((model) => ImagesSegment.fromJson(model)));

              await getImagesCaption(ImagesID: imagesID).then((res) {
                if (res is ErrorResponse) {
                  return res;
                } else {
                  cocoExplorerData.imagesCaptions = List<ImagesCaptions>.from(
                      res.map((model) => ImagesCaptions.fromJson(model)));


                }
              });
            }
          });
        }
      });
    }
    return cocoExplorerData;
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
