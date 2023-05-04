import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';

class AddingVideoWidget extends StatefulWidget {
  final Function takeVideo;
  const AddingVideoWidget(this.takeVideo, {super.key});

  @override
  State<AddingVideoWidget> createState() => _AddingVideoWidgetState();
}

class _AddingVideoWidgetState extends State<AddingVideoWidget> {
  File? _video;
  VideoPlayerController? videoPlayer;
  @override
  void dispose() {
    super.dispose();
    if (videoPlayer != null) {
      videoPlayer!.dispose();
    }
  }

  Future<void> _videoPicker() async {
    final ImagePicker picker = ImagePicker();
    final video = await picker.pickVideo(source: ImageSource.gallery);
    if (video == null) {
      return;
    }
    setState(() {
      _video = File(video.path);
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(video.path);
    final savedVideo = await _video!.copy('${appDir.path}/$fileName');
    videoPlayer = VideoPlayerController.file(File(_video!.path))
      ..addListener(() {
        setState(() {});
      })
      ..setLooping(false)
      ..initialize().then((value) => videoPlayer!.pause());
    widget.takeVideo(savedVideo, videoPlayer!.value.duration.inMinutes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.dependOnInheritedWidgetOfExactType();
  }

  @override
  Widget build(BuildContext context) {
    return _video == null
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(30)),
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: _videoPicker,
                child: const Text(
                  'Take video from gallery',
                  style: TextStyle(fontFamily: 'OpenSans-Bold', fontSize: 20),
                )),
          )
        : videoPlayer!.value.isInitialized
            ? Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 300,
                        child: Align(
                          alignment: Alignment.center,
                          child: AspectRatio(
                            aspectRatio: videoPlayer!.value.aspectRatio,
                            child: VideoPlayer(videoPlayer!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () async {
                            if (videoPlayer!.value.isPlaying) {
                              await videoPlayer!.pause();
                            } else {
                              await videoPlayer!.play();
                            }
                          },
                          icon: videoPlayer!.value.isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow),
                          label: videoPlayer!.value.isPlaying
                              ? const Text("Pause Video")
                              : const Text("Play video")),
                      TextButton.icon(
                          onPressed: () {
                            _videoPicker();
                          },
                          icon: const Icon(Icons.change_circle_outlined),
                          label: const Text("Change Video")),
                    ],
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
  }
}
