import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xpage/home/home_realtime.dart';

class MachineTopPageRealTime extends StatelessWidget {
  final String selectedNumber;
  const MachineTopPageRealTime({Key? key,required this.selectedNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration( image: DecorationImage( image: AssetImage('asset/bg_ranking.jpeg'), fit: BoxFit.cover)),
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: MyString.padding42),
      width: width - (MyString.padding22 * 2),
      child: HomeRealTimePage(
          title: MyString.APP_NAME,
          url: MyString.BASEURL,
          selectedIndex: int.tryParse(selectedNumber) ?? MyString.DEFAULTNUMBER),
    );
  }
}
