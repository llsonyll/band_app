import 'package:band_names/src/UI/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/socket_service.dart';
import 'src/UI/state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BandNames',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'home',
        routes: {
          'home': (_) => Home(),
          'state': (_) => StatePage(),
        },
      ),
    );
  }
}
