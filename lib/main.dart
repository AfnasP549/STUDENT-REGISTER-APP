import 'package:flutter/material.dart';
import 'package:register/db_helper/db_functions.dart';
import 'package:register/screens/home.dart'; 


Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDataBase();
  runApp(const Main());
}


class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
