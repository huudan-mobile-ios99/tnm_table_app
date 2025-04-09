// import 'package:flutter/material.dart';
// import 'package:odometer/odometer.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame/bottom/size.config.dart';
// import 'package:tournament_client/xgame/bottom/widget/image.box.dart';

// class GameOdometer2Child extends StatefulWidget {
//   final int startValue1;
//   final int dropValue;
//   final int endValue1;
//   final String title1;
//   final double width;
//   final bool droppedJP;
//   final double height;
//   final int machineNumber;

//   const GameOdometer2Child({
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
//   _GameOdometer2ChildState createState() => _GameOdometer2ChildState();
// }

// class _GameOdometer2ChildState extends State<GameOdometer2Child>
//     with TickerProviderStateMixin {
//   late AnimationController animationController;
//   late Animation<OdometerNumber> animation;

//   bool showDroppedText = false; // To show the delayed "JP Dropped" text

//   // Function to calculate animation duration based on the difference between start and end values
//   Duration _calculateDuration(int startValue, int endValue) {
//     return const Duration(seconds: MyString.JPThrotDuration2);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _initializeAnimation();
//     _handleDropLogic(); // Handle the "JP Dropped" logic
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
//       Future.delayed( const Duration(seconds: MyString.JPThrotDuration2), () {
//         if (mounted) {
//           setState(() {
//             showDroppedText = true;
//           });
//         }
//       });
//     }
//   }

//   void _initializeAnimation() {
//     final duration = _calculateDuration(widget.startValue1, widget.endValue1);
//     animationController = AnimationController(
//       duration: duration,
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
//   void didUpdateWidget(covariant GameOdometer2Child oldWidget) {
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
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         widget.droppedJP==true &&  showDroppedText == true && widget.machineNumber != 0
//             ? jpDropedBox(
//                 jpName: "LUCKY JP",
//                 width: SizeConfig.jackpotWithItem,
//                 height: widget.height * SizeConfig.jackpotHeightRation,
//                 asset: "asset/eclip.png",
//                 title: "CONGRATULATIONS\nYOU WIN",
//                 textSize: MyString.padding46,
//                 dropValue: widget.dropValue.toString(),
//                 machineNumber: widget.machineNumber,
//               )
//             : imageBoxTitleWidget(
//                 width: SizeConfig.jackpotWithItem,
//                 height: widget.height * SizeConfig.jackpotHeightRation,
//                 asset: "asset/eclip.png",
//                 title: widget.title1,
//                 drop: widget.droppedJP,
//                 sizeTitle: MyString.padding24,
//                 widget: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "\$", // Add the "$" symbol as a separate Text widget
//                       style: TextStyle(
//                         fontSize: MyString.padding46,
//                         color: MyColor.yellow_bg,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: MyString.padding08,
//                     ),
//                     SlideOdometerTransition(
//                       verticalOffset: -MyString.padding24,
//                       groupSeparator: const Text('.',style: TextStyle(
//                         fontSize: MyString.padding46,
//                         color: MyColor.yellow_bg,
//                         fontWeight: FontWeight.bold,
//                       ),),
//                       letterWidth: MyString.padding24,
//                       odometerAnimation: animation,
//                       numberTextStyle: const TextStyle(
//                         fontSize: MyString.padding46,
//                         color: MyColor.yellow_bg,
//                         fontWeight: FontWeight.bold,
//                       ),

//                     ),
//                   ],
//                 ),
//               )
//       ],
//     );
//   }
// }
