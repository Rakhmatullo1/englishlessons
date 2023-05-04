import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishlessons/screens/pdf_viewer.dart';
import 'package:flutter/material.dart';

class SlidesScreen extends StatefulWidget {
  static String routeName = "/slides-screen";
  const SlidesScreen({super.key});

  @override
  State<SlidesScreen> createState() => _SlidesScreenState();
}

class _SlidesScreenState extends State<SlidesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Presentations',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/');
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromRGBO(161, 163, 246, 1)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)))),
                        child: const Text('Home'),
                      ))
                ],
              ),
              const SizedBox(height: 40),
              Container(
                height: MediaQuery.of(context).size.height - 150,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 40,
                          offset: const Offset(0, 15))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('presentations')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: data.length,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        data[i]['section'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(15, 40, 81, 1),
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 3),
                                      TextButton.icon(
                                          icon: const Icon(
                                              Icons.picture_as_pdf_sharp),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      OutlinedBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10))),
                                              overlayColor: MaterialStateProperty.all(
                                                  const Color.fromRGBO(
                                                      208, 209, 255, 1)),
                                              foregroundColor: MaterialStateProperty.all(
                                                  const Color.fromRGBO(15, 40, 81, 1)),
                                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(0))),
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                PDFViewer.routeName,
                                                arguments: {
                                                  'name': data[i]['title'],
                                                  'url': data[i]['url']
                                                });
                                          },
                                          label: Text(
                                            data[i]['title'],
                                            style: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline),
                                          )),
                                      Divider(
                                        color: Colors.grey.shade300,
                                        thickness: 1,
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Color.fromRGBO(15, 40, 81, 1)),
                          );
                        }
                        return Container(
                          height:  MediaQuery.of(context).size.height - 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(237, 238, 251, 1),
                                    offset: Offset(0, 15),
                                    blurRadius: 40)
                              ]),
                          child: const Center(
                            child: Text("No Data"),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
