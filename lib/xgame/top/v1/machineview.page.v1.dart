// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/widget/loading.indicator.dart';
// import 'package:tournament_client/widget/text.dart';
// import 'package:tournament_client/xgame/top/bloc/stream_bloc/stream_bloc.dart';
// import 'package:tournament_client/xgame/top/view.stream.dart';
// import 'package:http/http.dart' as http;

// class MachineViewPage extends StatelessWidget {
//   const MachineViewPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       lazy: false,
//       create: (_) => StreamBloc(httpClient: http.Client())..add(StreamFeteched()),
//       child: const MachineViewPageBody(),
//     );
//   }
// }

// class MachineViewPageBody extends StatelessWidget {
//   const MachineViewPageBody({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     // const padding = MyString.padding08;
//     final double heightItem = height / 3;
//     final double widthItem = width / 3;

//     return BlocBuilder<StreamBloc, StreamMState>(builder: (context, state) {
//       switch (state.status) {
//         case StreamStatus.initial:
//           return Center(child: loadingNoIndicator());
//         case StreamStatus.failure:
//           return Center(
//               child: TextButton.icon(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               // ignore: invalid_use_of_visible_for_testing_member
//             },
//             label:  textcustom(text:'No Streams Found',size: MyString.padding08),
//           ));
//         case StreamStatus.success:
//           if (state.posts.isEmpty) {
//             return  Center(child: textcustom(text:'No Streams Found',size: MyString.padding08),);
//           }
//       }

//       // Replace the old `urlList` with `state.posts`
//       final List<String> urlList = state.posts.map((post) => post.url).toList();
//       return SizedBox(
        
//         width: width,
//         height: height,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               //1st Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(3, (index) {
//                   if (index < urlList.length) {
//                     return MachineViewItem(
//                       index: index,
//                       heightItem: heightItem,
//                       widthItem: widthItem,
//                       title: "MC ${index + 1}",
//                       active: urlList[index].isNotEmpty,
//                       url: urlList[index],
//                     );
//                   } else {
//                     return SizedBox(width: widthItem, height: heightItem);
//                   }
//                 }),
//               ),
//               //2nd Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (3 < urlList.length)
//                     MachineViewItem(
//                       index: 3,
//                       heightItem: heightItem,
//                       widthItem: widthItem,
//                       title: "MC 4",
//                       active: urlList[3].isNotEmpty,
//                       url: urlList[3],
//                     ),
//                   // Center custom UI instead of the 5th item
//                   SizedBox(
//                     width: widthItem,
//                     height: heightItem,
//                     child: Container( ), // Replace this with your custom widget
//                   ),
//                   if (5 < urlList.length)
//                     MachineViewItem(
//                       index: 5,
//                       heightItem: heightItem,
//                       widthItem: widthItem,
//                       title: "MC 5",
//                       active: urlList[5].isNotEmpty,
//                       url: urlList[5],
//                     ),
//                 ],
//               ),
//               //3rd Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(3, (index) {
//                   final itemIndex = 5 + index; // Starting from the 7th item
//                   if (itemIndex < urlList.length) {
//                     return MachineViewItem(
//                       heightItem: heightItem,
//                       widthItem: widthItem,
//                       index: itemIndex,
//                       title: "MC ${itemIndex+1}",
//                       active: urlList[itemIndex].isNotEmpty,
//                       url: urlList[itemIndex],
//                     );
//                   } else {
//                     return SizedBox(width: widthItem, height: heightItem);
//                   }
//                 }),
//               ),
              
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget MachineViewItem(
//       {required double widthItem,
//       required double heightItem,
//       required bool active,
//       required int index,
//       required String url,
//       required String title}) {
//     return 
//     Container(
//         margin: const EdgeInsets.symmetric(horizontal:MyString.padding28,vertical:MyString.padding12),
//         decoration: BoxDecoration(
//             border: Border.all(
//             color: MyColor.yellowMain,
//             width: MyString.padding06
//             ),
//             // borderRadius: BorderRadius.circular(MyString.padding08)
//             ),
//         width: widthItem-(MyString.padding28*2),
//         height: heightItem-(MyString.padding12*2),
//         child: active == true
//             ? IframeWidget(
//                 url: url,
//                 index: index,
//                 width: widthItem,
//                 height: heightItem,
//               )
//             : Container());
//     // Column(
//     //   mainAxisSize: MainAxisSize.max,
//     //   crossAxisAlignment: CrossAxisAlignment.center,
//     //   mainAxisAlignment: MainAxisAlignment.center,
//     //   children: [
//     //     Container(
//     //       alignment: Alignment.bottomLeft,
//     //       width: widthItem,
//     //       height: heightItem * .1,
//     //       child: textcustomColor(
//     //         text: title,
//     //         color: MyColor.white,
//     //       ),
//     //     ),
//     //     Container(
//     //         decoration: BoxDecoration(
//     //           border: Border.all(
//     //           color: MyColor.grey_tab,
//     //         )),
//     //         width: widthItem,
//     //         height: heightItem * .9,
//     //         child: active == true
//     //             ? IframeWidget(url: url, index: index, width: widthItem,height:heightItem,)
//     //             : Container())
//     //   ],
//     // );
//   }
// }
