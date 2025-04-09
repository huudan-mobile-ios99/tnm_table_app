import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
// Only for web
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';

class JackpotDropBoxPage extends StatefulWidget {
  final double width;
  final double height;
  const JackpotDropBoxPage(
      {Key? key, required this.width, required this.height})
      : super(key: key);

  @override
  State<JackpotDropBoxPage> createState() => _JackpotDropBoxPageState();
}

class _JackpotDropBoxPageState extends State<JackpotDropBoxPage> {
  final controller = ConfettiController();
  // late final AudioPlayer _audioPlayer =  AudioPlayer();

  @override
  void dispose() {
    controller.stop();
    controller.dispose();
    // _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // Play effect
    controller.play();
    // playAudio();
    super.initState();
  }

  // Future<void> playAudio() async {
  //   try {
  //     // Load the audio from assets and play
  //     await _audioPlayer.setAsset('asset/sound.mp3');
  //     _audioPlayer.play();
  //   } catch (e) {
  //     print('Error playing audio: $e');
  //   }
  // }

  // Future<void> pauseAudio() async {
  //   _audioPlayer.pause();
  // }

  // Future<void> stopAudio() async {
  //   _audioPlayer.stop();
  // }



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(MyString.padding08),
      width: widget.width,
      height: widget.height,
      child:kIsWeb ?  ConfettiWidget(
        displayTarget: false,
        minBlastForce: 5.0,
        maxBlastForce: 15.0,
        gravity: 0.5,
        emissionFrequency: 0.065,
        pauseEmissionOnLowFrameRate: true,
        colors: [
          Colors.orangeAccent,
          Colors.yellow.shade100,
          Colors.yellowAccent,
          MyColor.yellowMain,
          MyColor.yellowMain2
        ],
        blastDirectionality: BlastDirectionality.explosive,
        confettiController: controller,
      ):const SizedBox(),
    );

  }
}
