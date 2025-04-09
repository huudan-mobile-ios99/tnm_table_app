import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xgame2d_table/game/layout/layouttable_page.dart';
import 'package:video_player/video_player.dart';

class GameTableWithBGPage extends StatefulWidget {

  const GameTableWithBGPage({Key? key}): super(key: key);
  @override
  State<GameTableWithBGPage> createState() => _GameTableBackgroundPageState();
}

class _GameTableBackgroundPageState extends State<GameTableWithBGPage> {

  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    debugPrint('GameBackgroundVideo: initstate');
    _controller = VideoPlayerController.asset('assets/bg.mp4')
      ..initialize().then((_) {
        _controller!.setLooping(true);
          _controller!.play();
        setState(() {

        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('GameBackgroundVideo:did change dependency');
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('GameBackgroundVideo: disposed');
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final double widthItem = width / 4;
    final double heightItem = height / 4;

    return Stack(
          children: [
            //background here
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width ?? width,
                  height: _controller!.value.size.height ?? height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),


      SizedBox(
      width: width, height:height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -MyString.padding16,
            child: SizedBox(
              width: width,
              height: height,
              child:const  DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/table3.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Screen Display
          Positioned(
            top: MyString.padding24,
            child: SizedBox(
              width: widthItem,
              height: heightItem,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/bg_round2.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Layout Baccarat
          const Align(
            alignment: Alignment.topLeft,
            child: LayoutTablePage(), // Ensure this doesn't contain a Scaffold
          ),
        ],
      ),
    )
          ],
        );
  }
}
