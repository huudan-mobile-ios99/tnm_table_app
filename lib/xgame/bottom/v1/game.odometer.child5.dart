// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:odometer/odometer.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame/bottom/size.config.dart';
// import 'package:tournament_client/xgame/bottom/widget/image.box.dart';
// import 'package:tournament_client/xgame/bottom/widget/jackpot.drop.box.dart';

// class GameOdometerChild5 extends StatefulWidget {
//   final int startValue1;
//   final int dropValue;
//   final int endValue1;
//   final String title1;
//   final double width;
//   bool droppedJP;
//   final double height;
//   final int machineNumber;

//    GameOdometerChild5({
//     Key? key,
//     required this.startValue1,
//     required this.endValue1,
//     required this.dropValue,
//     required this.title1,
//     required this.width,
//     required this.height,
//     required this.droppedJP,
//     required this.machineNumber,
//   }) : super(key: key);

//   @override
//   _GameOdometerChild5State createState() => _GameOdometerChild5State();
// }

// class _GameOdometerChild5State extends State<GameOdometerChild5>
//     with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<OdometerNumber> animation;

//   bool showDroppedText = false; // To show the delayed "JP Dropped" text
//   bool dropStatus = false;
//   Timer? dropTimer; // Timer instance for managing delay



//   // Function to calculate animation duration based on the difference between start and end values
//   Duration _calculateDuration(int startValue, int endValue) {
//   // Set the base duration default to 10 seconds
//     return const Duration(seconds: MyString.JPShowDelayTime);
//   }

//   @override
//   void initState() {

//     super.initState();
//     // Initialize the animation controller early to avoid LateInitializationError
//     animationController = AnimationController(
//       duration: Duration.zero,
//       vsync: this,
//     );
//     _initializeAnimation();
//     animationController.forward();
//   }

//   @override
// void didUpdateWidget(covariant GameOdometerChild5 oldWidget) {
//   super.didUpdateWidget(oldWidget);

//   if (widget.startValue1 != oldWidget.startValue1 ||
//         widget.endValue1 != oldWidget.endValue1) {
//       animationController.dispose();
//       _initializeAnimation();
//       animationController.forward(from: 0.0);
//     }

//     if (widget.droppedJP != oldWidget.droppedJP && widget.droppedJP) {
//       _handleDropLogic(); // Trigger drop logic when droppedJP changes to true
//     }

// }

// void _handleDropLogic() {
//     debugPrint("_handleDropLogic Called");
//     // Cancel any previous timer to avoid overlaps
//     dropTimer?.cancel();
//     // Set up the new timer
//     dropTimer = Timer(Duration(seconds: MyString.JPShowDelayTime * 2), () {
//       if (mounted) {
//         setState(() {
//           showDroppedText = true; // Show the dropped text
//           dropStatus = true; // Update drop status
//         });
//       }
//     });
//   }


//   void _initializeAnimation()  {
//     // Ensure widget is still mounted
//     if (!mounted) return;
//     animationController = AnimationController(
//       duration:const Duration(seconds: MyString.JPShowDelayTime),
//       vsync: this,
//     );

//     animation = OdometerTween(
//       begin: OdometerNumber(widget.startValue1),
//       end: OdometerNumber(widget.endValue1),
//     ).animate(
//       CurvedAnimation(
//         parent: animationController,
//         curve: Easing.standard,
//       ),
//     );
//   }


// @override
//   void dispose() {
//     // Dispose of animation controller and cancel timer
//     animationController.dispose();
//     dropTimer?.cancel(); // Ensure the timer is canceled to avoid leaks
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final double fullW = MediaQuery.of(context).size.width;
//     final double fullH = MediaQuery.of(context).size.height;
//     final double effectWidth = SizeConfig.controlVerSub *fullW ;

//    return  SizedBox(
//    child: Row(
//      mainAxisAlignment: MainAxisAlignment.spaceAround,
//      crossAxisAlignment: CrossAxisAlignment.center,
//      mainAxisSize: MainAxisSize.min,
//      children: [
//         showDroppedText == true && dropStatus==true  && widget.machineNumber != 0
//            ?
//            // Text("STATUS showDroppedText: $showDroppedText  widget.droppedJP:${widget.droppedJP}")
//            Row(
//              children: [
//              Center(
//                child: JackpotDropBoxPage(
//                 width: effectWidth,
//                 height: widget.height * SizeConfig.jackpotHeightRation,
//              ),),
//              jpDropedBox(
//                jpName: "VEGAS JP",
//                width: SizeConfig.jackpotWithItem,
//                height: widget.height * SizeConfig.jackpotHeightRation,
//                asset: "asset/eclip.png",
//                title: "CONGRATULATIONS\nYOU WIN",
//                textSize: MyString.padding46,
//                dropValue: widget.dropValue.toString(),
//                machineNumber: widget.machineNumber,
//              ),
//              Center(
//                child: JackpotDropBoxPage(
//                 width: effectWidth,
//                 height: widget.height * SizeConfig.jackpotHeightRation,
//                ),
//              )],
//            )

//            : Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisSize: MainAxisSize.max,
//              children: [
//                SizedBox(
//                  height: widget.height * SizeConfig.jackpotHeightRation,
//                  width: effectWidth,
//                ),
//                imageBoxTitleWidget(
//                   width: SizeConfig.jackpotWithItem,
//                    height: widget.height * SizeConfig.jackpotHeightRation,
//                    asset: "asset/eclip.png",
//                    title: widget.title1,
//                    drop: widget.droppedJP,
//                    sizeTitle: MyString.padding24,
//                    widget: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: [
//                        const Text(
//                          "\$", // Add the "$" symbol as a separate Text widget
//                          style: TextStyle(
//                            fontSize: MyString.padding46,
//                            color: MyColor.yellow_bg,
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        const SizedBox(
//                          width: MyString.padding08,
//                        ),
//                        SlideOdometerTransition(
//                          verticalOffset: -MyString.padding32,
//                          groupSeparator: const Text('.',style: TextStyle(
//                            fontSize: MyString.padding46,
//                            color: MyColor.yellow_bg,
//                            fontWeight: FontWeight.bold,
//                          ),),

//                          letterWidth: MyString.padding24,
//                          odometerAnimation: animation,
//                          numberTextStyle: const TextStyle(
//                            fontSize: MyString.padding46,
//                            color: MyColor.yellow_bg,
//                            fontWeight: FontWeight.bold,
//                          ),

//                        ),
//                      ],
//                    ),
//                  ),
//                SizedBox(
//                  height: widget.height * SizeConfig.jackpotHeightRation,
//                  width: effectWidth,
//                ),
//              ],
//            )
//      ],
//    ),
//          );
//   }
// }
