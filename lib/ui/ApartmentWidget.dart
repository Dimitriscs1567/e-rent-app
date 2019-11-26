import 'package:e_enoikiazetai/models/models.dart';
import 'package:flutter/material.dart';

class ApartmentWidget extends StatelessWidget {
Apartment apartment;
Function onTap;
Function onPressedPhone;
Function onPressedMap;
Function onPressedFavorite;

  ApartmentWidget({
    @required this.apartment,
    @required this.onTap,
    @required this.onPressedPhone,
    @required this.onPressedMap,
    @required this.onPressedFavorite,
  });

  @override
  Widget build(BuildContext context) {
    String title, title2, subtitle;

    title = apartment.type;
    title2 = "";
    if(apartment.floor == 0)
      title2 += "Ισόγειο";
    else if(apartment.floor > 0)
      title2 += "${apartment.floor}ος όροφος";

    if(apartment.squareMeters > 0) {
      if (title2.isNotEmpty)
        title2 += ", " + apartment.squareMeters.toString() + " τ.μ.";
      else
        title2 += apartment.squareMeters.toString() + " τ.μ.";
    }

    subtitle = "";
    if(apartment.address.isNotEmpty)
      subtitle += apartment.address;
    if(apartment.region.isNotEmpty){
      if(apartment.address.isNotEmpty)
        subtitle += ", " + apartment.region;
      else
        subtitle += apartment.region;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white))
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(apartment.id.toString(),
                          style: TextStyle(color: Colors.grey[400], fontSize: 15.0),
                        ),
                        Padding(padding: new EdgeInsets.all(5.0)),
                        Text(apartment.date,
                          style: TextStyle(color: Colors.grey[400], fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(title,
                          style: TextStyle(color: Colors.grey[300], fontSize: 20.0,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Offstage(
                          offstage: title2.isEmpty,
                          child: Text(title2,
                            style: TextStyle(color: Colors.grey[300], fontSize: 19.0,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(subtitle,
                          style: TextStyle(color: Colors.grey[300], fontSize: 17.0),
                          textAlign: TextAlign.center,
                        ),
                        Text(apartment.getSpecificationsAsString(),
                          style: TextStyle(color: Colors.grey[400], fontSize: 16.0),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green, size: 30.0,),
                          onPressed: onPressedPhone,
                        ),
                        IconButton(
                          icon: Icon(Icons.map, color: Colors.blue, size: 30.0,),
                          onPressed: onPressedMap,
                        ),
                        IconButton(
                          icon: apartment.isFavorite
                              ? Icon(Icons.favorite, color: Colors.red, size: 30.0,)
                              : Icon(Icons.favorite_border, color: Colors.red, size: 30.0,),
                          onPressed: onPressedFavorite,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: apartment.notes.isEmpty,
              child: Container(
                alignment: Alignment.topLeft,
                child: Image.asset("icons/noteIcon.png",
                  width: 80.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
