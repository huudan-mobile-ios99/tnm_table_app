import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/lib/models/roundModel.dart';
import 'package:tournament_client/service/format.date.factory.dart';

import '../../utils/functions.dart';

// import 'dart:js' as js;
// import 'package:flutter/foundation.dart' show kIsWeb;

class HistoryPageTop extends StatefulWidget {
  const HistoryPageTop({Key? key}) : super(key: key);

  @override
  State<HistoryPageTop> createState() => _HistoryPageTopState();
}

class _HistoryPageTopState extends State<HistoryPageTop> {
  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerNumber =
      TextEditingController(text: '');
  final TextEditingController controllerPoint =
      TextEditingController(text: '0');
  GlobalKey<RefreshIndicatorState> refreshKey =GlobalKey<RefreshIndicatorState>();
  final DateFormatter formatString = DateFormatter();
  Future<void> _refreshData() async {
    setState(() {});
  }


  // Future<void> _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }



  @override
  void initState() {
    debugPrint('INIT HistoryPageTop');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final service_api = ServiceAPIs();
  final TextEditingController controllerLimit =  TextEditingController(text: MyString.DEFAULT_COLUMN);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  textcustom(text:'History Top Ranking',size: MyString.padding16),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                debugPrint('export data rounds');
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Export round data"),
                          content: textcustom(
                              text:
                                  "Click ok to export round data to excel file"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: textcustom(text: "CANCEL")),
                            TextButton(
                                onPressed: () {
                                  debugPrint('confirm');
                                  service_api.exportDataExcel().then((value) {
                                    showSnackBar(
                                        context: context,
                                        message:'${value['message']} with filePath ${value['filePath']}');
                                    launchUrl(Uri.parse(MyString.downloadround(value['filePath'])));
                                    // kIsWeb ?  js.context.callMethod('open', [MyString.downloadround(value['filePath'])]) : null ;
                                  }).whenComplete(() => Navigator.of(context).pop(context));
                                },
                                child: textcustom(text: "OK")),
                          ],
                        ));
              },
              tooltip: 'export excel',
              icon: const Icon(Icons.download_outlined))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh list to view updated data',
        backgroundColor: MyColor.green,
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh_outlined),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: MyString.padding16, vertical: MyString.padding04),
          width: width,
          height: height,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            color: MyColor.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder(
                future: service_api.listRounds(),
                builder: (BuildContext context,
                    AsyncSnapshot<RoundModel?> snapshot) {
                  late RoundModel model = snapshot.data as RoundModel;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('An error orcur ${snapshot.error}');
                  } else if (model.data.isEmpty) {
                    return textcustom(text: "no rounds found");
                  }

                  return RefreshIndicator(
                    key: refreshKey,
                    onRefresh: _refreshData,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(MyString.padding04),
                      itemCount: model.data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: MyString.padding08),
                          decoration: BoxDecoration(
                              color: MyColor.white,
                              border: Border.all( color: MyColor.grey_tab, width: 1.0),
                              borderRadius: BorderRadius.circular(MyString.padding08)),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) => AlertDialog(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            textcustom(text: '${index + 1}. ${model.data[index].name.toUpperCase()}',size: MyString.padding16),
                                            textcustom(text: formatString.formatDateAndTimeFirst(model.data[index].createdAt.toLocal()),size:MyString.padding14),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: textcustom(text: "CANCEL"))
                                        ],
                                        content: SizedBox(
                                          height: height / 2,
                                          width: width / 2,
                                          child: model.data[index].rankings
                                                      .isEmpty ||
                                                  snapshot.data == null
                                              ? textcustom(
                                                  text: "no details found")
                                              : ListView.builder(
                                                  shrinkWrap: false,
                                                  itemCount: model.data[index]
                                                          .rankings.length ??0,
                                                  physics:
                                                      const AlwaysScrollableScrollPhysics(),
                                                  itemBuilder: (context, i) =>
                                                      Card(
                                                    child: ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          textcustomIcon(
                                                              icon:
                                                                  Icons.person,
                                                              text:
                                                                  "${model.data[index].rankings[i].customerName}",
                                                              color: MyColor
                                                                  .black_text,
                                                              size: MyString
                                                                  .padding16),
                                                         
                                                          textcustomIcon(
                                                              icon: Icons.attach_money,
                                                              text: formatNumberWithCommas(model.data[index].rankings[i].point as num),
                                                              color: MyColor.orange_accent,
                                                              size: MyString.padding16),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      )));
                            },
                    //         trailing: IconButton(
                    //           tooltip: 'restore this history round to current',
                    //           onPressed: (){
                    //           print('press restore $index');
                    //           showDialog(
                    // context: context,
                    // builder: (context) => AlertDialog(
                    //       title:  Text("Restore this round to current"),
                    //       content: textcustom(
                    //           text: "Click confirm to restore this round to current?\n${index+1}. ${model.data[index].name.toUpperCase()}\nAfter restore sucessfully, please use Refresh View button to apply changes in the UI"),
                    //       actions: [
                    //         TextButton(
                    //             onPressed: () {
                    //               Navigator.of(context).pop();
                    //             },
                    //             child: textcustom(text: "CANCEL")),
                    //         TextButton(
                    //             onPressed: () {
                    //               debugPrint('confirm restore');
                    //             },
                    //             child: textcustom(text: "CONFIRM")),
                    //       ],
                    //     ));
                    //         }, icon: Icon(Icons.restore_page_rounded,size: MyString.padding36,)),
                            leading: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: MyString.padding16),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: MyString.padding08),
                            style: ListTileStyle.drawer,
                            dense: true,
                            visualDensity:
                                VisualDensity.adaptivePlatformDensity,
                            selectedColor: MyColor.white,
                            title: textcustom(
                                text: model.data[index].name,
                                size: MyString.padding16,
                                isBold: true),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textcustom(
                                    text: formatString.formatDateAndTimeFirst(model.data[index].createdAt.toLocal()),
                                    size: MyString.padding16),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ))
            ],
          )),
    );
  }
}

// Widget openAlertDialog(
//     {controllerName, controllerNumber, controllerPoint, context}) {
//   return AlertDialog(
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(MyString.padding08), // Set border radius
//     ),
//     title: const Text('Player Setting'),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         TextField(
//           controller: controllerName,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
//             hintText: 'Enter player name ',
//           ),
//         ),
//         TextField(
//           controller: controllerNumber,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
//             hintText: 'Enter player number ',
//           ),
//         ),
//         TextField(
//           controller: controllerPoint,
//           keyboardType: TextInputType.number,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
//             hintText: 'Enter point ',
//           ),
//         ),
//       ],
//     ),
//     actions: [],
//   );
// }

void openAlertDialog(
    {TextEditingController? controllerName,
    TextEditingController? controllerNumber,
    TextEditingController? controllerPoint,
    BuildContext? context,
    function,
    ServiceAPIs? service_api}) {
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyString.padding08),
        ),
        title: const Text('Add New Player '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter point',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (validateFields(
                  controllerName!, controllerNumber!, controllerPoint!)) {
                function();
              } else {
                showSnackBar(
                    context: context,
                    message: 'Please fill all input & point >0 ');
                // You can use a ScaffoldMessenger or other methods to display the error message.
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      );
    },
  );
}

bool validateFields(
    TextEditingController controllerName,
    TextEditingController controllerNumber,
    TextEditingController controllerPoint) {
  // Check if any of the text controllers is null or empty
  if (controllerName.text.isEmpty ||
      controllerNumber.text.isEmpty ||
      controllerPoint.text.isEmpty) {
    return false;
  }

  // Check if the "point" field has a value greater than 0
  if (double.tryParse(controllerPoint.text)! <= 0) {
    return false;
  }

  // All validation conditions are met
  return true;
}

void openAlertDialogUpdate(
    {TextEditingController? controllerName,
    TextEditingController? controllerNumber,
    TextEditingController? controllerPoint,
    BuildContext? context,
    String? valueName,
    function,
    String? valueNumber,
    String? valuePoint,
    ServiceAPIs? service_api}) {
  // Set default values for the text fields
  controllerName?.text = "$valueName"; // Set your default name
  controllerNumber?.text = "$valueNumber"; // Set your default number
  controllerPoint?.text = "$valuePoint"; // Set your default number
  showDialog(
    context: context!,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MyString.padding08),
        ),
        title: const Text('Update  Player '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              enabled: true,
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              enabled: false,
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: MyString.padding04),
                hintText: 'Enter point',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (validateFields(
                  controllerName!, controllerNumber!, controllerPoint!)) {
                function();
              } else {
                showSnackBar(
                    context: context,
                    message: 'Please fill different point value ');
                // You can use a ScaffoldMessenger or other methods to display the error message.
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      );
    },
  );
}
