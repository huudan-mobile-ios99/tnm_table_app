import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/game/layout/layout_item.dart';
import 'package:tournament_client/xgame2d_table/view/chartStreamNew.dart';
import 'package:tournament_client/xgame2d_table/game/layout/version/layouttable_page_bloc.dart';

class LayoutTablePage extends StatelessWidget {
  const LayoutTablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final heightItem = height/3.75;
    final widthItem = width/5.225;
    late List<String> memberNumber=[];

    return BlocBuilder<ChartStreamBloc, ChartStreamState>(
       builder: (context, state)  {
       memberNumber = state.members.isNotEmpty ? state.members : List.filled(5, '');
       debugPrint('Bloc MemberSaved: $memberNumber');
      return
       Stack(
        children: [
          Positioned(
            top: heightItem/3.15,
            left: width / 18,
            child: layoutChildItem(
            index: 0,
            number: state.members.isNotEmpty ? state.members[4] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#tag1

          Positioned(
            top: heightItem * 1.525,
            left: width / 6.65,
            child: layoutChildItem(
            index: 1,
            number:state.members.isNotEmpty ? state.members[3] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#2

          Positioned(
            top: heightItem*2.285,
            left:width/2-widthItem/2,
            child:
              layoutChildItem(
                  index: 2,
                  number:state.members.isNotEmpty ? state.members[2] : '',
                  height: heightItem,
                  width: widthItem,
                ),
          ), //#3

          Positioned(
            top: heightItem * 1.525,
            left: width - widthItem - width / 6.65,
            child: layoutChildItem(
            index: 3,
            number:state.members.isNotEmpty ? state.members[1] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#4


          Positioned(
            top: heightItem/3.15,
            left: width - widthItem - width / 18,
            child: layoutChildItem(
            index: 4,
            number:state.members.isNotEmpty ? state.members[0] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#5

          // 2D Game Page
          // const ChartStreamPage(),
          const ChartStreamPageNew(),

          //Positioned display data
          // Positioned(
          //   bottom:0,right:0,
          //   child: SizedBox(
          //     width: width/2, height:50, child: textcustomColor(color:MyColor.white,text:"${state.members}")
          //   ),
          // ),
          ]);
      },);
  }
}
