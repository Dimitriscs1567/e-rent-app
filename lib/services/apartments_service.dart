import 'package:e_enoikiazetai/models/models.dart';

class ApartmentsService{

  static List<Apartment> apartments;

  static final String isFavoritePreferences = "f";

  static void fillApartments(List<Apartment> apartmentsList){
    apartments = apartmentsList;
  }
}