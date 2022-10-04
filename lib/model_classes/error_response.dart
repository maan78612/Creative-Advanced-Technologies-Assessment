class ErrorResponse {
  final int? errorCode;
  final String? errorDescription;
  final dynamic error;

  ErrorResponse(
      {required this.errorCode, required this.errorDescription, this.error});
}

class MyHeaders {
  static Map<String, String> header() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }
}