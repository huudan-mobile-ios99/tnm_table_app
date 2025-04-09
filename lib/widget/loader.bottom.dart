import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';

class BottomLoader extends StatelessWidget {
  Function? function;
  BottomLoader({Key? key, required this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: MyString.padding08,),
          const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
          TextButton(
              onPressed: () {
                function!();
              },
              child: const Text('refresh'))
        ],
      ),
    );
  }
}



