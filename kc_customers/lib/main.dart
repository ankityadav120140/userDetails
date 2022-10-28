import 'package:flutter/material.dart';
import 'package:kc_customers/pages/form.dart';
import 'package:kc_customers/pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPreferences sharedpref = await SharedPreferences.getInstance();

  bool logged;
  if (sharedpref.getBool('loggedIn') == null ||
      sharedpref.getBool('loggedIn') == false) {
    logged = false;
  } else {
    logged = true;
  }

  runApp(MyApp(
    Logged: logged,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.Logged});
  final bool Logged;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KC Users',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Logged ? formPage() : signIn(),
    );
  }
}
