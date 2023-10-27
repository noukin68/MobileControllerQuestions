import 'package:flutter/material.dart';
import 'package:flutter_application_1/timer_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LoginPage extends StatefulWidget {
  final IO.Socket socket;

  LoginPage(this.socket);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController uidController = TextEditingController();
  String uid = "";
  String message = "";
  bool shouldShowLogin = false;

  @override
  void initState() {
    super.initState();
    shouldShowLogin = true;
    checkLoggedInStatus();
  }

  Future<void> authenticate() async {
    final response = await http.post(
      Uri.parse('http://62.217.182.138:3000/uidLogin'),
      headers: {'Content-Type': 'application/json'},
      body: '{"uid": "$uid"}',
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => TimerScreen(widget.socket)),
        (Route<dynamic> route) => false,
      );
    } else if (response.statusCode == 401) {
      setState(() {
        message = 'Неверный UID';
      });
    } else {
      setState(() {
        message = 'Введите UID';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFCEAD),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 50),
            Center(
              child: Image.asset(
                'assets/logoController.png',
                height: 150,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Введите ваш UID',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(119, 75, 36, 1),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              cursorColor: Color.fromRGBO(119, 75, 36, 1),
              controller: uidController,
              style: TextStyle(
                color: Color.fromRGBO(119, 75, 36, 1),
              ),
              decoration: InputDecoration(
                labelText: 'Введите UID',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(119, 75, 36, 1),
                ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(119, 75, 36, 1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromRGBO(119, 75, 36, 1),
                  ),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  uid = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: authenticate,
              child: Text('Войти'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Color.fromRGBO(119, 75, 36, 1),
                foregroundColor: Color.fromRGBO(239, 206, 173, 1),
              ),
            ),
            SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(
                color: Color.fromRGBO(119, 75, 36, 1),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'при поддержке',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(119, 75, 36, 1),
                        fontFamily: 'Calibri',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/pixel.png',
                          width: 90,
                          height: 90,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/faz.png',
                          width: 90,
                          height: 90,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      if (mounted) {
        setState(() {
          shouldShowLogin = false; // Скрыть страницу авторизации
        });
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TimerScreen(widget.socket)),
      );
    } else {
      if (mounted) {
        setState(() {
          shouldShowLogin = true; // Показать страницу авторизации
        });
      }
    }
    (Route<dynamic> route) => false;
  }
}
