import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishlessons/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LessonsScreenExtra extends StatefulWidget {
  static const routeName = '/lessons-screen-extra';
  final String? id;
  final String? url;
  const LessonsScreenExtra(this.id, this.url, {super.key});

  @override
  State<LessonsScreenExtra> createState() => _LessonsScreenExtraState();
}

class _LessonsScreenExtraState extends State<LessonsScreenExtra> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int duration(Duration position) {
    final hours = position.inHours * 3600;
    final minutes = position.inMinutes * 60;
    final seconds = position.inSeconds;
    return hours + minutes + seconds;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lessons').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.active) {
            final lessons = snapshot.data!.docs;
            final data = lessons.firstWhere(
              (element) => element.id == widget.id,
            );
            return Scaffold(
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        data['title'],
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 40),
                      VideoPlayerWidget(data['video_url']),
                      const SizedBox(height: 20),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('glossaries')
                              .snapshots(),
                          builder: (context, snapOne) {
                            if (snapOne.hasData) {
                              final glossaries = snapOne.data!.docs;
                              final List<GloData> gloData = [];
                              for (int i = 0; i < glossaries.length; i++) {
                                if (glossaries[i]['section'] == data['title']) {
                                  gloData.add(GloData(
                                      glossaries[i]['definition'],
                                      glossaries[i]['word']));
                                }
                              }

                              return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('refOne')
                                      .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      final references = snap.data!.docs;
                                      List<RefData> refData = [];
                                      for (int i = 0;
                                          i < references.length;
                                          i++) {
                                        if (references[i]['section'] ==
                                            data['title']) {
                                          refData.add(RefData(
                                              references[i]['part'],
                                              references[i]['ref']));
                                        }
                                      }

                                      return Container(

                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 20.0, left: 20, top: 20),
                                              child: Text(
                                                data['headerText'],
                                                textAlign: TextAlign.justify,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            MainOverview(
                                              data: data['text'],
                                              listData: gloData,
                                              refData: refData,
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  });
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class GloData {
  String word;
  String definition;
  GloData(this.definition, this.word);
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  const VideoPlayerWidget(this.url, {Key? key}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with TickerProviderStateMixin {
  static late VideoPlayerController videoPlayer;
  void playVideo() {
    videoPlayer = VideoPlayerController.network(widget.url)
      ..addListener(() {
        setState(() {});
      })
      ..setVolume(0.5)
      ..setLooping(false)
      ..initialize().then((value) => videoPlayer.pause());
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayer.dispose();
  }

  @override
  void initState() {
    super.initState();
    playVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: videoPlayer.value.hasError
          ? const SizedBox(
              height: 300,
              child: Center(
                child: Text(
                  'Something went wrong.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          : videoPlayer.value.isInitialized
              ? Center(
                  child: SizedBox(
                      width: videoPlayer.value.size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: AspectRatio(
                            aspectRatio: videoPlayer.value.aspectRatio,
                            child: Chewie(
                                controller: ChewieController(
                                    playbackSpeeds: [0.5, 1, 2],
                                    videoPlayerController: videoPlayer))),
                      )),
                )
              : const Column(
                  children: [
                    SizedBox(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(15, 40, 81, 1),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
