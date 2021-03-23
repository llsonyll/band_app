import 'dart:io';

import 'package:band_names/data/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nombreBanda = TextEditingController();

  List<Band> bandas = [
    Band(id: '0', nombre: 'The Cure', votes: 0),
    Band(id: '1', nombre: 'Oasis', votes: 1),
    Band(id: '2', nombre: 'Bon Jovi', votes: 5),
    Band(id: '3', nombre: 'Red Hot Chilli Peppers', votes: 3),
  ];

  void agregarBanda(String nombre) {
    if (nombre.length > 5) {
      setState(() {
        bandas.add(
          Band(id: '${bandas.length}', nombre: nombre, votes: 0),
        );
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names'),
        centerTitle: true,
        actions: [
          Icon(
            Icons.connect_without_contact_outlined,
            color: Colors.blue,
          ),
        ],
        elevation: 2.0,
      ),
      body: ListView.builder(
        itemCount: bandas.length,
        itemBuilder: (context, index) {
          final Band banda = bandas[index];
          return Dismissible(
            key: Key(banda.id),
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.purple,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Alaos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 21.0,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              // Borrar el item en el servidor Back-End
            },
            child: ListTile(
              title: Text(banda.nombre),
              subtitle: Text('Id: ${banda.id}'),
              leading: CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.blue,
                child: Text(
                  banda.nombre.substring(0, 2),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              trailing: Text(
                banda.votes.toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 21.0,
                ),
              ),
              onTap: () {
                print('disque tap');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              barrierDismissible: true,
              pageBuilder: (context, animation, builder) {
                return FadeTransition(
                  opacity: animation,
                  child: Platform.isAndroid
                      ? AlertDialog(
                          title: Text('Alert Dialog'),
                          content: TextField(
                            controller: nombreBanda,
                          ),
                          actions: [
                            ElevatedButton(
                              child: Text('Click!'),
                              onPressed: () => agregarBanda(nombreBanda.text),
                            ),
                          ],
                        )
                      : CupertinoAlertDialog(
                          title: Text('Alert Dialog'),
                          content: CupertinoTextField(
                            controller: nombreBanda,
                          ),
                          actions: [
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: Text('add'),
                              onPressed: () => agregarBanda(nombreBanda.text),
                            ),
                          ],
                        ),
                );
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
