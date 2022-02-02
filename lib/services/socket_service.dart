import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    _socket = IO.io('ws://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

// Dart client
    _socket.on('connect', (_) {
      print('connect');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.on('event', (data) => print(data));
    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    _socket.on(
        'nuevo-mensaje',
        (payload) => {
              print('nuevo-mensaje: $payload'),
              print('nombre: ' + payload['nombre']),
              print('mensaje: ' + payload['mensaje']),
              print(payload.containsKey('mensaje2')
                  ? payload['mensaje2']
                  : 'no hay')
            });
  }
}
