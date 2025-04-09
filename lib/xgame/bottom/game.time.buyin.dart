import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/models/timeModel.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xgame/bottom/bloc_timer_bottom/timerbottom_bloc.dart';
import 'package:tournament_client/xgame/bottom/game.time.dart';
import 'package:tournament_client/xgame/bottom/widget/image.box.dart';

class GameTimeBuyIn extends StatelessWidget {
  final SocketManager socketManager;
  final double width;
  final int durationMinutes; // Input duration in minutes
  final double height;

  const GameTimeBuyIn({
    required this.socketManager,
    required this.width,
    required this.height,
    required this.durationMinutes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int totalDurationInput = durationMinutes*60;
    return BlocProvider(
      create: (context) => TimerBottomBloc(initialDuration: totalDurationInput),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SocketManager().dataStreamTime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return textcustom(text: 'error ${snapshot.error}');
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Icon(Icons.do_not_disturb_alt_sharp));
          }

          // Parse the data from the socket stream
          TimeModelList timeModelList = TimeModelList.fromJson(snapshot.data!);
          int totalSeconds = durationMinutes * 60; // Calculate total duration in seconds
          int status = timeModelList.list.first.status;

          // Trigger BLoC events based on the status from the stream
          if (status == 1) {
            // Use the custom duration if provided
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

              String formattedMinutesInput = (totalDurationInput ~/ 60).toString().padLeft(2, '0');
              String formattedSecondsInput = (totalDurationInput % 60).toString().padLeft(2, '0');
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Text('${formattedMinutesInput} : ${formattedSecondsInput}}',style: TextStyle(color:MyColor.white),),

                  ImageBoxTitle(
                          hasChild: true,
                          textSize: MyString.padding42,
                          width: width,
                          height: height,
                          asset: "asset/round.png",
                          // title: "${state.status}",
                          title: "BUY-IN AT",
                          sizeTitle: MyString.padding18,
                          text:state.status == TimerBottomStatus.set ? '$formattedMinutesInput:$formattedSecondsInput' :   '$formattedMinutes:$formattedSeconds'  ,
                  ),

                  if (state.status == TimerBottomStatus.paused) buttonStatus(width, height)
                  else  const SizedBox(),
                ],
              );

            },
          );
        },
      ),
    );
  }
}
