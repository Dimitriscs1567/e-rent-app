import 'package:e_enoikiazetai/models/models.dart';
import 'package:e_enoikiazetai/providers/apartment_api_provider.dart';
import 'package:flutter/cupertino.dart';

class ApartmentRepository{

  final ApartmentApiProvider apartmentApiProvider;

  ApartmentRepository({@required this.apartmentApiProvider});

  Future<List<Apartment>> getApartments() async{
    List<Apartment> apartments = await apartmentApiProvider.fetchApartments();
    return apartments;
  }
}