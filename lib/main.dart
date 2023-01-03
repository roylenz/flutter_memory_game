import 'package:flutter/material.dart';
import 'package:memory_game/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<String, String> pairs = {
      "1": "2",
      "3": "4",
      "5": "6",
      "7": "8",
      "9": "10",
      "11": "12",
      "13": "14",
      "15": "16",
      "17": "18",
      "19": "20",
    };
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen());
  }
}
