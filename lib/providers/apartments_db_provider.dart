import 'dart:core';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:e_enoikiazetai/models/models.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ApartmentDbProvider {

  final String _dbName = "apartments.db";
  static Database db;

  Future<Database> get database async {
    if(db == null) {
      var dir = await getApplicationDocumentsDirectory();
      await dir.create(recursive: true);
      var dbPath = join(dir.path, _dbName);
      db = await databaseFactoryIo.openDatabase(dbPath);
    }

    return db;
  }

  Future<List<Apartment>> fetchApartments() async {
    var db = await database;
    var store = intMapStoreFactory.store("apartments");

    List<int> keys = await store.findKeys(db);
    List<Map<String, dynamic>> apartmentsAsJson = [];

    for(int i in keys){
      apartmentsAsJson.add(await store.record(i).get(db));
    }

    List<Apartment> apartments = [];

    for(var json in  apartmentsAsJson) {
      apartments.add(await Apartment.fromJson(json));
    }

    return apartments;
  }

  Future storeApartments(List<Apartment> apartments) async {
    var db = await database;
    var store = intMapStoreFactory.store("apartments");

    await store.drop(db);

    for(Apartment apartment in apartments) {
      await store.record(apartment.id).put(db, apartment.toJson());
    }
  }
}

