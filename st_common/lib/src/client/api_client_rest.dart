import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/io_client.dart';

import '../models/base/error_model.dart';
import '../helpers/logs_helper.dart';

part 'api_config.dart';

class ApiClient {
  ApiClient._internal();

  static final ApiClient _singleton = new ApiClient._internal();

  static ApiClient get instance => _singleton;

  //
  //  Uri
  //
  dynamic getUri(String url, [Map<String, String> params]) {
    final uri = params != null
        ? _haveCert ? Uri.https(_urlBase, url, params) : Uri.http(_urlBase, url, params)
        : _haveCert ? Uri.https(_urlBase, url) : Uri.http(_urlBase, url);
    if (SHOW_DETAIL_LOGS || SHOW_MIN_LOGS) {
      print("🢁 URL: ${uri.toString()}");
    }
    return uri;
  }

  //
  //  Config
  //
  String token;
  Client http = Client();
  static const int TIMEOUT_SECONDS = 90;

  //
  // Certificate
  //
  static bool _certificateCheck(X509Certificate cert, String host, int port) =>
      host == _host;

  addSelfSignedCertificate(String certificate) {
    final SecurityContext context = SecurityContext.defaultContext;
    context.setTrustedCertificatesBytes(certificate.codeUnits);
    final ioClient = HttpClient(context: context)
      ..badCertificateCallback = _certificateCheck;

    http = IOClient(ioClient);
  }

  updateToken(String newToken)async{
    token = newToken;
  }

  //
  //  HEADERS
  //
  Future<Map<String, String>> getHeader() async {
    final headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${token ?? ''}",
    };
    if (SHOW_DETAIL_LOGS) {
      print("🢁 HEADER: $headers");
    }
    return headers;
  }

  Future<Map<String, String>> getHeaderTextPlain() async {
    final headers = {
//      HttpHeaders.contentTypeHeader: "application/octet-stream",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "text/plain, */*",
      'responseType': 'blob',
      HttpHeaders.authorizationHeader: "Bearer ${token ?? ''}",
    };
    if (SHOW_DETAIL_LOGS) {
      print("🢁 HEADER: $headers");
    }
    return headers;
  }

  Future<Response> _onTimeout() {
    throw ErrorModel.timeoutError;
  }

  _onCatchError(e) {
    if (SHOW_DETAIL_LOGS) {
      print('> ApiClient-_onCatchError $e');
    }
    if (e is SocketException) {
      switch (e.osError.errorCode) {
        case 101:
          throw ErrorModel.withoutConnection101;
          break;
        case 111:
          //server down
          throw ErrorModel.serverDown111;
          break;
        case 113:
        //server off
          throw ErrorModel.serverOff113;
          break;
        default:
          throw e;
      }
    }

    throw e;
  }

  //
  //  GET
  //

  Future<dynamic> get(String url, [Map<String, String> param, bool returnHeader = false]) async {
    final response = await http
        .get(getUri(url, param), headers: await getHeader())
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout)
        .catchError(_onCatchError);

    return _dataResponse(response, returnHeader);
  }

  //
  //  GET PDF => Uint8List
  //

  Future<Uint8List> getPdf(String url, [Map<String, String> param]) async {
    final response = await http
        .get(getUri(url, param), headers: await getHeaderTextPlain())
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout)
        .catchError(_onCatchError);

    try {
      if (SHOW_DETAIL_LOGS) {
        print("🢃 STATUS CODE: ${response.statusCode}");
        printWrapped("🢃 RESPONSE: ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          return response.bodyBytes;
        } else {
          return null;
        }
      } else {
        final parsed = response.body.isNotEmpty ? json.decode(response.body) : null;
        throw ErrorModel.fromJson(parsed ?? {});
      }
    } catch (e) {
      throw e;
    }
  }

  //
  // POST
  //

  Future<dynamic> post(String url, dynamic body) async {
    final response = await http
        .post(getUri(url), headers: await getHeader(), body: body != null ? json.encode(body) : null)
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout)
        .catchError(_onCatchError);
    if (SHOW_DETAIL_LOGS) {
      printWrapped("🢁 BODY: $body");
    }
    return _dataResponse(response);
  }

  //
  // POST FILES
  //
  Future<dynamic> postFiles(String url, List<MultipartFile> multipartFiles,[Map<String, String> param]) async {
    MultipartRequest request = MultipartRequest('POST', getUri(url, param));
    request.headers.addAll({
      HttpHeaders.contentTypeHeader: "multipart/form-data",
      HttpHeaders.authorizationHeader: "Bearer $token",
    });
    print("🢁 HEADER: ${request.headers}");

    multipartFiles.forEach((element) {
      print("🢁 FILE {name:${element.filename}, weight:${element.length}}");
      request.files.add(element);
    });

    final response = await request
        .send()
        .timeout(const Duration(seconds: TIMEOUT_SECONDS), onTimeout: () {
      throw ErrorModel.timeoutError;
    }).catchError(_onCatchError);

    final respStr = await response.stream.bytesToString();
    print("🢃 RESPONCE: $respStr");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(respStr);
    } else {
      throw jsonDecode(respStr)['file'] ??
          "Error ${response.statusCode}: $respStr";
    }
  }

  //
  // PUT
  //

  Future<dynamic> put(String url, dynamic body) async {
    final _body = json.encode(body);
    final response = await http
        .put(getUri(url), headers: await getHeader(), body: _body)
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout)
        .catchError(_onCatchError);
    if (SHOW_DETAIL_LOGS) {
      printWrapped("🢁 BODY: $_body");
    }
    return _dataResponse(response);
  }

  //
  //  DEL
  //

  Future<dynamic> delete(String url) async {
    final response = await http
        .delete(getUri(url), headers: await getHeader())
        .timeout(const Duration(seconds: TIMEOUT_SECONDS),
            onTimeout: _onTimeout)
        .catchError(_onCatchError);

    return _dataResponse(response);
  }

  //
  //  RESPONSE
  //
  dynamic _dataResponse(Response response, [bool returnHeader = false]) {
    try {
      if (SHOW_DETAIL_LOGS || SHOW_MIN_LOGS) {
        print("🢃 RESPONSE CODE:  ${response.statusCode}");
      }
      if (SHOW_DETAIL_LOGS) {
        printWrapped("🢃 RESPONSE: ${response.body}");
      }

      final parsed = response.body.isNotEmpty ? json.decode(response.body) : null;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (parsed != null) {
          if (returnHeader) {
            return {
              'headers': response.headers,
              'body': parsed,
            };
          } else {
            return parsed;
          }
        } else {
          return '';
        }
      } else {
        throw ErrorModel.fromJson(parsed ?? {});
      }
    } catch (e) {
      throw e;
    }
  }
}
