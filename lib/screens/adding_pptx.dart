import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddingPPTX extends StatefulWidget {
  static String routeName = '/adding-pptx';
  const AddingPPTX({super.key});

  @override
  State<AddingPPTX> createState() => _AddingPPTXState();
}

class _AddingPPTXState extends State<AddingPPTX> {
  File? _file;
  String? dropdownValue;
  String? fileName;
  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"]);

    if (result != null && result.files.single.path != null) {
      PlatformFile file = result.files.first;
      setState(() {
        fileName = file.name;
      });

      _file = File(result.files.single.path!);
    } else {}
  }

  bool isLoading = false;
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();

  Future<void> upLoadFile() async {
    setState(() {
      isLoading = true;
    });

    if (_file == null) {
      final snackBar = SnackBar(
        elevation: 0,
        padding: const EdgeInsets.all(0),
        content: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            child: const Text('Please, Select a file')),
        backgroundColor: Colors.transparent,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (!key.currentState!.validate()) {
      return;
    }
    DateTime now = DateTime.now();
    String? title = controller.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.setSettings(appVerificationDisabledForTesting: true);
    UserCredential? authResult;
    authResult = await auth.signInWithEmailAndPassword(
        email: 'omonovrahmatullo9@gmail.com', password: '123456');
    final ref = FirebaseStorage.instance
        .ref()
        .child("presentations")
        .child("${authResult.user!.uid}.pdf");
    await ref.putFile(_file!);
    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('presentations').add({
      
      'title': title,
      'url': url,
      'section': dropdownValue,
      'createdAt': now.toIso8601String()
    // ignore: body_might_complete_normally_catch_error
    }).catchError((error, stackTrace) {
      SnackBar snackBar = SnackBar(
          content:  Text('Something went wrong, try again$error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).then((value) {
      setState(() {
        isLoading = true;
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text("Adding Presentations",
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 30),
              const Text(
                'Select a presentation from files:',
                style: TextStyle(
                    color: Color.fromRGBO(15, 40, 81, 1), fontSize: 15),
              ),
              const SizedBox(height: 20),
              Form(
                  key: key,
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please, fill the form";
                        }
                        return null;
                      },
                      textCapitalization: TextCapitalization.characters,
                      cursorColor: const Color.fromRGBO(15, 40, 81, 1),
                      controller: controller,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(15, 40, 81, 1),
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(15, 40, 81, 1),
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(15, 40, 81, 1)),
                          labelText: 'Title'))),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('lessons')
                      .orderBy("createdAt")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      List<String> list = [];
                      for (int i = 0; i < data.length; i++) {
                        list.add(
                          data[i]['title'],
                        );
                      }
                      dropdownValue ??= list.first;

                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(25),
                            isExpanded: true,
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Color.fromRGBO(15, 40, 81, 1),
                            ),
                            elevation: 16,
                            style: const TextStyle(
                                color: Color.fromRGBO(15, 40, 81, 1)),
                            underline: Container(
                              height: 2,
                              color: const Color.fromRGBO(15, 40, 81, 1),
                            ),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        );
                      });
                    }
                    return Container(
                      color: Colors.white,
                      height: 40,
                      child: const CircularProgressIndicator(),
                    );
                  }),
              InkWell(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 15),
                            blurRadius: 40,
                            color: Colors.grey.shade300)
                      ]),
                  child: Text(
                    _file == null ? 'Choose File' : fileName!,
                    style: const TextStyle(
                        color: Color.fromRGBO(15, 40, 81, 1), fontSize: 25),
                  ),
                ),
              ),
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
                  onPressed: upLoadFile,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Color.fromRGBO(15, 40, 81, 1),
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(fontSize: 25),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
