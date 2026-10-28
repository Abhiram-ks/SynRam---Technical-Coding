import 'dart:convert';

import 'package:flutter_study/user_model/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  var client =  http.Client();
  var url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  Future<List<UserModel>> get() async {
    try {
      var response = await client.get(url);
      if (response.statusCode != 200) {
        throw Exception("StatusCode: ${response.statusCode}");
      }
      final decodeList = jsonDecode(response.body) as List<dynamic>;
      return decodeList.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}