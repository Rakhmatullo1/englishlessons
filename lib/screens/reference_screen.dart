import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RefScreen extends StatefulWidget {
  static const routeName = "/ref-screen";
  const RefScreen({super.key});

  @override
  State<RefScreen> createState() => _RefScreenState();
}

class _RefScreenState extends State<RefScreen> {
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
              const SizedBox(height: 40),
              Text(
                'References',
                style: Theme.of(context).textTheme.displayLarge,
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
                          .collection('ref')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          return ListView.builder(
                              padding: const EdgeInsets.all(0),
                              itemCount: data.length,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        data[i]['ref'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(15, 40, 81, 1),
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 3),
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
                          height: MediaQuery.of(context).size.height - 150,
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
