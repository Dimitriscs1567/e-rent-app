import 'package:e_enoikiazetai/blocs/apartment/blocs.dart';
import 'package:e_enoikiazetai/providers/providers.dart';
import 'package:e_enoikiazetai/repositories/repositories.dart';
import 'package:e_enoikiazetai/ui/ApartmentsPage.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/simple_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-rent',
      home: BlocProvider<ApartmentBloc>(
        builder: (context) => ApartmentBloc(
          apartmentRepository: ApartmentRepository(
            apartmentApiProvider: ApartmentApiProvider()
          ),
        ),
        child: ApartmentsPage(),
      ),
    );
  }
}
