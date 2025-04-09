import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xgame/bottom/size.config.dart';
import 'package:tournament_client/xgame/bottom/widget/image.box.dart';
import 'package:video_player/video_player.dart';

class DelayedJpDropBox extends StatefulWidget {
  final String dropValue;
  final int machineNumber;
  final String  jpNameSpace;
  final bool isDrop;
  final String jpName;
  final int lastestValue;
  final double width;
  final double height;
  final String asset;
  final String title;
  final double borderRadius;
  final double textSize;
  final Duration delay; // New: Delay duration

  const DelayedJpDropBox({
    required this.dropValue,
    required this.jpNameSpace,
    required this.machineNumber,
    required this.borderRadius,
    required this.isDrop,
    required this.jpName,
    required this.width,
    required this.lastestValue,
    required this.height,
    required this.asset,
    required this.title,
    required this.textSize,
    required this.delay, // New: Delay duration
    Key? key,
  }) : super(key: key);

  @override
  _DelayedJpDropBoxState createState() => _DelayedJpDropBoxState();
}

class _DelayedJpDropBoxState extends State<DelayedJpDropBox> {
  bool showBox = false;
  late VideoPlayerController _controller;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        setState(() {
          showBox = true;
        });
      }
    });
    // Load video from assets
    _controller = VideoPlayerController.asset('asset/effect3.mp4')
      ..setLooping(true) // Loop the video
      ..setVolume(0.0)
      ..initialize().then((_) {
        // Play video after initialization
        _controller.play();
        setState(() {}); // Refresh to display video
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final double fulW = MediaQuery.of(context).size.width;
    final double effectWidth = SizeConfig.controlVerSub *fulW ;

    if (!showBox) {
      return
      imageBoxTitleWidget(
                width: SizeConfig.jackpotWithItem,
                height: widget.height * SizeConfig.jackpotHeightRation,
                asset: "asset/eclip.png",
                title: widget.jpNameSpace,
                sizeTitle: MyString.padding24,
                widget: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "\$", // Add the "$" symbol as a separate Text widget
                      style: TextStyle(
                        fontSize: MyString.padding46,
                        color: MyColor.yellow_bg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: MyString.padding08,
                    ),
                     Text(
                      "${widget.lastestValue}", // Add the "$" symbol as a separate Text widget
                      style: const TextStyle(
                        fontSize: MyString.padding46,
                        color: MyColor.yellow_bg,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
    }
    return Row(
      children: [
        // Center(
        //        child: JackpotDropBoxPage(
        //         width: effectWidth,
        //         height: widget.height * SizeConfig.jackpotHeightRation,
        //      ),),

        Stack(
          alignment: Alignment.center,
          children: [
            _controller.value.isInitialized ?

             Opacity(
              opacity: 0.85,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(MyString.padding16), // Rounded corners
                child: SizedBox(
                width: SizeConfig.jackpotWithItem * 2.5,
                height: widget.height ,
                  child: Transform.scale(
                    scale: 2.5,
                    child: VideoPlayer(
                      _controller
                    ),
                  ),
                ),
              ),
            ) : Container(),
            DelayedJpDropBoxBody(
              dropValue: widget.dropValue,
              machineNumber: widget.machineNumber,
              isDrop: widget.isDrop,
              jpName: widget.jpName,
              width: widget.width,
              height: widget.height,
              asset: widget.asset,
              title: widget.title,
              textSize: widget.textSize,
              borderRadius: widget.borderRadius,
            ),
          ],
        ),
        //  Center(
        //        child: JackpotDropBoxPage(
        //         width: effectWidth,
        //         height: widget.height * SizeConfig.jackpotHeightRation,
        //      ),),
      ],
    );
  }
}

Widget DelayedJpDropBoxBody({
  required String dropValue,
  required int machineNumber,
  required bool isDrop,
  required String jpName,
  required double width,
  required double height,
  required String asset,
  required String title,
  required double textSize,
  required double borderRadius,
}) {
  return Container(
  //  margin: const EdgeInsets.symmetric(horizontal: MyString.padding12),
    // padding: const EdgeInsets.symmetric(horizontal: MyString.padding12),
    decoration: BoxDecoration(
      // color:MyColor.black_text_opa2,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: MyColor.white,
            fontSize: MyString.padding16,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          alignment: Alignment.center,
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(asset),
              fit: BoxFit.contain,
            ),
          ),
          child: Text(
            '\$$dropValue',
            style: TextStyle(
              color: MyColor.yellow_bg,
              fontSize: textSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              jpName,
              style: const TextStyle(
                color: MyColor.white,
                fontSize: MyString.padding16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "#$machineNumber",
              style: const TextStyle(
                color: MyColor.white,
                fontSize: MyString.padding16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    ),
  );
}











// imageBoxTitleWidget(
      //           width: SizeConfig.jackpotWithItem,
      //           height: widget.height * SizeConfig.jackpotHeightRation,
      //           asset: "asset/eclip.png",
      //           title: widget.jpName,
      //           sizeTitle: MyString.padding24,
      //           widget: Row(
      //             mainAxisSize: MainAxisSize.min,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             crossAxisAlignment: CrossAxisAlignment.center,
      //             children: [
      //               const Text(
      //                 "\$", // Add the "$" symbol as a separate Text widget
      //                 style: TextStyle(
      //                   fontSize: MyString.padding46,
      //                   color: MyColor.yellow_bg,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: MyString.padding08,
      //               ),
      //                Text(
      //                 "${widget.lastestValue}", // Add the "$" symbol as a separate Text widget
      //                 style: TextStyle(
      //                   fontSize: MyString.padding46,
      //                   color: MyColor.yellow_bg,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         );
