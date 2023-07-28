import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestscreenExtra extends StatefulWidget {
  static const routeName = '/test-screen-extra';
  const TestscreenExtra({super.key});

  @override
  State<TestscreenExtra> createState() => _TestscreenExtraState();
}

class Question {
  final String name;
  final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question(
      {required this.name,
      required this.options,
      this.selectedOption,
      this.isLocked = false});
}

class Option {
  String text;
  bool isCorrect;

  Option(this.isCorrect, this.text);
}

class _TestscreenExtraState extends State<TestscreenExtra> {
  String? testType;
  List<String> corrects = [];
  List<String> wrongs = [];
  Map<int, dynamic> results = {};
  int count = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    testType = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('test').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final initialData = snapshot.data!.docs;
            List<QueryDocumentSnapshot<Object?>> data = [];
            data.addAll(
                initialData.where((element) => element['section'] == testType));

            List<Question> questions = [];

            for (int i = 0; i < data.length; i++) {
              questions.add(Question(
                name: data[i]['question'],
                options: [
                  Option(data[i]['answerOne'] == data[i]['correctAnswer'],
                      data[i]['answerOne']),
                  Option(data[i]['answerTwo'] == data[i]['correctAnswer'],
                      data[i]['answerTwo']),
                  Option(data[i]['answerThree'] == data[i]['correctAnswer'],
                      data[i]['answerThree']),
                  Option(data[i]['answerFour'] == data[i]['correctAnswer'],
                      data[i]['answerFour'])
                ],
              ));
            }

            return QuestionWidget(
              questions: questions,
              testType: testType!,
            );
          } else {
            return const Text("Loading");
          }
        },
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final List<Question> questions;
  final String testType;

  const QuestionWidget(
      {required this.questions, required this.testType, super.key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  int _questionNumber = 1;
  PageController? controller;
  int scoreNumber = 0;
  bool isLocked = false;
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            height: 32,
          ),
          Text(
            'Question $_questionNumber/${widget.questions.length}',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Expanded(
              child: PageView.builder(
                  controller: controller,
                  itemCount: widget.questions.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    Question question = widget.questions[i];
                    return buildQuestion(question);
                  })),
          isLocked ? buildElevatedButton() : const SizedBox.shrink(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Container buildElevatedButton() {
    return Container(
      width: double.infinity,
      alignment: const Alignment(1, 0),
      child: InkWell(
        overlayColor:
            MaterialStateProperty.all(const Color.fromRGBO(208, 209, 255, 1)),
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          if (_questionNumber < widget.questions.length) {
            controller!.nextPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeIn);

            setState(() {
              _questionNumber++;
              isLocked = false;
            });
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return ResultPage(
                score: scoreNumber,
                length: widget.questions.length,
                testType: widget.testType,
              );
            }));
          }
        },
        child: Container(
            alignment: Alignment.center,
            height: 40,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.5, color: const Color.fromRGBO(15, 40, 81, 1)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _questionNumber < widget.questions.length
                  ? 'Next Page '
                  : 'See the result',
              style: const TextStyle(color: Color.fromRGBO(15, 40, 81, 1)),
            )),
      ),
    );
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(question.name,
            style: const TextStyle(
                fontSize: 25, color: Color.fromRGBO(15, 40, 81, 1))),
        const SizedBox(height: 32),
        Expanded(
            child: OptionsWidget(question, (option) {
          if (question.isLocked) {
            return;
          } else {
            setState(() {
              question.isLocked = true;
              question.selectedOption = option;
            });
            isLocked = question.isLocked;

            if (question.selectedOption!.isCorrect) {
              scoreNumber++;
            }
          }
        }))
      ],
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;
  const OptionsWidget(this.question, this.onClickedOption, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: question.options
            .map((option) => buildOption(context, option))
            .toList(),
      ),
    );
  }

  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: Text(
                option.text,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromRGBO(15, 40, 81, 1)),
              ),
            ),
            Expanded(child: getIconFroOption(option, question))
          ],
        ),
      ),
    );
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }
    return Colors.grey.shade300;
  }

  Widget getIconFroOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(
                Icons.check_circle,
                color: Colors.red,
              );
      } else if (option.isCorrect) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
        );
      }
    }
    return const SizedBox.shrink();
  }
}

class ResultPage extends StatelessWidget {
  final String testType;
  final int length;

  const ResultPage(
      {required this.score,
      required this.length,
      required this.testType,
      super.key});

  final int score;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(201, 235, 237, 1),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Stack(
          children: [
            SvgPicture.asset('assets/images/undraw_projections_re_ulc6.svg'),
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      color: Colors.black54,
                      alignment: Alignment.center,
                      child: Text(
                        "You got $score/$length",
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(right: 10),
                  alignment: const Alignment(1, 0),
                  child: InkWell(
                    overlayColor: MaterialStateProperty.all(
                        const Color.fromRGBO(208, 209, 255, 1)),
                    borderRadius: BorderRadius.circular(20),
                    onTap: () async {
                      try {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setStringList(testType, ["$score"]);
                      } finally {
                        Navigator.of(context).pushNamed('/');
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1.5,
                              color: const Color.fromRGBO(15, 40, 81, 1)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Back To Main Menu',
                          style:
                              TextStyle(color: Color.fromRGBO(15, 40, 81, 1)),
                        )),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
