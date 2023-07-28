import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GlossariesScreen extends StatefulWidget {
  static const routeName = '/glossaries-screen';
  const GlossariesScreen({super.key});

  @override
  State<GlossariesScreen> createState() => _GlossariesScreenState();
}

class _GlossariesScreenState extends State<GlossariesScreen> {
  void tappingButton(String def) {
    showDialog(
      
        context: context,
        builder: ((context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            content: SizedBox(
              child: SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      
                      Text(def),
                    ],
                  ))),
            ),
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('glossaries')
            .orderBy('word')
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal :20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Expanded(
                      flex: 1,
                      child: Text('Glossaries',
                          style: Theme.of(context).textTheme.displayLarge)),
                  Expanded(
                    flex: 9,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: () {
                                tappingButton(data[index]['definition']);
                              },
                              // overlayColor: MaterialStateProperty.all(Colors.amber),
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade300),
                                ),
                                child: Text(
                                  '${data[index]['word'][0].toUpperCase()}${data[index]['word'].substring(1)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            );
          }
          if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );}
          return const Center(child: Text('No Data'));
        }),
      ),
    );
  }
}
