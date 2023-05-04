import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishlessons/screens/lessons_screen_extra.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonsScreen extends StatefulWidget {
  static const routeName = '/lessons-screen';
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class Details {
  String id;
  String url;
  Details(this.id, this.url);
}

class _LessonsScreenState extends State<LessonsScreen> {
  String? id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('lessons')
            .orderBy('createdAt')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            final data = snapshot.data!.docs;
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text('Course Content',
                          style: Theme.of(context).textTheme.displayLarge),
                      const SizedBox(height: 40),
                      Text(
                        'All Videos',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: data.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      LessonsScreenExtra.routeName,
                                      arguments: Details(
                                          data[i].id, data[i]['video_url']));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(10),
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          208, 209, 255, 1),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 15),
                                            blurRadius: 40,
                                            color: Colors.grey.shade200)
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data[i]['title'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(15, 40, 81, 1),
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 40),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Created by: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                              Text(
                                                'Created at: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              ),
                                              Text(
                                                'Duration: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall,
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[i]['Editor'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Text(
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        data[i]['createdAt'])),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Text(
                                                data[i]['duration'] + " min",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
