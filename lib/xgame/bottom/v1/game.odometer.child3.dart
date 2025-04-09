// import 'package:flutter/material.dart';
// import 'package:odometer/odometer.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame/bottom/size.config.dart';
// import 'package:tournament_client/xgame/bottom/widget/image.box.dart';
// import 'package:tournament_client/xgame/bottom/widget/jackpot.drop.box.dart';

// class GameOdometerChild3 extends StatefulWidget {
//   final int startValue1;
//   final int dropValue;
//   final int endValue1;
//   final String title1;
//   final double width;
//   final bool droppedJP;
//   final double height;
//   final int machineNumber;

//   const GameOdometerChild3({
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
//   _GameOdometerChild3State createState() => _GameOdometerChild3State();
// }

// class _GameOdometerChild3State extends State<GameOdometerChild3>
//     with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<OdometerNumber> animation;

//   bool showDroppedText = false; // To show the delayed "JP Dropped" text

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
//     // _handleDropLogic(); // Handle the "JP Dropped" logic
//     animationController.forward();
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     setState(() {
//       showDroppedText = false;
//     });
//   }

//   // Handle the "JP Dropped" logic based on the `droppedJP` flag
//   void _handleDropLogic() {
//     if (widget.droppedJP) {
//       Future.delayed( const Duration(seconds: (MyString.JPThrotDuration)), () {
//         if (mounted) {
//           setState(() {
//             showDroppedText = true;
//           });
//         }
//       });
//     }
//   }

//   void _initializeAnimation()  {
//     // Add a 6-second delay
//     // Future.delayed(const Duration(seconds: 6));
//     // Ensure widget is still mounted
//     if (!mounted) return;
//     // final duration = _calculateDuration(widget.startValue1, widget.endValue1);
//     animationController = AnimationController(
//       // duration: duration,
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

//   @override
//   void didUpdateWidget(covariant GameOdometerChild3 oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     // Check if either the start or end values have changed
//     if (widget.startValue1 != oldWidget.startValue1 ||
//         widget.endValue1 != oldWidget.endValue1) {
//       animationController.dispose(); // Dispose of the old controller
//       _initializeAnimation(); // Reinitialize with new values
//       animationController.forward(from: 0.0); // Restart the animation
//     }
//     if (widget.droppedJP != oldWidget.droppedJP) {
//       _handleDropLogic(); // Re-handle the drop logic if it changes
//     }
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double fullW = MediaQuery.of(context).size.width;
//     final double fullH = MediaQuery.of(context).size.height;
//     final double effectWidth = SizeConfig.controlVerSub *fullW ;

//    return  FutureBuilder(
//       future: Future.delayed(const Duration(seconds: MyString.JPShowDelayTime)),
//       builder:(context, snapshot) {
//         return SizedBox(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             widget.droppedJP==true &&  showDroppedText == true && widget.machineNumber != 0
//                 ?
//                 Row(
//                   // alignment: Alignment.center,
//                   children: [
//                   Center(
//                     child: JackpotDropBoxPage(
//                      width: effectWidth,
//                      height: widget.height * SizeConfig.jackpotHeightRation,
//                   ),),
//                   jpDropedBox(
//                     jpName: "VEGAS JP",
//                     width: SizeConfig.jackpotWithItem,
//                     height: widget.height * SizeConfig.jackpotHeightRation,
//                     asset: "asset/eclip.png",
//                     title: "CONGRATULATIONS\nYOU WIN",
//                     textSize: MyString.padding46,
//                     dropValue: widget.dropValue.toString(),
//                     machineNumber: widget.machineNumber,
//                   ),
//                   Center(
//                     child: JackpotDropBoxPage(
//                      width: effectWidth,
//                      height: widget.height * SizeConfig.jackpotHeightRation,
//                     ),
//                   )],
//                 )

//                 // JACKPOT PART 1 (NOT DROP)
//                 : Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     SizedBox(
//                       height: widget.height * SizeConfig.jackpotHeightRation,
//                       width: effectWidth,
//                     ),
//                     imageBoxTitleWidget(
//                        width: SizeConfig.jackpotWithItem,
//                         height: widget.height * SizeConfig.jackpotHeightRation,
//                         asset: "asset/eclip.png",
//                         title: widget.title1,
//                         drop: widget.droppedJP,
//                         sizeTitle: MyString.padding24,
//                         widget: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "\$", // Add the "$" symbol as a separate Text widget
//                               style: TextStyle(
//                                 fontSize: MyString.padding46,
//                                 color: MyColor.yellow_bg,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: MyString.padding08,
//                             ),
//                             SlideOdometerTransition(
//                               verticalOffset: -MyString.padding32,
//                               groupSeparator: const Text('.',style: TextStyle(
//                                 fontSize: MyString.padding46,
//                                 color: MyColor.yellow_bg,
//                                 fontWeight: FontWeight.bold,
//                               ),),

//                               letterWidth: MyString.padding24,
//                               odometerAnimation: animation,
//                               numberTextStyle: const TextStyle(
//                                 fontSize: MyString.padding46,
//                                 color: MyColor.yellow_bg,
//                                 fontWeight: FontWeight.bold,
//                               ),

//                             ),
//                           ],
//                         ),
//                       ),
//                     SizedBox(
//                       height: widget.height * SizeConfig.jackpotHeightRation,
//                       width: effectWidth,
//                     ),
//                   ],
//                 )
//           ],
//         ),
//       );
//       }
//     );
//   }
// }
