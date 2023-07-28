import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/adding_video_widget.dart';

class AddingVideo extends StatefulWidget {
  static const routeName = '/adding-video';
  const AddingVideo({super.key});

  @override
  State<AddingVideo> createState() => _AddingVideoState();
}

class FieldClass {
  Widget child;
  int id;
  FieldClass(this.child, this.id);
}

class ControllerClass {
  TextEditingController child;
  int id;
  ControllerClass(this.child, this.id);
}

class _AddingVideoState extends State<AddingVideo> {
  final key = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final textController = TextEditingController();
  final headerCont = TextEditingController();
  final headerNode = FocusNode();
  final titleNode = FocusNode();
  final textNode = FocusNode();
  bool err = false;
  File? _pickedVideo;
  int? duration;
  void takeImage(File pickedVideo, int duration) {
    _pickedVideo = pickedVideo;
    this.duration = duration;
    print(this.duration);
  }

  @override
  void dispose() {
    super.dispose();
    headerCont.dispose();
    headerNode.dispose();
    titleController.dispose();
    textController.dispose();
    titleNode.dispose();
    textNode.dispose();
    refController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fields = [];
    controllers = [];
    controllersDef = [];
  }

  String? text;

  var isLoading = false;
  var isLoadingone = false;

  static List<ControllerClass> controllers = [];

  static List<ControllerClass> controllersDef = [];

  static List<FieldClass> fields = [];

  void addFormField() {
    setState(() {
      controllers.add(
        ControllerClass(TextEditingController(), controllers.length),
      );
      controllersDef
          .add(ControllerClass(TextEditingController(), controllersDef.length));
      fields.add(FieldClass(
          TextContainer(
              Form(
                  child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('New Glossary')),
                    controller: controllers.last.child,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(label: Text('Definition')),
                    controller: controllersDef.last.child,
                  ),
                ],
              )),
              controllers.length - 1),
          controllers.length - 1));
    });
  }

  Future<void> saveForm() async {
    if (!key.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: 'omonovrahmatullo9@gmail.com', password: '123456')
        .then((value) async {
      for (int i = 0; i < fields.length; i++) {
        if (controllers[i].child.text.isNotEmpty &&
            controllersDef[i].child.text.isNotEmpty) {
          await FirebaseFirestore.instance.collection(('glossaries')).add({
            'word': controllers[i].child.text.trim(),
            'section': titleController.text.trim(),
            'definition': controllersDef[i].child.text.trim()
          });
        }
      }
    }).catchError((er) {
      SnackBar snackBar =
          const SnackBar(content: Text('New Word has not been added'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).then((value) async {
      await FirebaseFirestore.instance.collection('lessons').add({
        'title': titleController.text.trim(),
        'text': textController.text.trim(),
      }).then((value) async {
        setState(() {
          isLoading = false;
          isLoadingone = true;
        });
        final ref = FirebaseStorage.instance
            .ref()
            .child('video')
            .child('${value.id}-${titleController.text.trim()}');
        await ref.putFile(_pickedVideo!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('lessons')
            .doc(value.id)
            .update({
          'video_url': '${url}.mp4',
          'title': titleController.text.trim(),
          'headerText': headerCont.text.trim(),
          'text': text,
          'createdAt': DateTime.now().toIso8601String(),
          'Editor': 'Guli Ergasheva Ismailovna',
          'duration': duration.toString()
        });
        setState(() {
          isLoadingone = false;
        });
      }).then((value) async {
        Navigator.of(context).popAndPushNamed('/');
        await FirebaseAuth.instance.signOut();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Adding video"),
                actions: [
                  IconButton(
                      onPressed: isLoading || isLoadingone ? null : saveForm,
                      icon: const Icon(Icons.file_upload_outlined))
                ],
              ),
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : isLoadingone
                      ? const Center(
                          child: Text('Now,Your Video is UpLoading...'),
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Form(
                                  key: key,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: titleController,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(headerNode);
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please fill a form';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            label: const Text('Title'),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        controller: headerCont,
                                        onFieldSubmitted: (_) {
                                          FocusScope.of(context)
                                              .requestFocus(textNode);
                                        },
                                        focusNode: headerNode,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please fill a form';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            label: const Text('Header Text'),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                      const SizedBox(height: 20),
                                      TextFormField(
                                        focusNode: textNode,
                                        maxLines: 5,
                                        controller: textController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please fill a form';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (value) {
                                          text = value;
                                        },
                                        keyboardType: TextInputType.multiline,
                                        // textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                            labelStyle:
                                                const TextStyle(fontSize: 30),
                                            label: const Text('Text'),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  overlayColor: MaterialStateProperty.all(
                                      const Color.fromRGBO(208, 209, 255, 1)),
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: textController.text.isEmpty &&
                                          titleController.text.isEmpty
                                      ? () {
                                          final snackBar = SnackBar(
                                            elevation: 0,
                                            padding: const EdgeInsets.all(0),
                                            content: Container(
                                                width: double.infinity,
                                                alignment: Alignment.centerLeft,
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .error,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15),
                                                            topRight:
                                                                Radius.circular(
                                                                    15))),
                                                child: const Text(
                                                    'Please, Fill the Forms')),
                                            backgroundColor: Colors.transparent,
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      : sep2Ref,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1.5,
                                          color: const Color.fromRGBO(
                                              15, 40, 81, 1)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      "References",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Color.fromRGBO(15, 40, 81, 1)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                AddingVideoWidget(takeImage),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: [
                                    Column(
                                      children:
                                          fields.map((e) => e.child).toList(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton.icon(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    OutlinedBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20))),
                                            fixedSize:
                                                MaterialStateProperty.all<Size>(
                                                    Size(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20,
                                                        60))),
                                        onPressed: addFormField,
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "One more glossary",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
            );
          }),
    );
  }

  final keyForRef = GlobalKey<FormState>();
  final refController = TextEditingController();
  String? dropdownValue;

  void sep2Ref() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              content: SizedBox(
                  width: double.infinity,
                  child: Column(children: [
                    Text(
                      textController.text,
                      style: const TextStyle(fontSize: 14),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 20),
                    Form(
                        key: keyForRef,
                        child: TextFormField(
                          controller: refController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please, Fill the form ';
                            }
                            // if (!value.contains(".")) {
                            //   return 'Please, enter whole word';
                            // }
                            if (!textController.text.contains(value.trim())) {
                              return 'The text does not contain the sentence';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (val) {
                            if (!keyForRef.currentState!.validate()) {
                              return;
                            }
                            if (textController.text.contains(val)) {}
                          },
                          decoration: _inputDecoration('Write the sentence'),
                        )),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromRGBO(15, 40, 81, 1))),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('ref')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!.docs;
                              List<String> list = [];
                              for (int i = 0; i < data.length; i++) {
                                list.add(
                                  data[i]['ref'],
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
                                      color:
                                          const Color.fromRGBO(15, 40, 81, 1),
                                    ),
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                    items: list.map<DropdownMenuItem<String>>(
                                        (String value) {
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
                              child: const CircularProgressIndicator(
                                color: Color.fromRGBO(15, 40, 81, 1),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 20),
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
                        onPressed: isLoading1
                            ? null
                            : () {
                                _submit(
                                    refController.text, titleController.text);
                              },
                        child: isLoading1
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Submit',
                                style: TextStyle(fontSize: 25),
                              ),
                      ),
                    )
                  ])),
            );
          });
        });
  }

  bool isLoading1 = false;

  void _submit(String part, String section) async {
    text = textController.text;
    print(text);
    print(part);
    if (text!.contains(part)) {
      setState(() {
        isLoading1 = true;
      });
      setState(() {
        text = text!.replaceRange(text!.indexOf(part),
            text!.indexOf(part) + part.length, "\$$part\$");
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'omonovrahmatullo9@gmail.com', password: '123456');
      await FirebaseFirestore.instance
          .collection('refOne')
          .add({'ref': dropdownValue, 'part': part, 'section': section}).then(
              (value) async {
        Navigator.of(context).pop();
        await FirebaseAuth.instance.signOut();
      }).catchError((err) {
        SnackBar snackBar = SnackBar(
          content: Text('Something went wrong, try again$err'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      setState(() {
        isLoading1 = false;
      });
    } else {
      SnackBar snackBar = SnackBar(
        content: const Text('Your sentence does not match with text'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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

class TextContainer extends StatelessWidget {
  final Widget child;
  final int index;

  const TextContainer(this.child, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          key: GlobalKey(),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.delete,
              size: 40,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) {
            _AddingVideoState.fields
                .removeWhere((element) => element.id == index);
            _AddingVideoState.controllers
                .removeWhere(((element) => element.id == index));
            _AddingVideoState.controllersDef
                .removeWhere(((element) => element.id == index));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.amber),
                borderRadius: BorderRadius.circular(20)),
            child: child,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
