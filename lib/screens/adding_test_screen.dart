import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddingTestScreen extends StatefulWidget {
  static const routeName = '/adding-tests';
  const AddingTestScreen({super.key});

  @override
  State<AddingTestScreen> createState() => _AddingTestScreenState();
}

class FieldsClassOne {
  Widget child;
  int id;
  String correctOne;
  FieldsClassOne(this.child, this.id, this.correctOne);
}

class ControllerClass {
  TextEditingController child;
  int id;
  bool correct = false;
  ControllerClass(this.child, this.id);
}

class _AddingTestScreenState extends State<AddingTestScreen>
    with TickerProviderStateMixin {
  static List<ControllerClass> controllers = [];
  static List<ControllerClass> controllersOne = [];
  bool enable = fieldsone.isEmpty;
  double height = 0;

  bool secondView = false;
  static List<FieldsClassOne> fieldsone = [];

  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    fieldsone = [];
    controllers = [];
    controllersOne = [];
  }

  bool isLoading = false;
  Future<void> saveFieldForm(String? dropdownValue) async {
    bool messOne = false;

    for (int i = 0; i < fieldsone.length; i++) {
      if (fieldsone[i].correctOne.isEmpty) {
        setState(() {
          messOne = true;
        });
      }
    }

    if (messOne) {
      SnackBar snackBar = SnackBar(
        content: const Text('Please, choose correct answers'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    if (!messOne) {
      setState(() {
        isLoading = true;
      });

      try {
        for (int i = 0; i < fieldsone.length; i++) {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: 'omonovrahmatullo9@gmail.com', password: '123456')
              .then((value) async {
            await FirebaseFirestore.instance.collection('test').add({
              'question': controllers[i].child.text.trim(),
              'answerOne': controllersOne[4 * i + 0].child.text.trim(),
              'answerTwo': controllersOne[4 * i + 1].child.text.trim(),
              'answerThree': controllersOne[4 * i + 2].child.text.trim(),
              'answerFour': controllersOne[4 * i + 3].child.text.trim(),
              'correctAnswer': fieldsone[i].correctOne.trim(),
              'section': dropdownValue,
            });
          });
        }
      } catch (error) {
        SnackBar snackBar = SnackBar(
          content: Text('Something went wrong, try again $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
      ;
    }
  }

  void addFormField() async {
    setState(() {
      height = height + 320;
      enable = false;
      controllers
          .add(ControllerClass(TextEditingController(), controllers.length));
      for (int i = 0; i < 4; i++) {
        controllersOne.add(
            ControllerClass(TextEditingController(), controllersOne.length));
      }
      int index = controllersOne.length - 1;

      fieldsone.add(FieldsClassOne(
          TestsContainer(
            index: fieldsone.length,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      child: TextFormField(
                    controller: controllers.last.child,
                    decoration: const InputDecoration(label: Text("Question")),
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnswerWidget(
                        'Answer 1',
                        controllersOne[index - 3].child,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AnswerWidget(
                        'Answer 2',
                        controllersOne[index - 2].child,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnswerWidget(
                        'Answer 3',
                        controllersOne[index - 1].child,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AnswerWidget(
                        'Answer 4',
                        controllersOne.last.child,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          fieldsone.length,
          ''));
    });
  }

  bool mess = false;

  void takeState(Widget? temp, index) {
    if (temp == null) {
      setState(() {
        fieldsone[index].child = temp!;
      });
    }
  }

  void chooseCorrectOne(String ans, int i, int j) {
    setState(() {
      fieldsone[i].correctOne = ans;
    });
    setState(() {
      fieldsone[i].child = TestsContainer(
          index: i,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AutoSizeText(
                  controllers[i].child.text,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                for (int j = 0; j < 4; j++)
                  Column(
                    children: [
                      Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                width: 1,
                                color: fieldsone[i].correctOne ==
                                        controllersOne[4 * i + j].child.text
                                    ? Colors.green.shade400
                                    : Colors.grey.shade300,
                              )),
                          child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  fieldsone[i].correctOne ==
                                          controllersOne[4 * i + j].child.text
                                      ? Colors.green.shade100
                                      : Colors.amber.shade100),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            child: Text(
                              controllersOne[4 * i + j].child.text,
                              style: TextStyle(
                                  color: fieldsone[i].correctOne ==
                                          controllersOne[4 * i + j].child.text
                                      ? Colors.green.shade400
                                      : Colors.amber),
                            ),
                            onPressed: () {
                              chooseCorrectOne(
                                  controllersOne[4 * i + j].child.text, i, j);
                            },
                          )),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
              ],
            ),
          ));
    });
  }

  void transformView() {
    for (int i = 0; i < fieldsone.length; i++) {
      if (controllers[i].child.text.isEmpty) {
        setState(() {
          mess = true;
        });
      }
    }
    if (mess) {
      SnackBar snackBar = SnackBar(
        content: const Text('Fields are not filled completely'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if (!mess) {
      setState(() {
        secondView = true;
        enable = !enable;
      });

      for (int i = 0; i < fieldsone.length; i++) {
        setState(() {
          fieldsone[i].child = TestsContainer(
              index: i,
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: AutoSizeText(
                      controllers[i].child.text,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (int j = 0; j < 4; j++)
                    Column(
                      children: [
                        Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 1,
                                  color: fieldsone[i].correctOne ==
                                          controllersOne[4 * i + j].child.text
                                      ? Colors.green.shade400
                                      : Colors.grey.shade300,
                                )),
                            child: TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    fieldsone[i].correctOne ==
                                            controllersOne[4 * i + j].child.text
                                        ? Colors.green.shade100
                                        : Colors.amber.shade100),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                              ),
                              child: AutoSizeText(
                                controllersOne[4 * i + j].child.text,
                                style: TextStyle(
                                    color: fieldsone[i].correctOne ==
                                            controllersOne[4 * i + j].child.text
                                        ? Colors.green.shade400
                                        : Colors.amber),
                              ),
                              onPressed: () {
                                chooseCorrectOne(
                                    controllersOne[4 * i + j].child.text, i, j);
                              },
                            )),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                ],
              ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            appBar: AppBar(actions: [
              if (secondView)
                IconButton(
                    onPressed: () {
                      saveFieldForm(dropdownValue);
                    },
                    icon: const Icon(Icons.upload)),
              IconButton(
                  onPressed: enable ? null : transformView,
                  icon: const Icon(Icons.done)),
            ], title: const Text('Adding Tests')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 15, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('lessons')
                              // .orderBy("createdAt")
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
                                return DropdownButton<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.amber),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.amber,
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
                                );
                              });
                            }
                            return Container(
                              color: Colors.white,
                              height: 40,
                              child: const Text('Not Lessons'),
                            );
                          }),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: height,
                          curve: Curves.easeIn,
                          child: ListView(
                              children: secondView
                                  ? fieldsone.map((e) => e.child).toList()
                                  : fieldsone.map((e) => e.child).toList())),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber),
                              fixedSize: MaterialStateProperty.all<Size>(
                                  const Size(double.infinity, 250)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ))),
                          onPressed: addFormField,
                          label: const Text(
                            "One more test",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class TestsContainer extends StatelessWidget {
  final Widget child;
  final int index;
  const TestsContainer({required this.child, required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).colorScheme.error),
          ),
          key: GlobalKey(debugLabel: '$index'),
          onDismissed: (_) {
            _AddingTestScreenState.fieldsone
                .removeWhere((element) => element.id == index);
            _AddingTestScreenState.controllers
                .removeWhere(((element) => element.id == index));
            for (int i = 0; i < 4; i++) {
              _AddingTestScreenState.controllersOne
                  .removeWhere(((element) => element.id == 4 * index + i));
            }
          },
          child: Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.amber),
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: child,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class AnswerWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const AnswerWidget(this.text, this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            label: Text(text)),
        controller: controller,
      ),
    );
  }
}
