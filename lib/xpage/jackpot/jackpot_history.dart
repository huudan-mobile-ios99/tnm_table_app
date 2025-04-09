import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/history/historypagetop.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/xpage/jackpot/bloc/jackpot_bloc.dart';
import 'package:tournament_client/xpage/jackpot/jackpot_history_list.dart';

// ignore: must_be_immutable
class JackpotHistory extends StatefulWidget {
  SocketManager? mySocket;
  JackpotHistory({Key? key, this.mySocket}) : super(key: key);

  @override
  State<JackpotHistory> createState() => _JackpotHistoryState();
}

class _JackpotHistoryState extends State<JackpotHistory> {


  @override
  void initState() {
    debugPrint('initState JackpotHistory');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final service_api = ServiceAPIs();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return
    BlocProvider(
       create: (_) => JackpotDropBloc(httpClient: http.Client())..add(JackpotDropFetched()),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title:  textcustom(text:'JP History',size: MyString.padding16),
          actions:  const [
            // ElevatedButton.icon(
            //   icon:Icon(Icons.refresh_outlined),
            //   onPressed: (){
            //   debugPrint('refresh icon JP History');
            //   context.read<JackpotDropBloc>().add(JackpotDropFetched());
            // }, label: Text("Refresh")),
          ],
        ),
        body: Container(
            width: width,
            height: height,
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              color: MyColor.white,
            ),
            child:JackpotHistoryDropList(),
           ),
      ),
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
