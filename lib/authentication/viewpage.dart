import 'package:flutter/material.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';

class ViewPage extends StatefulWidget {
  String? url;
  Widget? child;
  ViewPage({Key? key, this.url, required this.child}) : super(key: key);

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late final socketManager = SocketManager();

  @override
  void initState() {
    super.initState();
    socketManager.initSocket();
    socketManager.dataStreamView.listen((List<Map<String, dynamic>> newData) {
      // setState(() {});
    });
  }

  @override
  void dispose() {
    socketManager.disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: SocketManager().dataStreamView,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else if (snapshot.hasError) {
          return textcustom(text: 'error ${snapshot.error}');
        }
        if (snapshot.data!.isEmpty ||
            snapshot.data == null ||
            snapshot.data == []) {
          return Container();
        } else {
          List<Map<String, dynamic>>? data = snapshot.data;
          if (data == null || data.isEmpty) {
            return Container();
          }
          if (data.first['enable'] == false) {
            return Container();
          }
          return widget.child!;
        }
      },
    );
  }
}
