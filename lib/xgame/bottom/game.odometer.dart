// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:odometer/odometer.dart';

// class GameOdometer extends StatefulWidget {
//   const GameOdometer({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   _GameOdometerState createState() => _GameOdometerState();
// }

// class _GameOdometerState extends State<GameOdometer> with SingleTickerProviderStateMixin {
//   final int _startValue = 100;
//   int _targetValue = 100; // New target value for odometer
//   AnimationController? animationController;
//   late Animation<OdometerNumber> animation;
//   late int randomValue; // Random value between 100 and 150

//   // Define base duration default
//   final int baseDurationDefault = 60; // in seconds

//   // Function to calculate animation duration based on randomValue
//   Duration _calculateDuration(int value) {
//     const int baseValue = 100;
//     return Duration(
//         seconds: (value - baseValue) *
//             baseDurationDefault ~/
//             baseValue); // Use baseDurationDefault
//   }

//   void _generateRandomTarget() {
//     setState(() {
//       randomValue = Random().nextInt(51) + 100; // Random value between 100 and 150
//       _targetValue = randomValue;

//       // Reset the controller and animation
//       animationController?.reset(); // Instead of dispose, just reset it
//       final duration =
//           _calculateDuration(randomValue); // Calculate the duration
//       animationController?.duration = duration; // Adjust duration

//       animation = OdometerTween(
//         begin: OdometerNumber(_startValue), // Start from the current value
//         end: OdometerNumber(_targetValue), // Go to the new random target
//       ).animate(
//         CurvedAnimation(
//           parent: animationController!,
//           curve: Easing.linear,
//         ),
//       );
//       animationController?.forward(); // Start the animation
//       // Print the second value for the current random number
//       debugPrint("Duration for random value $randomValue: ${duration.inSeconds} seconds");
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Initial setup with default start value and animation
//     animationController = AnimationController(
//       duration:Duration(seconds: baseDurationDefault), // Use baseDurationDefault
//       vsync: this,
//     );

//     // Call _generateRandomTarget to set the initial target value
//     _generateRandomTarget();

//     animation = OdometerTween(
//       begin: OdometerNumber(_startValue),
//       end: OdometerNumber(_targetValue),
//     ).animate(
//       CurvedAnimation(parent: animationController!, curve: Easing.linear),
//     );
//   }

//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
      
//         Padding(
//           padding: const EdgeInsets.only(top: 30),
//           child: SlideOdometerTransition(
//             letterWidth: 20,
//             odometerAnimation: animation,
//             numberTextStyle: const TextStyle(fontSize: 20),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 30),
//           child: ElevatedButton(
//             onPressed: _generateRandomTarget,
//             child: const Text('Generate'), // New Generate button
//           ),
//         ),
//       ],
//     );
//   }
// }
