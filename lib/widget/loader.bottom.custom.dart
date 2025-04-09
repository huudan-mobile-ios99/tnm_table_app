import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';

class BottomLoaderCustom extends StatelessWidget {
  Function? function;
  BottomLoaderCustom({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: MyString.padding08,
          ),
          TextButton.icon(
              icon:const Icon(Icons.refresh) ,
              onPressed: () {
                debugPrint('refresh button bottom reach');
                function!();
              },
              label: const Text('refresh'))
        ],
      ),
    );
  }
}
