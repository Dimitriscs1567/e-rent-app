import 'dart:core';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class Apartment extends Equatable{
  int id;
  String date;
  String availableFrom;
  String type;
  int squareMeters;
  int floor;
  String address;
  String region;
  List<String> phones;
  int price;
  String notes;
  List<String> specs;
  bool isFavorite;

  Apartment({
    @required this.id,
    @required this.date,
    @required this.availableFrom,
    @required this.type,
    @required this.squareMeters,
    @required this.floor,
    @required this.address,
    @required this.region,
    @required this.phones,
    this.notes,
    @required this.specs,
    this.isFavorite,
  });

  @override
  List<Object> get props => [id, date, availableFrom, type, squareMeters,
    floor, address, region, phones, notes, specs, isFavorite];

  static Apartment fromJson(dynamic json){

    return Apartment(
      id: json["id"],
      date: json["date"],
      availableFrom: json["availableFrom"],
      type: json["type"],
      squareMeters: json["squareMeters"],
      floor: json["floor"],
      address: json["address"] != null ? json["address"] : "",
      region: json["region"] != null ? json["region"] : "",
      phones: json["phones"].split(","),
      specs: json["features"] != null ? json["features"].split(",") : List<String>(),
      isFavorite: false,
      notes: "",
    );
  }

  String getSpecificationsAsString(){
    String result = "";

    specs.forEach((spec) => result += "$spec, ");

    if(specs.length > 0){
      return result.substring(0, result.length-2);
    }
    return result;
  }
}