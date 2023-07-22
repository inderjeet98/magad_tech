import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future authLogin(String body) async {
    var url = 'https://flutter.magadh.co/api/v1/users/login-request';
    Map<String, String> headers = {"Content-type": "application/json"};
    // String body = '''{\n    "phone": "9654674687"\n}''';
    final respoonse = await http.post(Uri.parse(url), headers: headers, body: body);
    // var data = jsonDecode(respoonse.body.toString());
    return respoonse;
  }

  Future verifyLogin(String body) async {
    var url = 'https://flutter.magadh.co/api/v1/users/login-verify';
    Map<String, String> headers = {"Content-type": "application/json"};
    // String body = '''{\n    "phone": "9654674687",\n    "otp": "449865"\n}''';
    final respoonse = await http.post(Uri.parse(url), headers: headers, body: body);
    var data = jsonDecode(respoonse.body.toString());
    return data;
  }

  Future verifyToken(String token) async {
    var url = 'https://flutter.magadh.co/api/v1/users/verify-token';
    Map<String, String> headers = {"Authorization": "Bearer $token", "Content-type": "application/json"};
    final respoonse = await http.get(Uri.parse(url), headers: headers);
    var data = jsonDecode(respoonse.body.toString());
    return data;
  }

  Future getUserList(String token) async {
    var url = 'https://flutter.magadh.co/api/v1/users?limit=30&page=1';
    Map<String, String> headers = {"Authorization": "Bearer $token", "Content-type": "application/json"};
    final respoonse = await http.get(Uri.parse(url), headers: headers);
    var data = jsonDecode(respoonse.body.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return data;
  }

  Future createUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var url = 'https://flutter.magadh.co/api/v1/users';
    Map<String, String> headers = {"Authorization": "Bearer $token", "Content-type": "application/json"};
    // String body = '''{\n    "phone": "9654674687"\n}''';
    final respoonse = await http.post(Uri.parse(url), headers: headers, body: body);
    // var data = jsonDecode(respoonse.body.toString());
    return respoonse;
  }
}
