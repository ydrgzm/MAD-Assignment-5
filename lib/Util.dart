import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kGreen = Color(0xff064439);
const kWhite = Color(0xffeee7ce);
const kBlack = Color(0xff1d242c);

class Util {
  static void makeToast(String mesg) {
    Fluttertoast.showToast(
        msg: mesg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kGreen.withOpacity(0.3),
        textColor: kBlack,
        fontSize: 16.0);
  }

  static Future<void> ShowDialog(BuildContext context, {String id = ''}) async {
    final database = FirebaseDatabase.instance.ref('Persons');
    final formKey = GlobalKey<FormState>();
    TextEditingController name = TextEditingController();
    TextEditingController mobile = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController gender = TextEditingController();
    String modalTitle = 'Add Person';
    if (id != '') {
      DataSnapshot snapshot = await database.child(id).get();
      Map m = snapshot.value as Map;
      name.text = m['name'];
      mobile.text = m['mobile'];
      email.text = m['email'];
      gender.text = m['gender'];
      modalTitle = 'Update Person';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 2,
          icon: Icon(
              id == '' ? Icons.person_add_alt_1_rounded : Icons.person_rounded,
              size: 50),
          alignment: Alignment.center,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topRight: Radius.circular(20))),
          title: Center(
              child: Text(
            modalTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          content: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InputBox(
                          title: 'Name',
                          controller: name,
                          keyBoard: TextInputType.name,
                          helperText: 'Only alphabets are allowed'),
                      InputBox(
                          title: 'Email',
                          controller: email,
                          keyBoard: TextInputType.emailAddress,
                          helperText: 'Provide valid email address'),
                      InputBox(
                          title: 'Mobile no',
                          controller: mobile,
                          keyBoard: TextInputType.phone,
                          helperText: 'Format should be 03001234567'),
                      InputBox(
                          title: 'Gender',
                          controller: gender,
                          helperText: 'Male or Female'),
                    ],
                  )),
            ),
          ),
          actions: [
            TextButton(
                style: TextButton.styleFrom(foregroundColor: kGreen),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: kGreen, foregroundColor: Colors.white),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (id == '') {
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      database.child(id).set({
                        'id': id,
                        'name': name.text.toString().trim(),
                        'email': email.text.toString().trim(),
                        'mobile': mobile.text.toString().trim(),
                        'gender': gender.text.toString().trim()
                      });
                      Navigator.pop(context);
                      makeToast('Person has been added!');
                    } else {
                      database.child(id).update({
                        'name': name.text.toString().trim(),
                        'email': email.text.toString().trim(),
                        'mobile': mobile.text.toString().trim(),
                        'gender': gender.text.toString().trim()
                      });
                      Navigator.pop(context);
                      makeToast('Person has been updated!');
                    }
                  }
                },
                child: const Text('Save'))
          ],
        );
      },
    );
  }
}

class InputBox extends StatelessWidget {
  const InputBox({
    Key? key,
    required this.title,
    required this.controller,
    this.keyBoard = TextInputType.text,
    this.helperText = '',
  }) : super(key: key);
  final String title, helperText;
  final TextEditingController controller;
  final TextInputType keyBoard;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        keyboardType: keyBoard,
        controller: controller,
        decoration: InputDecoration(
          helperText: helperText,
          hintText: title,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.red, width: 2)),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: kGreen, width: 2)),
          contentPadding: const EdgeInsets.all(10),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '$title field cannot be left empty';
          }
          return null;
        },
      ),
    );
  }
}
