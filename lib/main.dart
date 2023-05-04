import 'package:englishlessons/providers/dictionary.dart';
import 'package:englishlessons/screens/adding_reference.dart';
import 'package:englishlessons/screens/pdf_viewer.dart';
import 'package:englishlessons/screens/reference_screen.dart';
import 'package:englishlessons/screens/slides.dart';
import 'package:englishlessons/screens/adding_pptx.dart';
import 'package:englishlessons/screens/adding_test_screen.dart';
import 'package:englishlessons/screens/adding_video_screen.dart';
import 'package:englishlessons/screens/author_screen.dart';
import 'package:englishlessons/screens/editing_screen.dart';
import 'package:englishlessons/screens/glossaries.dart';
import 'package:englishlessons/screens/lessons_screen.dart';
import 'package:englishlessons/screens/lessons_screen_extra.dart';
import 'package:englishlessons/screens/test_screen_extra.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import './screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              home: Scaffold(
                  body: Center(
            child:
                CircularProgressIndicator(color: Color.fromRGBO(15, 40, 81, 1)),
          )));
        }
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => DictionaryProvider(),
            ),
          ],
          child: MaterialApp(
            title: 'English Lessons',
            theme: ThemeData(
                fontFamily: 'Montserrat',
                textTheme: TextTheme(
                    bodySmall: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    labelSmall:
                        TextStyle(color: Colors.grey.shade100, fontSize: 12),
                    headlineSmall: const TextStyle(
                        color: Color.fromRGBO(15, 40, 81, 1),
                        fontSize: 12,
                        decoration: TextDecoration.underline),
                    titleSmall: const TextStyle(
                        color: Color.fromRGBO(15, 40, 81, 1), fontSize: 14),
                    displayLarge: const TextStyle(
                        color: Color.fromRGBO(15, 40, 81, 1),
                        fontSize: 30,
                        decoration: TextDecoration.underline))),
            home: const HomePage(),
            routes: {
              AddingVideo.routeName: (context) => const AddingVideo(),
              LessonsScreen.routeName: (context) => const LessonsScreen(),
              LessonsScreenExtra.routeName: (context) {
                final data =
                    ModalRoute.of(context)!.settings.arguments as Details;
                return LessonsScreenExtra(data.id, data.url);
              },
              AuthorScreen.routeNAame: ((context) => const AuthorScreen()),
              GlossariesScreen.routeName: (context) => const GlossariesScreen(),
              AddingTestScreen.routeName: (context) => const AddingTestScreen(),
              TestscreenExtra.routeName: (context) => const TestscreenExtra(),
              EditingScreen.routeName: (context) => const EditingScreen(),
              AddingPPTX.routeName: (context) => const AddingPPTX(),
              SlidesScreen.routeName: (context) => const SlidesScreen(),
              PDFViewer.routeName: (context) => const PDFViewer(),
              AddingReference.routeName: (context) => const AddingReference(),
              RefScreen.routeName: (context) => const RefScreen(),
            },
          ),
        );
      },
    );
  }
}
