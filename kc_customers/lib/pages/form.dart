import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:kc_customers/pages/sign_in.dart';

final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
        }).then((value) {
          name.text = '';
          number.text = '';
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Add Customer"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              space(10),
              reusableTextWidget2(
                  name,
                  1,
                  200,
                  TextInputType.name,
                  MediaQuery.of(context).size.width,
                  '',
                  "Enter Name",
                  "Enter Valid Name"),
              space(20),
              const Text(
                "Number",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              space(10),
              reusableTextWidget2(
                  number,
                  10,
                  10,
                  TextInputType.number,
                  MediaQuery.of(context).size.width,
                  '+91',
                  "Enter Mobile Number",
                  "Enter Valid Number"),
              space(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final isValidForm = _formkey.currentState?.validate();
                    if (isValidForm == true) {
                      addCustomer();
                    }
                  },
                  child: const Text(
                    "Add Customer",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).viewInsets.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

reusableTextWidget2(
  TextEditingController controller,
  int min,
  int max,
  TextInputType textInputType,
  double width,
  String prefix,
  String hintText,
  String errorText,
) {
  return SizedBox(
    width: width,
    child: TextFormField(
      maxLength: max,
      validator: LengthRangeValidator(min: min, max: max, errorText: errorText),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enableSuggestions: true,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixText: prefix,
        counterText: "",
        hintText: hintText,
        labelStyle: const TextStyle(
          color: Colors.black45,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    ),
  );
}
