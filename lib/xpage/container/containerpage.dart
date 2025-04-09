import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:tournament_client/xpage/home/home_realtime.dart';
import 'package:tournament_client/xpage/admin/admin_verify.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xpage/home/home_topranking.dart';
import 'package:tournament_client/authentication/viewpage.dart';

class ContainerPage extends StatefulWidget {
  String url;
  int selectedIndex;

  ContainerPage({Key? key, required this.url, required this.selectedIndex})
      : super(key: key);
  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  VideoPlayerController? _controller;
  @override
  void initState() {
    super.initState();
    debugPrint('ContainerPage: initstate');
    _controller = VideoPlayerController.asset('asset/bg_video.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller!.setLooping(true);
          _controller!.play();
        });
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('ContainerPage: did change dependency');
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint('ContainerPage: disposed');
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          debugPrint('Back button pressed! Navigating to another screen...');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const AdminVerify(),
          ));
          return false;
        },
        child: Stack(
          children: [
            Container(width: width, height: height, color: MyColor.black_text),
            //loading background
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width / 2,
                  height: height,
                  child: 
                  ViewPage(
                          url: widget.url,
                          child: 
                          HomeTopRankingPage(
                          title: MyString.APP_NAME,
                          url: widget.url,
                          selectedIndex: MyString.DEFAULTNUMBER),
                  )
                  
                ),
                SizedBox(
                  width: width / 2,
                  height: height,
                  child: HomeRealTimePage(
                    url: widget.url,
                    selectedIndex: widget.selectedIndex,
                    title: MyString.APP_NAME,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
