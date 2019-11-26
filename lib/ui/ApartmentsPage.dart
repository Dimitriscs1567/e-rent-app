import 'package:e_enoikiazetai/blocs/apartment/blocs.dart';
import 'package:e_enoikiazetai/models/models.dart';
import 'package:e_enoikiazetai/services/apartments_service.dart';
import 'package:e_enoikiazetai/ui/ApartmentWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApartmentsPage extends StatefulWidget {

  @override
  _ApartmentsPageState createState() => _ApartmentsPageState();
}

class _ApartmentsPageState extends State<ApartmentsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Apartment> _listToShow = List<Apartment>();
  int _sortTimePressedSm, _sortTimePressedType;

  final _controllerNotes = TextEditingController();
  final _controllerSmFrom = TextEditingController();
  final _controllerSmTo = TextEditingController();
  final _controllerFloor = TextEditingController();

  Map<String, bool> _apartmentTypes, _apartmentSpecs;
  bool _showFiltered, _showFavorites;

  @override
  void initState() {
    _sortTimePressedSm = 0;
    _sortTimePressedType = 0;

    _apartmentTypes = Map<String, bool>();
    _apartmentSpecs = Map<String, bool>();

    _showFiltered = false;
    _showFavorites = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color smColor, typeColor;
    switch(_sortTimePressedSm){
      case 0: smColor = Colors.white; break;
      case 1: smColor = Colors.blue; break;
      case 2: smColor = Colors.green; break;
    }
    switch(_sortTimePressedType){
      case 0: typeColor = Colors.white; break;
      case 1: typeColor = Colors.blue; break;
      case 2: typeColor = Colors.green; break;
    }

    if(ApartmentsService.apartments == null){
      BlocProvider.of<ApartmentBloc>(context).add(FetchApartments());
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: _drawer(),
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text("e-Enoikiazetai"),
        actions: <Widget>[
          IconButton(
            icon: _showFavorites ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            tooltip: "Αγαπημένα",
            onPressed: (){
              setState(() {
                _showFavorites = !_showFavorites;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort, color: smColor,),
            tooltip: "Ταξινόμηση με τα τετραγωνικά",
            onPressed: (){
              setState(() {
                _sortTimePressedType = 0;
                _sortTimePressedSm++;
                if(_sortTimePressedSm == 3)
                  _sortTimePressedSm = 0;
              });

              if(_sortTimePressedSm > 0) {
                String text = _sortTimePressedSm == 1 ? "Ταξινόμηση με τα "
                    "τετραγωνικά (Από μεγαλύτερο προς μικρότερο)"
                    : "Ταξινόμηση με τα τετραγωνικά (Από μικρότερο προς μεγαλύτερο)";
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(text, textAlign: TextAlign.center,),
                  duration: Duration(milliseconds: 1500),
                ));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.sort_by_alpha, color: typeColor,),
            tooltip: "Ταξινόμηση με τον τύπο",
            onPressed: (){
              setState(() {
                _sortTimePressedSm = 0;
                _sortTimePressedType++;
                if(_sortTimePressedType == 3)
                  _sortTimePressedType = 0;

                if(_sortTimePressedType > 0) {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text("Ταξινόμηση με τον τύπο", textAlign: TextAlign.center,),
                    duration: Duration(milliseconds: 1500),
                  ));
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<ApartmentBloc, ApartmentState>(
        builder: (context, state){
          if(state is ApartmentLoading){
            return Center(child: CircularProgressIndicator());
          }
          else if(state is ApartmentLoaded){
            if(state.apartments.isEmpty){
              BlocProvider.of<ApartmentBloc>(context).add(EmptyApartments());
              return null;
            }

            if(ApartmentsService.apartments == null){
              ApartmentsService.apartments = state.apartments;
            }

            if(_apartmentTypes.keys.length == 0){
              _fillCheckBoxChoices();
            }

            return _apartmentListWidget();

          }
          return null;
        },
      ),
    );
  }

  Widget _apartmentListWidget(){
    _listToShow.clear();

    if(_showFiltered){
      ApartmentsService.apartments.forEach((apartment){
        if(_passesFilters(apartment))
          if((_showFavorites && apartment.isFavorite) || !_showFavorites)
            _listToShow.add(apartment);
      });
    }
    else {
      ApartmentsService.apartments.forEach((apartment) {
        if((_showFavorites && apartment.isFavorite) || !_showFavorites)
          _listToShow.add(apartment);
      });
    }

    _sortApartments();
    return ListView.builder(
      itemCount: _listToShow.length,
      itemBuilder: (context, index){
        return ApartmentWidget(
          apartment: _listToShow[index],
          onTap: (){
            showDialog(
                context: context,
                builder: (context){
                  _controllerNotes.text = _listToShow[index].notes;
                  return SimpleDialog(
                    backgroundColor: Colors.grey[700],
                    contentPadding: new EdgeInsets.all(8.0),
                    title: Text("Notes",
                      style: TextStyle(fontSize: 22.0, color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    children: <Widget>[
                      TextField(
                        maxLines: 8,
                        style: TextStyle(fontSize: 19.0, color: Colors.white),
                        controller: _controllerNotes,
                      ),
                      ButtonBar(
                        children: <Widget>[
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context, false);
                            },
                            child: Text("Cancel",
                                style: TextStyle(fontSize: 18.0, color: Colors.white,)
                            ),
                          ),
                          FlatButton(
                            onPressed: (){
                              Navigator.pop(context, true);
                            },
                            child: Text("Save",
                                style: TextStyle(fontSize: 18.0, color: Colors.white,)
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }
            ).then((forSave) async {
              if(forSave){
                setState(() {
                  _listToShow[index].notes = _controllerNotes.text.trim();
                });

                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(_controllerNotes.text.trim().isNotEmpty)
                  prefs.setString(_listToShow[index].id.toString(),
                    _controllerNotes.text.trim());
                else
                  prefs.remove(_listToShow[index].id.toString());
              }
            });
          },
          onPressedPhone: () async {
            if(_listToShow[index].phones.length == 1){
              await _callNumber(_listToShow[index].phones[0]);
            }
            else{
              _showDialogWithPhones(_listToShow[index].phones);
            }
          },
          onPressedMap: () async{
            String address = _listToShow[index].address;
            String googleUrl = "https://www.google.com/maps/place/";
            googleUrl += address.replaceAll(" ", "+");
            googleUrl += "+Ioannina";

            if (await canLaunch(googleUrl)) {
              await launch(googleUrl);
            }
            else {
              throw 'Could not open the map.';
            }
          },
          onPressedFavorite: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if(_listToShow[index].isFavorite)
              prefs.setBool(
                _listToShow[index].id.toString() + ApartmentsService.isFavoritePreferences,
                _listToShow[index].isFavorite
              );
            else
              prefs.remove(_listToShow[index].id.toString() + ApartmentsService.isFavoritePreferences);
            setState(() {
              _listToShow[index].isFavorite = !_listToShow[index].isFavorite;
            });
          },
        );
      },
    );
  }

  void _fillCheckBoxChoices(){
    ApartmentsService.apartments.forEach((apartment){
      if(!_apartmentTypes.containsKey(apartment.type))
        _apartmentTypes.addAll({apartment.type : false});

      apartment.specs.forEach((spec){
        if(!_apartmentSpecs.containsKey(spec))
          _apartmentSpecs.addAll({spec : false});
      });
    });
  }

  Future _showDialogWithPhones(List<String> phones) async {
    List<Widget> phoneWidgets = List<Widget>();
    phones.forEach((phone){
      phone = phone.replaceAll(" ", "");
      phoneWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(phone,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            Padding(padding: new EdgeInsets.all(15.0),),
            IconButton(
              icon: Icon(Icons.phone, color: Colors.green, size: 28.0,),
              onPressed: () async {
                await _callNumber(phone);
              },
            )
          ],
        ),
      );
    });

    await showDialog(
      context: context,
      builder: (context){
        return SimpleDialog(
          backgroundColor: Colors.grey[700],
          contentPadding: new EdgeInsets.all(5.0),
          children: phoneWidgets,
        );
      }
    );
  }

  Future _callNumber(String number) async {
    String phone = number.replaceAll(" ", "");
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    }
    else {
      throw 'Could not launch $url';
    }
  }

  Widget _drawer() {
    List<Widget> typeBoxes = List<Widget>();
    List<Widget> specBoxes = List<Widget>();

    _apartmentTypes.keys.forEach((key){
      typeBoxes.add(_checkBoxRow(key, true));
    });

    _apartmentSpecs.keys.forEach((key){
      specBoxes.add(_checkBoxRow(key, false));
    });

    return Drawer(
      child: Container(
        color: Colors.grey[600],
        child: ListView(
          children: <Widget>[
            Container(
              padding: new EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.center,
              color: Colors.grey[800],
              child: Text("Φίλτρα:",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold,
                  color: Colors.white),
              ),
            ),
            Padding(padding: new EdgeInsets.all(25.0)),
            _inputNumberRow("τ.μ.(Από):", _controllerSmFrom),
            Padding(padding: new EdgeInsets.all(10.0)),
            _inputNumberRow("τ.μ.(Έως):", _controllerSmTo),
            Padding(padding: new EdgeInsets.all(10.0)),
            _inputNumberRow("Όροφος(Από):", _controllerFloor),
            Padding(padding: new EdgeInsets.all(20.0)),
            Container(
              padding: new EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.center,
              color: Colors.grey[800],
              child: Text("Τύπος:",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Column(
              children: typeBoxes,
            ),
            Padding(padding: new EdgeInsets.all(10.0)),
            Container(
              padding: new EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.center,
              color: Colors.grey[800],
              child: Text("Ιδιότητα:",
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Column(
              children: specBoxes,
            ),
            Padding(padding: new EdgeInsets.all(20.0)),
            RaisedButton(
              padding: new EdgeInsets.symmetric(vertical: 15.0),
              color: Colors.green,
              child: Text("Εφαρμογή",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: (){
                setState(() {
                  _showFiltered = true;
                });
                Navigator.pop(context);
              },
            ),
            Padding(padding: new EdgeInsets.all(8.0)),
            RaisedButton(
              padding: new EdgeInsets.symmetric(vertical: 15.0),
              color: Colors.red,
              child: Text("Καθαρισμός",
                style: TextStyle(fontSize: 18.0),
              ),
              onPressed: (){
                setState(() {
                  _apartmentTypes.keys.forEach((key){
                    _apartmentTypes[key] = false;
                  });
                  _apartmentSpecs.keys.forEach((key){
                    _apartmentSpecs[key] = false;
                  });

                  _controllerSmTo.text = "";
                  _controllerSmFrom.text = "";
                  _controllerFloor.text = "";
                  _showFiltered = false;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputNumberRow(String text, TextEditingController controller){
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(text,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              padding: new EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5)
              ),
              width: 80.0,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 18.0, color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkBoxRow(String text, bool type){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Text(text,
            style: new TextStyle(fontSize: 18.0, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: Checkbox(
              value: type ? _apartmentTypes[text] : _apartmentSpecs[text],
              onChanged: (value){
                setState(() {
                  type ? _apartmentTypes[text] = value
                      : _apartmentSpecs[text] = value;
                });
              }
            ),
          ),
        )
      ],
    );
  }

  bool _passesFilters(Apartment apartment){
    if(_controllerSmFrom.text.isNotEmpty){
      int smFrom = int.parse(_controllerSmFrom.text);
      if(apartment.squareMeters < smFrom)
        return false;
    }
    if(_controllerSmTo.text.isNotEmpty){
      int smTo = int.parse(_controllerSmTo.text);
      if(apartment.squareMeters > smTo)
        return false;
    }
    if(_controllerFloor.text.isNotEmpty){
      int floor = int.parse(_controllerFloor.text);
      if(apartment.floor < floor)
        return false;
    }
    if(!_apartmentTypes[apartment.type] && _thereIsSelectedType())
      return false;
    for(String key in _apartmentSpecs.keys)
      if(_apartmentSpecs[key] && !apartment.specs.contains(key))
        return false;

    return true;
  }

  bool _thereIsSelectedType(){
    for (String key in _apartmentTypes.keys)
      if (_apartmentTypes[key])
        return true;

    return false;
  }

  void _sortApartments(){
    if(_sortTimePressedSm > 0)
      _listToShow.sort((apartment1, apartment2){
        if(_sortTimePressedSm == 1) {
          int res = apartment2.squareMeters.compareTo(apartment1.squareMeters);
          if(res == 0)
            return apartment1.type.compareTo(apartment2.type);
          else
            return res;
        }
        else if(_sortTimePressedSm == 2) {
          int res =  apartment1.squareMeters.compareTo(apartment2.squareMeters);
          if(res == 0)
            return apartment1.type.compareTo(apartment2.type);
          else
            return res;
        }
        else
          return apartment2.id.compareTo(apartment1.id);
      });
    else if(_sortTimePressedType > 0)
      _listToShow.sort((apartment1, apartment2){
        if(_sortTimePressedType == 1) {
          int res =  apartment1.type.compareTo(apartment2.type);
          if(res == 0)
            return apartment2.squareMeters.compareTo(apartment1.squareMeters);
          else
            return res;
        }
        else if(_sortTimePressedType == 2) {
          int res = apartment2.type.compareTo(apartment1.type);
          if(res == 0)
            return apartment2.squareMeters.compareTo(apartment1.squareMeters);
          else
            return res;
        }
        else
          return apartment2.id.compareTo(apartment1.id);
      });
  }
}
