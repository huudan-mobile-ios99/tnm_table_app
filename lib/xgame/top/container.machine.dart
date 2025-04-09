import 'package:flutter/material.dart';
import 'package:tournament_client/xgame/top/page.machine.parent.dart';

class MachineViewContainer extends StatelessWidget {
  const MachineViewContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    const Color color = Color.fromARGB(255, 2, 109, 167);
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      body: Container(
        width: width,
        height: height,
        // color:color,
        // decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('asset/bg_ranking.jpeg'), fit: BoxFit.cover)),
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('asset/bg_topranking.jpeg'), fit: BoxFit.cover)),
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
