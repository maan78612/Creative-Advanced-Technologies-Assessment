import 'dart:convert';
import 'dart:io';

import 'package:assessment/model_classes/error_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiRequests {



  Future postRequest(
      {required String url, required Map<String, dynamic> body}) async {
    Dio dio = Dio();
    dynamic response;
    if (kDebugMode) {
      print("URL is $url");
    }
    bool isConnected = await checkInternet();
    if (isConnected == false) {
      if (kDebugMode) {
        print("no internet connection");
      }
      ErrorResponse(
          errorCode: -444, errorDescription: " No internet connection");
    }
    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(
          responseType: ResponseType.plain,
          headers: MyHeaders.header(),
          sendTimeout: 50000, //_defaultTimeout,
          receiveTimeout: 50000, //_defaultTimeout,
        ),
      );

      if (kDebugMode) {
        print(response.statusCode);
        print("response is $response");
      }

      var jsonResponse = json.decode(response.toString());
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        if (kDebugMode) {
          print("error when hit Api ${response.statusMessage}");
        }
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(response.statusMessage!),
        );
      }
    }on DioError catch (e) {
      if (e.error is HttpException) {
        if (kDebugMode) {
          print("Couldn't find the post [HttpException]\n${e.message}");
        }

        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else if (e.error is FormatException) {
        if (kDebugMode) {
          print("Bad response format [FormatException]\n${e.message}");
        }
        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else if (e.error is SocketException) {
        if (kDebugMode) {
          print('No Internet connection [SocketException]\n${e.message}');
        }

        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else {
        if (kDebugMode) {
          print('[get] error ($url) -> ${e.toString()}');
        }
        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      }
    }
  }





  Future getRequest({required String url, Map<String, dynamic>? params}) async {
    Dio dio = Dio();
    dynamic response;
    if (kDebugMode) {
      print("URL is $url");
    }
    bool isConnected = await checkInternet();
    if (isConnected == false) {
      if (kDebugMode) {
        print("no internet connection");
      }
      ErrorResponse(
          errorCode: -444, errorDescription: " No internet connection");
    }
    try {
      response = await dio.get(
        url,
        queryParameters: params,
        options: Options(
          headers: MyHeaders.header(),
          sendTimeout: 12000, //_defaultTimeout,
          receiveTimeout: 12000, //_defaultTimeout,
        ),
      );
      if (kDebugMode) {
        print(response?.statusCode);
        print("response is $response");
      }

      var jsonResponse = json.decode(response.toString());
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        if (kDebugMode) {
          print("error when hit Api ${response.statusMessage}");
        }
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(response.statusMessage!),
        );
      }
    }on DioError catch (e) {
      if (e.error is HttpException) {
        if (kDebugMode) {
          print("Couldn't find the post [HttpException]\n${e.message}");
        }

        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else if (e.error is FormatException) {
        if (kDebugMode) {
          print("Bad response format [FormatException]\n${e.message}");
        }
        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else if (e.error is SocketException) {
        if (kDebugMode) {
          print('No Internet connection [SocketException]\n${e.message}');
        }

        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      } else {
        if (kDebugMode) {
          print('[get] error ($url) -> ${e.toString()}');
        }
        return ErrorResponse(
          errorCode: response?.statusCode,
          errorDescription: e.message,
        );
      }
    }
  }



  Future deleteRequest(
      {required String url, required Map<String, dynamic> body}) async {
    Dio dio = Dio();
    dynamic response;
    if (kDebugMode) {
      print("URL is $url");
    }
    bool isConnected = await checkInternet();
    if (isConnected == false) {
      if (kDebugMode) {
        print("no internet connection");
      }
      ErrorResponse(
          errorCode: -444, errorDescription: " No internet connection");
    }
    try {
      response = await dio.delete(
        url,
        data: body,
        options: Options(
          headers: MyHeaders.header(),
          sendTimeout: 12000, //_defaultTimeout,
          receiveTimeout: 12000, //_defaultTimeout,
        ),
      );

      if (kDebugMode) {
        print(response.statusCode);
        print("response is $response");
      }

      var jsonResponse = json.decode(response.toString());
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        if (kDebugMode) {
          print("error when hit Api ${response.statusMessage}");
        }
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(response.statusMessage!),
        );
      }
    } on SocketException catch (error) {
      if (kDebugMode) {
        print('No Internet connection [SocketException]\n${error.message}');
      }

      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on HttpException catch (error) {
      if (kDebugMode) {
        print("Couldn't find the post [HttpException]\n${error.message}");
      }

      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on FormatException catch (error) {
      if (kDebugMode) {
        print("Bad response format [FormatException]\n${error.message}");
      }
      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } catch (e) {
      if (kDebugMode) {
        print('[get] error ($url) -> ${e.toString()}');
      }
      if (e is DioError) {
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(e.message),
        );
      }
    }
  }

  Future patchRequest(
      {required String url, required Map<String, dynamic> body}) async {
    Dio dio = Dio();
    dynamic response;
    if (kDebugMode) {
      print("URL is $url");
    }
    bool isConnected = await checkInternet();
    if (isConnected == false) {
      if (kDebugMode) {
        print("no internet connection");
      }
      ErrorResponse(
          errorCode: -444, errorDescription: " No internet connection");
    }
    try {
      response = await dio.patch(
        url,
        data: body,
        options: Options(
          headers: MyHeaders.header(),
          sendTimeout: 12000, //_defaultTimeout,
          receiveTimeout: 12000, //_defaultTimeout,
        ),
      );

      if (kDebugMode) {
        print(response.statusCode);
        print("response is $response");
      }

      var jsonResponse = json.decode(response.toString());
      if (response.statusCode == 200) {
        return jsonResponse;
      } else {
        if (kDebugMode) {
          print("error when hit Api ${response.statusMessage}");
        }
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(response.statusMessage!),
        );
      }
    } on SocketException catch (error) {
      if (kDebugMode) {
        print('No Internet connection [SocketException]\n${error.message}');
      }

      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on HttpException catch (error) {
      if (kDebugMode) {
        print("Couldn't find the post [HttpException]\n${error.message}");
      }

      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } on FormatException catch (error) {
      if (kDebugMode) {
        print("Bad response format [FormatException]\n${error.message}");
      }
      return ErrorResponse(
        errorCode: response.statusCode,
        errorDescription: jsonDecode(error.message),
      );
    } catch (e) {
      if (kDebugMode) {
        print('[get] error ($url) -> ${e.toString()}');
      }
      if (e is DioError) {
        return ErrorResponse(
          errorCode: response.statusCode,
          errorDescription: jsonDecode(e.message),
        );
      }
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (kDebugMode) {
          print('connected');
        }
        return true;
      }
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      return false;
    }
    return false;
  }
}
