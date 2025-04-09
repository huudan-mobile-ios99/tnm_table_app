import 'package:flutter/material.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';

class ViewPageChild extends StatefulWidget {
  String? url;
  Widget? child;
  Widget? child2;
  ViewPageChild({Key? key, this.url, required this.child,required this.child2}) : super(key: key);

  @override
  _ViewPageChildState createState() => _ViewPageChildState();
}

class _ViewPageChildState extends State<ViewPageChild> {
  late final socketManager = SocketManager();

  @override
  void initState() {
    super.initState();
    socketManager.initSocket();
    socketManager.dataStreamView.listen((List<Map<String, dynamic>> newData) {});
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
          if (data.first['enable'] == true) {
            return widget.child!;
          }
          return widget.child2!;
        }
      },
    );
  }
}
