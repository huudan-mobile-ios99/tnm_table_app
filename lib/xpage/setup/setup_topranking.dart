import 'package:flutter/material.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/history/historypagetop.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/widget/loader.dialog.dart';
import 'package:tournament_client/screen/admin/view/page.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';

class SetupTopRankingPage extends StatefulWidget {
  SocketManager? mySocket;
  SetupTopRankingPage({Key? key, this.mySocket}) : super(key: key);

  @override
  State<SetupTopRankingPage> createState() => _SetupTopRankingPageState();
}

class _SetupTopRankingPageState extends State<SetupTopRankingPage> {
  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerNumber = TextEditingController(text: '');
  final TextEditingController controllerPoint = TextEditingController(text: '0');
  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  void initState() {
    debugPrint('initState SetupTopranking');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final service_api = ServiceAPIs();
  final TextEditingController controllerLimit = TextEditingController(text: MyString.DEFAULT_COLUMN);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  textcustom(text:'Set Up Top Ranking',size: MyString.padding16),
        actions: [

          ElevatedButton.icon(
              icon:const Icon(Icons.bar_chart),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: textcustom(text: "Setting Limit Ranking Display"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: controllerLimit,
                          decoration: const InputDecoration(
                            hintText: 'FROM 1 -> 20',
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
                          if (int.parse(controllerLimit.text) > 20) {
                            showSnackBar(
                                context: context,
                                message:
                                    'Input invalid, Please input from 1-20');
                          } else {
                            widget.mySocket!.emitEventChangeLimitTopRanking(
                                int.parse(controllerLimit.text));
                            showSnackBar(context: context, message: 'Setting Finished');
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('CONFIRM'),
                      ),
                    ],
                  ),
                );
              },
              label: textcustom(text: "Setting Limit")),
          ElevatedButton.icon(
              icon:const Icon(Icons.add),
              onPressed: () {
                debugPrint('add round');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const Icon(Icons.important_devices, color: MyColor.pinkMain),
                    title: textcustom(text: "ADD ROUND",size: MyString.padding18),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        textcustom( text: "Add round from realtime data to top ranking will be take action if you click confirm\nthese action will be process:\n-create new data for top ranking\n-save history top ranking\n-save history realtime\n\nPlease make sure before click confirm button")
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
                        onPressed: () async {
                          debugPrint('data create round');
                          showLoaderDialog(context);
                          try {
                            service_api.addRealTimeRanking().then((value) {
                              showSnackBar(
                                  context: context, message: value['message']);
                              service_api.createRound();
                              service_api.createRoundRealTime();
                            }).whenComplete(() {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            });
                          } catch (e) {
                            debugPrint('error when add round $e');
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('CONFIRM'),
                      ),
                    ],
                  ),
                );
              },
              label: textcustom(text: "Add Round")),
          TextButton.icon(
              onPressed: () {
                debugPrint('rebuild top rank');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const Icon(Icons.refresh_outlined, color: MyColor.pinkMain),
                    title: textcustom(text: "Re-Build Top Ranking"),
                    content: textcustom(
                        text:"Re-Build top ranking will be take action if you click confirm\n-data will be latest\n-animation will run\n-all devices will be re-build UI\n\nPlease make sure before click confirm button"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "CANCEL")),
                      TextButton(
                          onPressed: () {
                            showLoaderDialog(context);
                            widget.mySocket!.emitEventFromClient2Force().then((value){
                              Navigator.of(context).pop();
                            });
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "CONFIRM")),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded,color:MyColor.white),
              label: textcustomColor(text: "Refresh View",color:MyColor.white))
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              tooltip: 'Reset List Ranking To Default',
              backgroundColor: MyColor.red,
              onPressed: () {
                debugPrint('reset all for the 1st round');
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: textcustom(text: "Reset All Data Of Top Ranking"),
                    content: textcustom( text:"Reset top ranking will be make top ranking as default  if you click confirm"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "CANCEL")),
                      TextButton(
                          onPressed: () {
                            service_api
                                .deleteRankingAllAndAddDefault()
                                .then((value) {
                              showSnackBar(
                                  context: context,
                                  message: value['message'] ??
                                      'reset all to default');
                              setState(() {});
                            }).whenComplete(() => null);
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "CONFIRM")),
                    ],
                  ),
                );
              },
              child: const Icon(Icons.reset_tv),
            ),
            const SizedBox(
              width: 16.0,
            ),
            FloatingActionButton(
                tooltip: "add new ranking",
                onPressed: () {
                  debugPrint('add');
                  openAlertDialog(
                      function: () {
                        service_api.createRanking(
                                customer_name: controllerName.text,
                                customer_number: controllerNumber.text,
                                point: controllerPoint.text)
                            .then((value) {
                          showSnackBar(context: context, message: value['message']);
                          setState(() {});
                          if (value['status'] == true) {
                            debugPrint('run it');
                          }
                        }).whenComplete(() {
                          setState(() {
                            controllerName.text = '';
                            controllerNumber.text = '';
                            controllerPoint.text = '0';
                          });

                          Navigator.of(context).pop();
                        });
                      },
                      service_api: service_api,
                      context: context,
                      controllerName: controllerName,
                      controllerNumber: controllerNumber,
                      controllerPoint: controllerPoint);
                },
                child: const Icon(
                  Icons.add,
                ))
          ],
        ),
      ),
      body: Container(
          width: width,
          height: height,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            color: MyColor.white,
          ),
          child: const ListRankingPage()),
    );
  }
}












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
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: const Text('Add New Player '),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controllerName,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
              }
            },
            child: const Text('SUBMIT'),
          ),
        ],
      );
    },
  );
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
          borderRadius: BorderRadius.circular(10.0),
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
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player name',
              ),
            ),
            TextField(
              enabled: false,
              controller: controllerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                hintText: 'Enter player number',
              ),
            ),
            TextField(
              controller: controllerPoint,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
