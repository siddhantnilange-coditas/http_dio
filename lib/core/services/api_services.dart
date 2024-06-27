// bloc/product_bloc.dart
// services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http_dio/main.dart';
import 'package:path_provider/path_provider.dart';

import 'package:dio/dio.dart';
import 'package:http_dio/features/show_data/domain/data_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Dio _dio = Dio();

  // ApiService() {
  //   _dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         options.headers['Authorization'] = 'Bearer my_token';
  //                         print("Request Headers: ${options.headers}");

  //         return handler.next(options);
  //       },
  //     ),
  //   );
  // }

 String _accessToken = 'initial_access_token';
  String _refreshToken = 'initial_refresh_token';

  ApiService()
    {
          _dio.interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) {
                options.headers['Auth'] = '$_accessToken';
                print("Request Headers: ${options.headers}"); 
                return handler.next(options);
              },
              onError: (DioException error, handler) async {
                if (error.response?.statusCode == 401) {
                  final refreshTokenResponse = await _attemptTokenRefresh();
                  if (refreshTokenResponse) {
                    final options = error.response!.requestOptions;
                    options.headers['Auth'] = 'Bearer $_accessToken';
                    final cloneReq = await _dio.request(
                      options.path,
                      options: Options(
                        method: options.method,
                        headers: options.headers,
                      ),
                      data: options.data,
                      queryParameters: options.queryParameters,
                    );
                    return handler.resolve(cloneReq);
                  }
                }
                return handler.next(error); 
              },
              onResponse: (response, handler) {
                print("Response: ${response.data}"); 
                return handler.next(response);
              },
            ),
          );
        }

  Future<bool> _attemptTokenRefresh() async {
    try {
      final response = await _dio.post(
      'https://jsonplaceholder.typicode.com/posts',
        data: {'refresh_token': _refreshToken},
      );
              // alice.onHttpResponse(response);

      if (response.statusCode == 200) {
        _accessToken = response.data['access_token'];
        _refreshToken = response.data['refresh_token'];
        return true;
      }
    } catch (e) {
      print('Failed to refresh token: $e');
    }

    return false;
  }

  
  // Future<List<User>> fetchUsers() async {
  //   final responseOfFetching = await _dio.get(
  //     'https://jsonplaceholder.typicode.com/posts',
  //   );
  //             // alice.onHttpResponse(responseOfFetching);

  //   if (responseOfFetching.statusCode == 200) {
  //     List<User> users = (responseOfFetching.data as List)
  //         .map((user) => User.fromJson(user))
  //         .toList();
  //     return users;
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  // }

Future<http.Response> fetchUsers() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  final responseOfFetching = await http.get(url);
  
  //             alice.onHttpResponse(responseOfFetching);
  //           // setStaus(1);
  // if (responseOfFetching.statusCode == 200) {
  //   List<dynamic> jsonResponse = jsonDecode(responseOfFetching.body);
  //   List<User> users = jsonResponse.map((user) => User.fromJson(user)).toList();
  //   return users;
  // } else {
  //   throw Exception('Failed to load products');
  // }
  return responseOfFetching;
}

  Future<http.Response> postUser(User postData) async {
    try {
        final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

        final responseOfFetching = await http.post(url);

      // final response = await _dio.post(
      //   'https://jsonplaceholder.typicode.com/posts',
      //   data: postData.toJson(),
      //   onSendProgress: (sent, total) {
      //     print('$sent $total');
      //   },
      // );

      return responseOfFetching;
    } catch (e) {
      throw Exception('Failed to post user: $e');
    }
  }

  Future<String> _getDesktopDirectory() async {
      if (Platform.isMacOS || Platform.isLinux) {
        final directory = await getDownloadsDirectory();
        return directory?.path ?? '';
    } else if (Platform.isWindows) {
        final userDir = Platform.environment['USERPROFILE'] ?? '';
        return '$userDir\\Desktop';
    } else if (Platform.isAndroid || Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        return directory.path;
    } else {
        throw UnsupportedError('Unsupported platform');
    }
    // if (Platform.isMacOS || Platform.isLinux) {
    //   final directory = await getDownloadsDirectory();
    //   return directory?.path ?? '';
    // } else if (Platform.isWindows) {
    //   final userDir = Platform.environment['USERPROFILE'] ?? '';
    //   return '$userDir\\Desktop';
    // } else {
    //   throw UnsupportedError('Unsupported platform');
    // }
  }

Future<File?> downloadFile(String url, String fileName) async {
    try {
      String desktopPath = await _getDesktopDirectory();
      if (desktopPath.isNotEmpty) {
        final file = File('$desktopPath/$fileName');

        final response = await _dio.get(
          url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ),
        );
                          alice.onHttpResponse(response.data);

        final raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        // OpenFile.open(file.path); 
        return file;
      } else {
        throw Exception("Unable to get the desktop directory");
      }
    } catch (e) {
      rethrow;
    }
  }
  
  
// Future<File?> downloadFile(String url, String fileName) async {
//   try {
//     String desktopPath = await _getDesktopDirectory();
//     if (desktopPath.isNotEmpty) {
//       // final appStorage = await getApplicationDocumentsDirectory();
//         final file = File('$desktopPath/$fileName');

//     // final appStorage = await getApplicationCacheDirectory();
//     //   final file =File('${appStorage.path}/${event.fileName}');

//       final response = await _dio.get(
//         url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,

//         )
//       );
      

//       final raf = file.openSync(mode: FileMode.write);
//       raf.writeFromSync(response.data);
//       await raf.close();

//       return file;
//     } else {
//       throw Exception("Unable to get the desktop directory");
//     }
//   } catch (e) {
//     rethrow;
//   }
// }

}
