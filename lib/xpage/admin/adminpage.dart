// import 'package:flutter/material.dart';
// import 'package:tournament_client/historypage.dart';
// import 'package:tournament_client/widget/text.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/utils/showsnackbar.dart';
// import 'package:tournament_client/service/service_api.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/screen/admin/model/rankingList.dart';

// class AdminPage extends StatefulWidget {
//   SocketManager? mySocket;
//   // RankingModel rankings;
//   AdminPage({
//     Key? key,
//     this.mySocket,
//   }) : super(key: key);

//   @override
//   State<AdminPage> createState() => _AdminPageState();
// }

// class _AdminPageState extends State<AdminPage> {
//   IO.Socket? socket;
//   final TextEditingController controllerName = TextEditingController(text: '');
//   final TextEditingController controllerNumber =
//       TextEditingController(text: '');
//   final TextEditingController controllerPoint =
//       TextEditingController(text: '0');
//   GlobalKey<RefreshIndicatorState> refreshKey =
//       GlobalKey<RefreshIndicatorState>();
//   Future<void> _refreshData() async {
//     // Fetch and update your data from the server here
//     // final updatedData = await service_api.listRanking();
//     setState(() {
//       // Assuming `model` is a state variable
//     });
//   }

//   @override
//   void initState() {
//     debugPrint('INIT ADMINPAGE');
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     socket!.dispose();
//     SocketManager().disposeSocket();
//   }

//   final service_api = ServiceAPIs();
//   final TextEditingController controllerLimit =
//       TextEditingController(text: MyString.DEFAULT_COLUMN);
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SetUp Top Ranking Display'),
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (_) => const HistoryPage()));
//             },
//             child: textcustom(text: "HISTORY"),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: textcustom(text: "Setting Limit Ranking Display"),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         TextField(
//                           controller: controllerLimit,
//                           decoration: const InputDecoration(
//                             hintText: 'FROM 1 -> 20',
//                           ),
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(); // Close the dialog
//                         },
//                         child: const Text('CANCEL'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           if (int.parse(controllerLimit.text) > 20) {
//                             showSnackBar(
//                                 context: context,
//                                 message:
//                                     'Input invalid, Please input from 1-20');
//                           } else {
//                             SocketManager().emitEventChangeLimitTopRanking(
//                                 int.parse(controllerLimit.text));
//                             showSnackBar(
//                                 context: context, message: 'Setting finished');
//                             Navigator.of(context).pop();
//                           }
//                         },
//                         child: const Text('SUBMIT'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: textcustom(text: "SETTING LIMIT")),
//           ElevatedButton(
//               onPressed: () {
//                 debugPrint('add round');
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: textcustom(text: "ADD ROUND"),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         textcustom(
//                             text:
//                                 "Add2 round from realtime data to top ranking will be take action if you click confirm")
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop(); // Close the dialog
//                         },
//                         child: const Text('CANCEL'),
//                       ),
//                       TextButton(
//                         onPressed: () async {
//                           print('data create round : ');
//                           // await service_api.createRound(
//                           //   rankings:
//                           // ).then((value) => showSnackBar(context:context,message:value['message'])).whenComplete(() => Navigator.of(context).pop());
//                         },
//                         child: const Text('SAVE'),
//                       ),
//                       // TextButton(
//                       //   onPressed: () async {
//                       //     await service_api
//                       //         .addRealTimeRanking()
//                       //         .then((value) => showSnackBar(context: context, message: value['message']))
//                       //         .whenComplete(() => Navigator.of(context).pop());
//                       //   },
//                       //   child: const Text('CONFIRM'),
//                       // ),
//                     ],
//                   ),
//                 );
//               },
//               child: textcustom(text: "ADD ROUND")),
//           ElevatedButton(
//               onPressed: () {
//                 print('rebuild top rank');
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: textcustom(text: "Re-Build Top Ranking"),
//                     content: textcustom(
//                         text:
//                             "Re-Build top ranking will be take action if you click confirm"),
//                     actions: [
//                       TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: textcustom(text: "CANCEL")),
//                       TextButton(
//                           onPressed: () {
//                             // widget.mySocket!.emitEventFromClient2Force();
//                             Navigator.of(context).pop();
//                           },
//                           child: textcustom(text: "CONFIRM")),
//                     ],
//                   ),
//                 );
//               },
//               child: textcustom(text: "REFRESH UI"))
//         ],
//       ),
//       floatingActionButtonLocation:
//           FloatingActionButtonLocation.miniCenterDocked,
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           FloatingActionButton(
//             tooltip: 'Refresh list to view updated data',
//             backgroundColor: MyColor.green,
//             onPressed: () {
//               setState(() {});
//             },
//             child: const Icon(Icons.refresh_outlined),
//           ),
//           const SizedBox(
//             width: 16.0,
//           ),
//           FloatingActionButton(
//             tooltip: 'Reset List Ranking To Default',
//             backgroundColor: MyColor.red,
//             onPressed: () {
//               print('reset all for the 1st round');
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: textcustom(text: "Reset All Data Of Top Ranking"),
//                   content: textcustom(
//                       text:
//                           "Reset top ranking will be make top ranking as default  if you click confirm"),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: textcustom(text: "CANCEL")),
//                     TextButton(
//                         onPressed: () {
//                           service_api
//                               .deleteRankingAllAndAddDefault()
//                               .then((value) {
//                             print(value);
//                             setState(() {});
//                           }).whenComplete(() => null);
//                           Navigator.of(context).pop();
//                         },
//                         child: textcustom(text: "CONFIRM")),
//                   ],
//                 ),
//               );
//             },
//             child: const Icon(Icons.reset_tv),
//           ),
//           const SizedBox(
//             width: 16.0,
//           ),
//           FloatingActionButton(
//               tooltip: "add new ranking",
//               onPressed: () {
//                 print('add');
//                 openAlertDialog(
//                     function: () {
//                       service_api
//                           .createRanking(
//                               // customer_name: 'test',customer_number: '234',point:'234',
//                               customer_name: controllerName.text,
//                               customer_number: controllerNumber.text,
//                               point: controllerPoint.text)
//                           .then((value) {
//                         showSnackBar(
//                             context: context, message: value['message']);
//                         setState(() {});
//                         if (value['status'] == true) {
//                           print('run it');
//                         }
//                       }).whenComplete(() {
//                         setState(() {
//                           controllerName.text = '';
//                           controllerNumber.text = '';
//                           controllerPoint.text = '0';
//                         });

//                         Navigator.of(context).pop();
//                       });
//                     },
//                     service_api: service_api,
//                     context: context,
//                     controllerName: controllerName,
//                     controllerNumber: controllerNumber,
//                     controllerPoint: controllerPoint);
//               },
//               child: const Icon(
//                 Icons.add,
//               ))
//         ],
//       ),
//       body: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//           width: width,
//           height: height,
//           alignment: Alignment.topCenter,
//           decoration: const BoxDecoration(
//             color: MyColor.white,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //   crossAxisAlignment: CrossAxisAlignment.center,
//               //   children: [
//               //     IconButton(
//               //         onPressed: () {
//               //           Navigator.of(context).pop();
//               //         },
//               //         icon: Icon(
//               //           Icons.arrow_back_ios,
//               //         )),
//               //     ElevatedButton(
//               //         onPressed: () {
//               //           print('refresh to list');
//               //           setState(() {});
//               //         },
//               //         child: textcustom(
//               //             text: 'REFRESH LIST',
//               //             size: 14.0,
//               //             color: MyColor.black_text)),
//               //     ElevatedButton(
//               //         onPressed: () {
//               //           print('refresh to force update data');
//               //           SocketManager().emitEventFromClient2Force();
//               //         },
//               //         child: textcustom(
//               //             text: 'REFRESH TABLET',
//               //             size: 14.0,
//               //             color: MyColor.black_text)),
//               //     Image.asset('asset/image/logo_renew.png',
//               //         width: 65.0, height: 65.0),
//               //     TextButton(
//               //         onPressed: () {
//               //           print('reset all for the 1st round');
//               //           service_api
//               //               .deleteRankingAllAndAddDefault()
//               //               .whenComplete(() => null);
//               //         },
//               //         child: textcustom(
//               //             text: 'RESET RANKING',
//               //             size: 14.0,
//               //             color: MyColor.black_text)),
//               //   ],
//               // ),
//               Expanded(
//                   // height: height * 0.925,
//                   // width: width,
//                   child: FutureBuilder(
//                 future: service_api.listRanking(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<RankingModel?> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Text('An error orcur ${snapshot.error}');
//                   }

//                   final model = snapshot.data;
//                   if (model!.data == null) {
//                     return const Text('no data');
//                   }
//                   return RefreshIndicator(
//                     key: refreshKey,
//                     onRefresh: _refreshData,
//                     child: ListView.builder(
//                       padding: const EdgeInsets.all(4.0),
//                       itemCount: model.data!.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 10.0),
//                           decoration: BoxDecoration(
//                               color: MyColor.white,
//                               border: Border.all(
//                                   color: MyColor.yellow_accent, width: 1.5),
//                               borderRadius: BorderRadius.circular(16.0)),
//                           child: ListTile(
//                             leading: Text(
//                               '${index + 1}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 16.0),
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       print('update $index');
//                                       openAlertDialogUpdate(
//                                           service_api: service_api,
//                                           function: () {
//                                             service_api
//                                                 .updateRanking(
//                                                     customer_name:
//                                                         controllerName.text,
//                                                     customer_number:
//                                                         controllerNumber.text,
//                                                     point: controllerPoint.text)
//                                                 .then((value) {
//                                               showSnackBar(
//                                                   context: context,
//                                                   message: value['message']);
//                                               refreshKey.currentState?.show();
//                                             }).whenComplete(() {
//                                               controllerName.text == '';
//                                               controllerNumber.text == '';
//                                               controllerPoint.text == '';
//                                               Navigator.of(context).pop();
//                                             });
//                                           },
//                                           context: context,
//                                           valueName:
//                                               model.data![index].customerName,
//                                           valueNumber:
//                                               model.data![index].customerNumber,
//                                           valuePoint: model.data![index].point
//                                               .toString(),
//                                           controllerName: controllerName,
//                                           controllerNumber: controllerNumber,
//                                           controllerPoint: controllerPoint);
//                                     },
//                                     icon: const Icon(Icons.update)),
//                                 const SizedBox(width: 16.0),
//                                 IconButton(
//                                     onPressed: () {
//                                       print('printsomething');
//                                       // print('delete $index ${model.data![index].customerName} ${model.data![index].customerNumber}');

//                                       showDialog(
//                                         context: context,
//                                         builder: (context) => AlertDialog(
//                                           title: textcustom(
//                                               text:
//                                                   "DELETE TOP RANKING RECORD"),
//                                           content: Column(
//                                             mainAxisSize: MainAxisSize.min,
//                                             children: [
//                                               textcustom(
//                                                   text:
//                                                       "This item of top ranking will be delete  if you click confirm")
//                                             ],
//                                           ),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () {
//                                                 Navigator.of(context)
//                                                     .pop(); // Close the dialog
//                                               },
//                                               child: const Text('CANCEL'),
//                                             ),
//                                             TextButton(
//                                               onPressed: () {
//                                                 service_api
//                                                     .deleteRanking(
//                                                   customer_name: model
//                                                       .data![index]
//                                                       .customerName,
//                                                   customer_number: model
//                                                       .data![index]
//                                                       .customerNumber
//                                                       .toString(),
//                                                 )
//                                                     .then((value) {
//                                                   if (value['status'] ==
//                                                       true) {}
//                                                   showSnackBar(
//                                                       context: context,
//                                                       message:
//                                                           value['message']);
//                                                   setState(() {});
//                                                 }).whenComplete(() => null);
//                                                 Navigator.of(context).pop();
//                                               },
//                                               child: const Text('SUBMIT'),
//                                             ),
//                                           ],
//                                         ),
//                                       );
//                                     },
//                                     icon: const Icon(Icons.delete)),
//                               ],
//                             ),
//                             contentPadding:
//                                 const EdgeInsets.symmetric(horizontal: 8.0),
//                             style: ListTileStyle.drawer,
//                             dense: true,
//                             visualDensity:
//                                 VisualDensity.adaptivePlatformDensity,
//                             selectedColor: MyColor.white,
//                             title: textcustom(
//                                 text: '${model.data![index].customerName}',
//                                 size: 22.0,
//                                 isBold: true),
//                             subtitle: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 textcustom(
//                                     text:
//                                         'Number:${model.data![index].customerNumber}',
//                                     size: 16.0),
//                                 textcustom(
//                                     text: 'Point: ${model.data![index].point}',
//                                     size: 18.0,
//                                     isBold: true),
//                                 textcustom(
//                                     text:
//                                         'Time: ${model.data![index].createdAt}',
//                                     size: 16.0),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ))
//             ],
//           )),
//     );
//   }
// }

// // Widget openAlertDialog(
// //     {controllerName, controllerNumber, controllerPoint, context}) {
// //   return AlertDialog(
// //     backgroundColor: Colors.white,
// //     shape: RoundedRectangleBorder(
// //       borderRadius: BorderRadius.circular(10.0), // Set border radius
// //     ),
// //     title: const Text('Player Setting'),
// //     content: Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         TextField(
// //           controller: controllerName,
// //           keyboardType: TextInputType.number,
// //           decoration: const InputDecoration(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
// //             hintText: 'Enter player name ',
// //           ),
// //         ),
// //         TextField(
// //           controller: controllerNumber,
// //           keyboardType: TextInputType.number,
// //           decoration: const InputDecoration(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
// //             hintText: 'Enter player number ',
// //           ),
// //         ),
// //         TextField(
// //           controller: controllerPoint,
// //           keyboardType: TextInputType.number,
// //           decoration: const InputDecoration(
// //             contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
// //             hintText: 'Enter point ',
// //           ),
// //         ),
// //       ],
// //     ),
// //     actions: [],
// //   );
// // }

// void openAlertDialog(
//     {TextEditingController? controllerName,
//     TextEditingController? controllerNumber,
//     TextEditingController? controllerPoint,
//     BuildContext? context,
//     function,
//     ServiceAPIs? service_api}) {
//   showDialog(
//     context: context!,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         title: const Text('Add New Player '),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: controllerName,
//               keyboardType: TextInputType.text,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter player name',
//               ),
//             ),
//             TextField(
//               controller: controllerNumber,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter player number',
//               ),
//             ),
//             TextField(
//               controller: controllerPoint,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter point',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (validateFields(
//                   controllerName!, controllerNumber!, controllerPoint!)) {
//                 function();
//               } else {
//                 showSnackBar(
//                     context: context,
//                     message: 'Please fill all input & point >0 ');
//                 // You can use a ScaffoldMessenger or other methods to display the error message.
//               }
//             },
//             child: const Text('SUBMIT'),
//           ),
//         ],
//       );
//     },
//   );
// }

// bool validateFields(
//     TextEditingController controllerName,
//     TextEditingController controllerNumber,
//     TextEditingController controllerPoint) {
//   // Check if any of the text controllers is null or empty
//   if (controllerName.text.isEmpty ||
//       controllerNumber.text.isEmpty ||
//       controllerPoint.text.isEmpty) {
//     return false;
//   }

//   // Check if the "point" field has a value greater than 0
//   if (double.tryParse(controllerPoint.text)! <= 0) {
//     return false;
//   }

//   // All validation conditions are met
//   return true;
// }

// void openAlertDialogUpdate(
//     {TextEditingController? controllerName,
//     TextEditingController? controllerNumber,
//     TextEditingController? controllerPoint,
//     BuildContext? context,
//     String? valueName,
//     function,
//     String? valueNumber,
//     String? valuePoint,
//     ServiceAPIs? service_api}) {
//   // Set default values for the text fields
//   controllerName?.text = "$valueName"; // Set your default name
//   controllerNumber?.text = "$valueNumber"; // Set your default number
//   controllerPoint?.text = "$valuePoint"; // Set your default number
//   showDialog(
//     context: context!,
//     builder: (context) {
//       return AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         title: const Text('Update  Player '),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               enabled: true,
//               controller: controllerName,
//               keyboardType: TextInputType.text,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter player name',
//               ),
//             ),
//             TextField(
//               enabled: false,
//               controller: controllerNumber,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter player number',
//               ),
//             ),
//             TextField(
//               controller: controllerPoint,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
//                 hintText: 'Enter point',
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () {
//               if (validateFields(
//                   controllerName!, controllerNumber!, controllerPoint!)) {
//                 function();
//               } else {
//                 showSnackBar(
//                     context: context,
//                     message: 'Please fill different point value ');
//                 // You can use a ScaffoldMessenger or other methods to display the error message.
//               }
//             },
//             child: const Text('SUBMIT'),
//           ),
//         ],
//       );
//     },
//   );
// }
