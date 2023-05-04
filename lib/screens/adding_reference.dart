import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddingReference extends StatefulWidget {
  static String routeName = "/adding-reference";
  const AddingReference({super.key});

  @override
  State<AddingReference> createState() => _AddingReferenceState();
}

class _AddingReferenceState extends State<AddingReference> {
  String? dropdownValue;
  final key = GlobalKey<FormState>();
  final controller1 = TextEditingController();
  bool isLoading = false;

  void _submit() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'omonovrahmatullo9@gmail.com', password: '123456');
    try {
      await FirebaseFirestore.instance.collection('ref').add({
        'ref': controller1.text,
        'section': dropdownValue,
        'createdAt': DateTime.now().toIso8601String(),
      // ignore: body_might_complete_normally_catch_error
      }).catchError((err) {
        SnackBar snackBar = SnackBar(
          content: const Text('Something went wrong, try again'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).then((value) async {
        await FirebaseAuth.instance.signOut();
      });
    } finally {
      setState(() {
        isLoading = false;
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                'Adding References',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: controller1,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please, fill form';
                          }
                          return null;
                        },
                        cursorColor: const Color.fromRGBO(15, 40, 81, 1),
                        decoration: _inputDecoration('Reference'),
                      ),
                      const SizedBox(height: 20),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(15, 40, 81, 1))),
                          onPressed: isLoading? null : _submit,
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 25),
                                ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
        border: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(15, 40, 81, 1), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromRGBO(15, 40, 81, 1), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        labelStyle: const TextStyle(color: Color.fromRGBO(15, 40, 81, 1)),
        labelText: labelText);
  }
}
