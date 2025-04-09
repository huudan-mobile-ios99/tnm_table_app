import 'package:flutter/material.dart';
import 'package:tournament_client/xgame2d_table/ranking/rankingchipbody.dart';

class RankingViewChipPage extends StatelessWidget {
  const RankingViewChipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black, // Set the background to black
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/bg_topranking.jpeg'), fit: BoxFit.cover)),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child:  SizedBox(
                  width: width,
                  height: height,
                  child:
                  const RankingChipBodyPage()
            ),
            ),
          ],
        ),
      ),
    );
  }
}
