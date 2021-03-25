import 'dart:io';

import 'package:band_names/data/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nombreBanda = TextEditingController();

  List<Band> bandas = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active_bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    this.bandas =
        (payload as List).map((banda) => Band.fromMap(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active_bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    Map<String, double> dataMap = {};
    bandas.forEach((banda) {
      dataMap.putIfAbsent(banda.nombre, () => banda.votes.toDouble());
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Band Names'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.white)
                  : Icon(Icons.offline_bolt, color: Colors.red),
            ),
          ],
          elevation: 2.0,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                dataMap: dataMap,
                chartRadius: 200.0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: bandas.length,
                itemBuilder: (context, index) {
                  final Band banda = bandas[index];
                  return Dismissible(
                    key: Key(banda.id),
                    direction: DismissDirection.startToEnd,
                    background: DismissibleBackgroundBand(),
                    onDismissed: (direction) =>
                        socketService.emit('delete_band', {'id': banda.id}),
                    child: BandaListTile(
                      banda: banda,
                      socketService: socketService,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 2.0,
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                barrierDismissible: true,
                pageBuilder: (context, animation, ___) {
                  return NewBandAlertDialog(
                    nombreBanda: nombreBanda,
                    socketService: socketService,
                    animation: animation,
                  );
                },
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class NewBandAlertDialog extends StatelessWidget {
  const NewBandAlertDialog({
    Key key,
    @required this.nombreBanda,
    @required this.socketService,
    @required this.animation,
  }) : super(key: key);

  final TextEditingController nombreBanda;
  final SocketService socketService;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    socketService
                        .emit('new_band', {'nombre': nombreBanda.text});
                    Navigator.of(context).pop();
                  },
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
                  onPressed: () {
                    socketService
                        .emit('new_band', {'nombre': nombreBanda.text});
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
    );
  }
}

class DismissibleBackgroundBand extends StatelessWidget {
  const DismissibleBackgroundBand({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class BandaListTile extends StatelessWidget {
  const BandaListTile({
    Key key,
    @required this.banda,
    @required this.socketService,
  }) : super(key: key);

  final Band banda;
  final SocketService socketService;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: () => socketService.emit('vote_band', {'id': banda.id}),
    );
  }
}
