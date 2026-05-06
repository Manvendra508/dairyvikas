import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStream => _connectionController.stream;

  void initialize() async {
    final results = await _connectivity.checkConnectivity();

    _connectionController.add(!results.contains(ConnectivityResult.none));

    _connectivity.onConnectivityChanged.listen((results) {
      _connectionController.add(!results.contains(ConnectivityResult.none));
    });
  }
}
