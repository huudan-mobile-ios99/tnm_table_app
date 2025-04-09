// import 'package:flutter/material.dart';
// import 'package:tournament_client/utils/mycolors.dart';

// class ImageBoxTitleWidget extends StatefulWidget {
//   final double textSize;
//   final String? title;
//   final bool? drop;
//   final double? sizeTitle;
//   final Widget widget;
//   final double width;
//   final double height;
//   final String asset;

//   const ImageBoxTitleWidget({
//     Key? key,
//     required this.textSize,
//     required this.title,
//     required this.drop,
//     this.sizeTitle,
//     required this.widget,
//     required this.width,
//     required this.height,
//     required this.asset,
//   }) : super(key: key);

//   @override
//   _ImageBoxTitleWidgetState createState() => _ImageBoxTitleWidgetState();
// }

// class _ImageBoxTitleWidgetState extends State<ImageBoxTitleWidget> {
//   bool showDroppedText = false; // Initially, the text is hidden

//   @override
//   void initState() {
//     super.initState();

//     // If `drop` is true, delay for 10 seconds before showing the text
//     if (widget.drop == true) {
//       Future.delayed(const Duration(seconds: 10), () {
//         setState(() {
//           showDroppedText = true;
//         });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Text(
//           "${widget.title}", // First text
//           style: TextStyle(
//             color: MyColor.white,
//             fontSize: widget.sizeTitle,
//             fontWeight: FontWeight.w600, // Non-bold for first text
//           ),
//           textAlign: TextAlign.center, // Center align if needed
//           textHeightBehavior: const TextHeightBehavior(
//             applyHeightToFirstAscent: false, // Controls the height behavior
//             applyHeightToLastDescent: false,
//           ),
//         ),
//         Container(
//           alignment: Alignment.center,
//           width: widget.width,
//           height: widget.height,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(widget.asset),
//               fit: BoxFit.contain,
//             ),
//           ),
//           child: widget.widget,
//         ),
//         showDroppedText
//             ? Text(
//                 "JP Dropped",
//                 style: TextStyle(
//                   color: MyColor.white,
//                   fontSize: widget.sizeTitle,
//                   fontWeight: FontWeight.w600, // Non-bold for first text
//                 ),
//                 textAlign: TextAlign.center, // Center align if needed
//                 textHeightBehavior: const TextHeightBehavior(
//                   applyHeightToFirstAscent: false,
//                   applyHeightToLastDescent: false,
//                 ),
//               )
//             : Container(), // Empty container if text is not yet shown
//       ],
//     );
//   }
// }