import 'package:englishlessons/screens/adding_pptx.dart';
import 'package:englishlessons/screens/adding_reference.dart';
import 'package:englishlessons/screens/adding_test_screen.dart';
import 'package:englishlessons/screens/adding_video_screen.dart';
import 'package:flutter/material.dart';

class EditingScreen extends StatelessWidget {
  static const routeName = "/editing-screen";
  const EditingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color? color = const Color.fromRGBO(15, 40, 81, 1);
    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: color),
                      borderRadius: BorderRadius.circular(35)),
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35)))),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddingReference.routeName);
                      },
                      child: Text(
                        "Add References",
                        style: TextStyle(fontSize: 25, color: color),
                      )),
                ),
                
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: color),
                      borderRadius: BorderRadius.circular(35)),
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35)))),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddingTestScreen.routeName);
                      },
                      child: Text(
                        "Add tests",
                        style: TextStyle(fontSize: 25, color: color),
                      )),
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: color),
                      borderRadius: BorderRadius.circular(35)),
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35)))),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddingVideo.routeName);
                      },
                      child: Text(
                        "Add videos",
                        style: TextStyle(fontSize: 25, color: color),
                      )),
                ),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: color),
                      borderRadius: BorderRadius.circular(35)),
                  child: TextButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35)))),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddingPPTX.routeName);
                      },
                      child: Text(
                        "Add Presentations",
                        style: TextStyle(fontSize: 25, color: color),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
