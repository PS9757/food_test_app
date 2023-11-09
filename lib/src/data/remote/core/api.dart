import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final List<String> url = [
  'https://theoptimiz.com/restro/public/api/',
  ];
  const int isbeta = 0;



const Map<String, dynamic> defaultHEADERS = {
  "Content-Type": "application/json"
};

class Api {
  final Dio _dio = Dio();
  Api() {
    _dio.options.baseUrl = url[isbeta];
    _dio.options.headers = defaultHEADERS;
    _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true));
  }

  Dio get sendRequest => _dio;
}

class ApiResponse {
  String success;
  dynamic data;
  int? code;
  ApiResponse({required this.success, this.data, this.code});

  factory ApiResponse.fromResponse(Response response) {
    final data = response.data[0] as Map<String, dynamic>;
    return ApiResponse(
      success: data["status"],
      code: data["code"],
      data: data["data"],
    );
  }
}
