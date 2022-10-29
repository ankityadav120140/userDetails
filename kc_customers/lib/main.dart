import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kc_customers/pages/form.dart';
import 'package:kc_customers/pages/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SharedPreferences sharedpref = await SharedPreferences.getInstance();
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('admin').doc('adDoc').get();

  bool logged;
  String? id = sharedpref.getString('id');
  String? pw = sharedpref.getString('pw');

  if (id == snapshot['id'] && pw == snapshot['pw']) {
    logged = true;
  } else {
    logged = false;
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
