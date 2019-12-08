import 'package:connectivity/connectivity.dart';
import 'package:e_enoikiazetai/models/models.dart';
import 'package:e_enoikiazetai/providers/providers.dart';
import 'package:flutter/cupertino.dart';

class ApartmentRepository{

  final ApartmentApiProvider apartmentApiProvider;
  static bool isSynced = false;

  ApartmentRepository({@required this.apartmentApiProvider});

  Future<List<Apartment>> getApartments() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    var dbProvider = ApartmentDbProvider();

    if((connectivityResult == ConnectivityResult.mobile
        || connectivityResult == ConnectivityResult.wifi) && !isSynced){

      List<Apartment> apartments = await apartmentApiProvider.fetchApartments();
      await dbProvider.storeApartments(apartments);
      isSynced = true;
    }

    List<Apartment> result = await dbProvider.fetchApartments();
    return result.reversed.toList();
  }
}