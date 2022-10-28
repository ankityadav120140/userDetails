import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kc_customers/pages/sign_in.dart';

class formPage extends StatefulWidget {
  const formPage({super.key});

  @override
  State<formPage> createState() => _formPageState();
}

class _formPageState extends State<formPage> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();

  void addCustomer() async {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('users').doc();
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot2 = await transaction.get(ref);
      if (!snapshot2.exists) {
        ref.set({
          'name': name.text,
          'phoneNo': number.text,
        });
      }
    });
    const snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Text('User Added'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Customer"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            space(10),
            reusableTextWidget(
              name,
              TextInputType.name,
              MediaQuery.of(context).size.width,
              '',
              "Enter Name",
            ),
            space(20),
            const Text(
              "Number",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            space(10),
            reusableTextWidget(
              number,
              TextInputType.number,
              MediaQuery.of(context).size.width,
              '+91',
              "Enter Mobile Number",
            ),
            space(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  addCustomer();
                },
                child: const Text(
                  "Add Customer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
