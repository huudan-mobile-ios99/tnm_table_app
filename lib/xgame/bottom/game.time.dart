import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/models/timeModel.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xgame/bottom/bloc_timer_bottom/timerbottom_bloc.dart';
import 'package:tournament_client/xgame/bottom/widget/image.box.dart';

class GameTime extends StatelessWidget {
  final SocketManager socketManager;
  final double width;
  final double height;
  const GameTime({
    required this.socketManager,
    required this.width,
    required this.height,
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerBottomBloc(),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SocketManager().dataStreamTime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return textcustom(text: 'error ${snapshot.error}');
          }
          if (snapshot.data!.isEmpty ||
              snapshot.data == null ||
              snapshot.data == []) {
              return const Center(child: Icon(Icons.do_not_disturb_alt_sharp));
          }
          TimeModelList timeModelList = TimeModelList.fromJson(snapshot.data!);
          int totalSeconds = timeModelList.list.first.minutes * 60 + timeModelList.list.first.seconds;
          int status = timeModelList.list.first.status;
          // Trigger BLoC events based on the status from the stream
          if (status == 1) {
            context.read<TimerBottomBloc>().add(StartTimer(durationInSeconds: totalSeconds));
          } else if (status == 2) {
            context.read<TimerBottomBloc>().add(PauseTimer());
          } else if (status == 3) {
            context.read<TimerBottomBloc>().add(ResumeTimer());
          } else if (status == 4) {
            context.read<TimerBottomBloc>().add(StopTimer());
          }
          else if (status == 5) {
            context.read<TimerBottomBloc>().add(SetTimer());
          }

          return BlocBuilder<TimerBottomBloc, TimerBottomState>(
            builder: (context, state) {
              int minutes = state.duration ~/ 60;
              int seconds = state.duration % 60;

              String formattedMinutes = minutes.toString().padLeft(2, '0');
              String formattedSeconds = seconds.toString().padLeft(2, '0');
              return Stack(
                alignment: Alignment.center,
                children: [
                  imageBoxChild(
                      width: width,
                      height: height,
                      asset: "asset/circle.png",
                      subChild: textcustomColorBold(
                        lineHeight: 1,
                        text: ':',
                        color: MyColor.yellow_bg,
                        size: MyString.padding46,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textcustomColorBold(
                            lineHeight: 1,
                            text: '$formattedMinutes\n$formattedSeconds',
                            color: MyColor.yellow_bg,
                            size: MyString.padding64,
                            // size:MyString.padding18
                          ),
                        ],
                      )),
                  state.status == TimerBottomStatus.paused
                      ? buttonStatus(width,height)
                      : const SizedBox(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

Widget buttonStatus(width,height) {
    return Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(MyString.padding16),
        decoration: BoxDecoration( borderRadius: BorderRadius.circular(MyString.padding16)),
        child: const Center(
          child: Icon(
            Icons.pause,
            color: MyColor.white,
            size: MyString.padding08,
          ),
        ));
  }
