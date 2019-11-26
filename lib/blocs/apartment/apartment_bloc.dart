import 'package:bloc/bloc.dart';
import 'package:e_enoikiazetai/blocs/apartment/apartment_event.dart';
import 'package:e_enoikiazetai/blocs/apartment/apartment_state.dart';
import 'package:e_enoikiazetai/models/models.dart';
import 'package:e_enoikiazetai/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';

class ApartmentBloc extends Bloc<ApartmentEvent, ApartmentState>{

  final ApartmentRepository apartmentRepository;

  ApartmentBloc({@required this.apartmentRepository});

  @override
  ApartmentState get initialState => ApartmentLoading();

  @override
  Stream<ApartmentState> mapEventToState(event) async*{
    if(event is FetchApartments){
      yield ApartmentLoading();

      try{
        final List<Apartment> apartments = await apartmentRepository.getApartments();
        yield ApartmentLoaded(apartments: apartments);
      } catch(_){
        yield ApartmentError();
      }
    }
    else if(event is EmptyApartments){
      yield ApartmentError();
    }
  }
}