import 'package:e_enoikiazetai/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ApartmentState extends Equatable{

  const ApartmentState();

  @override
  List<Object> get props => [];
}

class ApartmentLoading extends ApartmentState {}

class ApartmentLoaded extends ApartmentState {
  final List<Apartment> apartments;

  const ApartmentLoaded({@required this.apartments});

  @override
  List<Object> get props => [apartments];
}

class ApartmentError extends ApartmentState {}