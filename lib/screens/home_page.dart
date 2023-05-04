import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishlessons/screens/reference_screen.dart';
import 'package:englishlessons/screens/slides.dart';
import 'package:englishlessons/screens/author_screen.dart';
import 'package:englishlessons/screens/editing_screen.dart';
import 'package:englishlessons/screens/glossaries.dart';
import 'package:englishlessons/screens/lessons_screen.dart';
import 'package:englishlessons/screens/lessons_screen_extra.dart';
import 'package:englishlessons/screens/test_screen_extra.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final key = GlobalKey<FormState>();
  final controller = TextEditingController();
  bool isLoading = false;
  bool isNotVisible = !false;
  DateTime time = DateTime.now();
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (time.isAfter(
                          DateTime(time.year, time.month, time.day, 12, 00)) &&
                      time.isBefore(
                          DateTime(time.year, time.month, time.day, 18, 00)))
                    Text('Good Afternoon!',
                        style: Theme.of(context).textTheme.displayLarge),
                  if (time.isAfter(
                          DateTime(time.year, time.month, time.day, 6, 00)) &&
                      time.isBefore(
                          DateTime(time.year, time.month, time.day, 12, 00)))
                    Text('Good Morning!',
                        style: Theme.of(context).textTheme.displayLarge),
                  if ((time.isAfter(DateTime(
                              time.year, time.month, time.day, 18, 00)) &&
                          time.isBefore(DateTime(
                              time.year, time.month, time.day, 23, 59))) ||
                      (time.isAfter(DateTime(
                              time.year, time.month, time.day, 0, 00)) &&
                          time.isBefore(DateTime(
                              time.year, time.month, time.day, 6, 00))))
                    Text('Good Evening!',
                        style: Theme.of(context).textTheme.displayLarge),
                  InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: ((context, setState) {
                              return AlertDialog(
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Enter the password to get an access to admin panel",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(15, 40, 81, 1),
                                            fontSize: 15),
                                      ),
                                      const SizedBox(height: 20),
                                      Form(
                                          key: key,
                                          child: TextFormField(
                                            validator: (value) {
                                              if (value != "macBook") {
                                                return "You entered wrong password";
                                              }
                                              return null;
                                            },
                                            obscureText: isNotVisible,
                                            textCapitalization:
                                                TextCapitalization.sentences,
                                            cursorColor: const Color.fromRGBO(
                                                15, 40, 81, 1),
                                            controller: controller,
                                            decoration: InputDecoration(
                                                suffix: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      isNotVisible =
                                                          !isNotVisible;
                                                    });
                                                  },
                                                  child: isNotVisible
                                                      ? const Icon(
                                                          Icons.visibility_off)
                                                      : const Icon(
                                                          Icons.visibility),
                                                ),
                                                border: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            15, 40, 81, 1),
                                                        width: 1),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20))),
                                                focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            15, 40, 81, 1),
                                                        width: 1),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20))),
                                                labelStyle: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        15, 40, 81, 1)),
                                                labelText: 'Password'),
                                          )),
                                      const SizedBox(height: 20),
                                      Container(
                                        width: double.infinity,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: 130,
                                          height: 50,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromRGBO(
                                                            15, 40, 81, 1)),
                                                shape: MaterialStateProperty.all<
                                                        OutlinedBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)))),
                                            child: const Text('Submit'),
                                            onPressed: () {
                                              if (!key.currentState!
                                                  .validate()) {
                                                return;
                                              } else {
                                                key.currentState!.reset();
                                                Navigator.of(context).pushNamed(
                                                    EditingScreen.routeName);
                                              }
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }));
                          });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 15),
                                blurRadius: 40,
                                color: Color.fromRGBO(237, 238, 251, 1))
                          ],
                          color: Colors.white),
                      child: Icon(Icons.settings, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.center,
                      height: 20,
                      child: Text('Courses',
                          style: Theme.of(context).textTheme.titleSmall)),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      Navigator.of(context).pushNamed(LessonsScreen.routeName);
                    },
                    child: Container(
                        height: 20,
                        width: 60,
                        alignment: Alignment.center,
                        child: Text('More...',
                            style: Theme.of(context).textTheme.headlineSmall)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('lessons')
                          .orderBy('createdAt')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Container(
                            height: 110,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(237, 238, 251, 1),
                                      offset: Offset(0, 15),
                                      blurRadius: 40)
                                ]),
                            child: const Center(
                              child: Text("Oops, Something Went Wrong!"),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 110,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(237, 238, 251, 1),
                                      offset: Offset(0, 15),
                                      blurRadius: 40)
                                ]),
                            child: const Center(
                              child: Text("Loading..."),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          final data = snapshot.data!.docs;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            addAutomaticKeepAlives: false,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      LessonsScreenExtra.routeName,
                                      arguments: Details(data[index].id,
                                          data[index]['video_url']));
                                },
                                child: Container(
                                  height: 110,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          201, 235, 237, 1),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                237, 238, 251, 1),
                                            offset: Offset(0, 15),
                                            blurRadius: 40)
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data[index]['title'],
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              data[index]['duration']! == null
                                                  ? '22'
                                                  : data[index]['duration'] +
                                                      "min",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2)),
                                          child: const Icon(
                                            Icons.play_arrow,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: data.length > 4 ? 4 : data.length,
                          );
                        }
                        return Container(
                          height: 110,
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
                      })),
              const SizedBox(height: 20),
              Text('Practices', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('lessons')
                      .orderBy("createdAt")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.docs;
                      List<String> images = [
                        'assets/images/undraw_online_test_re_kyfx.svg',
                        'assets/images/undraw_engineering_team_a7n2.svg',
                        'assets/images/undraw_mobile_analytics_72sr.svg'
                      ];
                      int j = data.length;
                      return CarouselSlider(
                          options: CarouselOptions(
                            aspectRatio: 1.80,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                          ),
                          items: data.map((e) {
                            j--;
                            return CarouselSliderItem(
                                svgPath: images[j % 3], testType: e['title']);
                          }).toList());
                    }
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                            alignment: const Alignment(0, 0),
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(238, 193, 193, 1),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 15),
                                      blurRadius: 40,
                                      color: Color.fromRGBO(237, 238, 251, 1))
                                ]),
                            child: const Text('No Data')));
                  }),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 7,
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Slides',
                                style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(SlidesScreen.routeName);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 120,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 15),
                                          blurRadius: 40,
                                          color: Colors.grey.shade300)
                                    ],
                                    color:
                                        const Color.fromRGBO(208, 209, 255, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: SvgPicture.asset(
                                    'assets/images/undraw_presentation_re_sxof.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Glossaries',
                                style: Theme.of(context).textTheme.titleSmall),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(GlossariesScreen.routeName);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 120,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 15),
                                          blurRadius: 40,
                                          color: Colors.grey.shade300)
                                    ],
                                    color:
                                        const Color.fromRGBO(208, 209, 255, 1),
                                    borderRadius: BorderRadius.circular(15)),
                                child: SvgPicture.asset(
                                    'assets/images/undraw_articles_wbpb.svg'),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Author', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 20),
              Container(
                height: 150,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 15),
                          blurRadius: 40,
                          color: Colors.grey.shade200)
                    ]),
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Name: Guli Ergasheva Ismailovna',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 5),
                            // Text('Position: PHD',
                            //     style:
                            //         Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 5),
                            Text(
                              'University: UzSWLU',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            TextButton.icon(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      const EdgeInsets.symmetric(
                                          horizontal: 0)),
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AuthorScreen.routeNAame);
                              },
                              label: Text(
                                'read more...',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Color.fromRGBO(208, 209, 255, 1),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(width: 10),
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 60,
                          child: SvgPicture.asset(
                              'assets/images/undraw_female_avatar_efig.svg'),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('References', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 20),
              Container(
                height: 150,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 15),
                          blurRadius: 40,
                          color: Colors.grey.shade200)
                    ]),
                child: Stack(
                  children: [
                    Align(
                      alignment: const Alignment(1, 0),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(238, 193, 193, 1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(40),
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(40))),
                        height: 150,
                        width: 150,
                        child: SvgPicture.asset(
                            'assets/images/undraw_personal_file_re_5joy.svg'),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(-1, 0),
                      child: TextButton.icon(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                const Color.fromRGBO(245, 222, 222, 1)),
                            iconColor: MaterialStateProperty.all(
                                const Color.fromRGBO(238, 193, 193, 1))),
                        onPressed: () {
                          Navigator.of(context).pushNamed(RefScreen.routeName);
                        },
                        icon: const Icon(Icons.arrow_forward_ios),
                        label: const Text('Read All',
                            style: TextStyle(
                                color: Color.fromRGBO(238, 193, 193, 1))),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class CarouselSliderItem extends StatelessWidget {
  final String svgPath;
  final String? testType;

  const CarouselSliderItem(
      {required this.svgPath, required this.testType, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        width: MediaQuery.of(context).size.width,
        height: 120,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(238, 193, 193, 1),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 15),
                  blurRadius: 40,
                  color: Color.fromRGBO(237, 238, 251, 1))
            ]),
        child: Stack(children: [
          SvgPicture.asset(svgPath),
          Align(
            alignment: const Alignment(-0.6, -0.8),
            child: Container(
              alignment: const Alignment(-0.7, 0),
              height: 40,
              decoration: const BoxDecoration(color: Colors.black54),
              width: double.infinity,
              child: Text(
                testType!,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
              alignment: const Alignment(0.6, 0.8),
              child: Container(
                height: 40,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromRGBO(161, 163, 246, 1)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)))),
                  onPressed: () async {
                    int score = 0;
                    try {
                      final prefs = await SharedPreferences.getInstance();
                      final List<String>? scoreOne;
                      if (prefs.containsKey(testType!)) {
                        scoreOne = prefs.getStringList(testType!);

                        score += int.parse(scoreOne!.first);
                      }
                    } finally {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: 120,
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("test")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final data = snapshot.data!.docs;
                                        List<QueryDocumentSnapshot<Object?>>
                                            test = [];

                                        test.addAll(data.where((element) =>
                                            element['section'] == testType));
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                                "All Tests are based on Courses",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color.fromRGBO(
                                                        15, 40, 81, 1))),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text("Your result: ",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            15, 40, 81, 1))),
                                                Text(
                                                  test.isEmpty
                                                      ? "-/-"
                                                      : "$score/${test.length} ",
                                                  style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          15, 40, 81, 1)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              width: double.infinity,
                                              alignment: const Alignment(1, 0),
                                              child: InkWell(
                                                overlayColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromRGBO(
                                                            208, 209, 255, 1)),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                onTap: test.isEmpty
                                                    ? () {
                                                        SnackBar snackBar =
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Tests are not added yet'));
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                snackBar);
                                                      }
                                                    : () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                TestscreenExtra
                                                                    .routeName,
                                                                arguments:
                                                                    testType);
                                                      },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height: 40,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1.5,
                                                        color: const Color
                                                                .fromRGBO(
                                                            15, 40, 81, 1)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: const Text(
                                                    " Start ",
                                                    style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            15, 40, 81, 1)),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                              "All Tests are based on Courses",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                      15, 40, 81, 1))),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Your result: ",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          15, 40, 81, 1))),
                                              Text(
                                                "-/-",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        15, 40, 81, 1)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            alignment: const Alignment(1, 0),
                                            child: InkWell(
                                              onTap: null,
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      const Color.fromRGBO(
                                                          208, 209, 255, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color:
                                                          const Color.fromRGBO(
                                                              15, 40, 81, 1)),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  " Start ",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          15, 40, 81, 1)),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    }),
                              ),
                            );
                          });
                    }
                  },
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
