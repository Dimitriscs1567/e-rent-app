import 'package:equatable/equatable.dart';

abstract class ApartmentEvent extends Equatable{

  const ApartmentEvent();

  @override
  List<Object> get props => [];
}

class FetchApartments extends ApartmentEvent{

  const FetchApartments();

  @override
  List<Object> get props => [];
}

class EmptyApartments extends ApartmentEvent{

  const EmptyApartments();

  @override
  List<Object> get props => [];
}