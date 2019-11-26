import 'dart:convert';
import 'dart:io';

import 'package:e_enoikiazetai/.env.dart';

import 'package:http/http.dart' as http;

class AuthorizationProvider{

  static String validationToken = "";

  static Future<String> getValidationToken(bool newToken) async {
    if(newToken || validationToken.compareTo("") == 0){

      final response = await http.post(
        "https://e-rent-api.herokuapp.com/api/v1/auth/signin",
        body: json.encode({
          "email" : environment["email"],
          "password" : environment["password"]
        }),
        headers: {HttpHeaders.contentTypeHeader : "application/json"}
      );

      if(response.statusCode == 200){
        final json = jsonDecode(response.body);

        validationToken = json["token"];
      }
      else{
        throw Exception('error in validation with code: ${response.statusCode}');
      }
    }

    return validationToken;
  }
}