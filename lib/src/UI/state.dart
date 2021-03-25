import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatePage extends StatelessWidget {
  const StatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('State'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: socketService.serverStatus == ServerStatus.Connecting
                  ? CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    )
                  : socketService.serverStatus == ServerStatus.Online
                      ? Icon(Icons.check_circle, color: Colors.white)
                      : Icon(Icons.offline_bolt, color: Colors.red),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${socketService.serverStatus}'),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {
                  socketService.socket.emit('emitir_mensaje',
                      {'nombre': 'Flutter', 'mensaje': 'Hola desde flutter'});
                },
                child: Text('emitir'),
              ),
              TextButton(
                onPressed: () {
                  socketService.emit('emitir_mensaje',
                      {'nombre': 'Flutter', 'mensaje': 'Hola desde flutter 2'});
                },
                child: Text('emitir 2'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
