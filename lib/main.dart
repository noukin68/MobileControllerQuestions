import 'package:flutter/material.dart';
import 'package:flutter_application_1/intro_screen.dart';
import 'package:flutter_application_1/timer_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TimerScreen.initializeIsolateReceivePort();
  await TimerScreen.startListeningNotificationEvents();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final IO.Socket socket =
      IO.io('http://62.217.182.138:3000', <String, dynamic>{
    'transports': ['websocket'],
  });
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    socket.emit('client-type', 'Mobile App');
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: IntroScreen(socket),
    );
  }
}
