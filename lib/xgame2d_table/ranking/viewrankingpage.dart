import 'package:flutter/material.dart';
import 'package:tournament_client/xgame/top/page.machine.parent.dart';

class RankingViewPage extends StatelessWidget {
  const RankingViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg_topranking_v2.jpeg'), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child:  SizedBox(
                  width: width,
                  height: height,
                  child:
                  const MachineTopPage()),
            ),
          ],
        ),
      ),
    );
  }
}
