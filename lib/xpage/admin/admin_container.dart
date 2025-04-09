import 'package:flutter/material.dart';

class AdminContainer extends StatelessWidget {
  const AdminContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon:null,text: "TOP RANKING",),
                Tab(icon: null,text: "REAL TIME RANKING",),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // SetupTopranking(),
              Container(),
              Container(),
              // SetupPage()
            ],
          ),
        ),
      ),);
  }
}
