import 'dart:convert';
import 'dart:io';
import 'package:e_enoikiazetai/models/models.dart';
import 'package:e_enoikiazetai/repositories/authorization_provider.dart';
import 'package:http/http.dart' as http;

class ApartmentApiProvider{
  static const baseUrl = "https://e-rent-api.herokuapp.com/api/v1/";
  static const addToUrl = "apartments";

  Future<List<Apartment>> fetchApartments() async{
    final url = "$baseUrl$addToUrl";

    String token = await AuthorizationProvider.getValidationToken(false);
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
    );

    if(response.statusCode != 200){
      token = await AuthorizationProvider.getValidationToken(true);
      response = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"}
      );
    }

    if(response.statusCode == 200){
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> jsonApartments = json["_embedded"]["apartments"] as List;

      List<Apartment> apartments = [];

      jsonApartments.forEach((jsonApartment){
        apartments.add(Apartment.fromJson(jsonApartment));
      });

      return apartments;
    }
    else{
      throw Exception('error getting apartments with code: ${response.statusCode}');
    }
  }
}