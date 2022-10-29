import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kc_customers/pages/form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signIn extends StatefulWidget {
  const signIn({super.key});

  @override
  State<signIn> createState() => _signInState();
}

class _signInState extends State<signIn> {
  TextEditingController id = TextEditingController();
  TextEditingController pw = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ID",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              space(10),
              reusableTextWidget(
                id,
                TextInputType.emailAddress,
                MediaQuery.of(context).size.width,
                '',
                "Enter your ID",
              ),
              space(20.0),
              const Text(
                "Password ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              space(10),
              reusableTextWidget(
                pw,
                TextInputType.name,
                MediaQuery.of(context).size.width,
                '',
                "Password",
              ),
              space(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    valididate();
                  },
                  child: const Text(
                    "Log IN",
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
      ),
    );
  }

  void valididate() async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('admin').doc('adDoc').get();
    print("ID FOUND : " + snapshot['id']);
    if (id.text == snapshot['id'] && pw.text == snapshot['pw']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', id.text);
      prefs.setString('pw', pw.text);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const formPage()),
      );
      const snackBar = SnackBar(
        backgroundColor: Colors.green,
        content: Text('Logged In'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      const snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text('Wrong Credentials'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}

Widget space(double h) {
  return SizedBox(
    height: h,
  );
}

reusableTextWidget(
  TextEditingController controller,
  TextInputType textInputType,
  double width,
  String prefix,
  String hintText,
) {
  return SizedBox(
    width: width,
    child: TextFormField(
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
