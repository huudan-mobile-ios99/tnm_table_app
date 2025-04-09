import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/loading.indicator.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame/top/bloc/stream_bloc/stream_bloc.dart';
import 'package:tournament_client/xgame/top/view.stream.dart';
import 'package:http/http.dart' as http;

class MachineViewPage extends StatelessWidget {
  const MachineViewPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => StreamBloc(httpClient: http.Client())..add(StreamFeteched()),
      child: const MachineViewPageBody(),
    );
  }
}

class MachineViewPageBody extends StatelessWidget {
  const MachineViewPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    // const padding = MyString.padding08;
    final double heightItem = height / 3;
    final double widthItem = width / 3;

    return BlocBuilder<StreamBloc, StreamMState>(builder: (context, state) {
      switch (state.status) {
        case StreamStatus.initial:
          return Center(child: loadingNoIndicator());
        case StreamStatus.failure:
          return Center(
              child: TextButton.icon(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // ignore: invalid_use_of_visible_for_testing_member
            },
            label:  textcustom(text:'No Streams Found',size: MyString.padding08),
          ));
        case StreamStatus.success:
          if (state.posts.isEmpty) {
            return  Center(child: textcustom(text:'No Streams Found',size: MyString.padding08),);
          }
      }

      // Replace the old `urlList` with `state.posts`
      final List<String> urlList = state.posts.map((post) => post.url).toList();
      return SizedBox(
        width: width,
        height: height,
        child: MachineViewItem(
          url: urlList.first,
          widthItem: width,
          heightItem: height,
          index: 1,
          title: "",
          active: true
        )
      );
    });
  }

  Widget MachineViewItem(
      {required double widthItem,
      required double heightItem,
      required bool active,
      required int index,
      required String url,
      required String title}) {
    return 
    Container(
        // margin: const EdgeInsets.symmetric(horizontal:MyString.padding28,vertical:MyString.padding12),
        decoration: const BoxDecoration(
            // border: Border.all(
            // color: MyColor.yellowMain,
            // width: MyString.padding06
            // ),
            // borderRadius: BorderRadius.circular(MyString.padding08)
            ),
        width: widthItem-(MyString.padding28*2),
        height: heightItem-(MyString.padding12*2),
        child: active == true
            ? IframeWidget(
                url: url,
                index: index,
                width: widthItem,
                height: heightItem,
              )
            : Container());
    // Column(
    //   mainAxisSize: MainAxisSize.max,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Container(
    //       alignment: Alignment.bottomLeft,
    //       width: widthItem,
    //       height: heightItem * .1,
    //       child: textcustomColor(
    //         text: title,
    //         color: MyColor.white,
    //       ),
    //     ),
    //     Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //           color: MyColor.grey_tab,
    //         )),
    //         width: widthItem,
    //         height: heightItem * .9,
    //         child: active == true
    //             ? IframeWidget(url: url, index: index, width: widthItem,height:heightItem,)
    //             : Container())
    //   ],
    // );
  }
}
