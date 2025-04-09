import 'package:flutter/material.dart';
import 'package:tournament_client/service/service_api.dart';

showDialogEdit(
    {context,
    status,
    ServiceAPIs? service_api,
    ip,
    functionFinishDisplay,
    functionFinishUnDisplay}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update Status'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text(
                  status == 0 ? "DISPLAY" : "UN-DISPLAY",
                  style: TextStyle(
                      color: status == 0 ? Colors.green : Colors.pink),
                ),
                onPressed: () {
                  if (status == 0) {
                    print('display');
                    service_api!
                        .updateDisplayStatus(ip: ip, display: 1)
                        .then((value) => null)
                        .whenComplete(() {
                      functionFinishDisplay();
                    });
                  } else {
                    print('un-display');
                    service_api!
                        .updateDisplayStatus(ip: ip, display: 0)
                        .then((value) => null)
                        .whenComplete(() {
                      functionFinishUnDisplay();
                    });
                  }
                },
              ),
              TextButton(
                child: const Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
        content: const Text("Status will be apply for mobile and web"),
      );
    },
  );
}