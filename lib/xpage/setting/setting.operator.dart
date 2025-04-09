
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/textfield.dart';
import 'package:tournament_client/xpage/setting/bloc_machine/machine_bloc.dart';
import 'package:tournament_client/xpage/setting/bloc_timer/timer_bloc.dart';
import 'package:tournament_client/xpage/setting/dialog.confirm.dart';


class SettingOperator extends StatelessWidget {
  SocketManager? mySocket;
  SettingOperator({required this.mySocket, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ServiceAPIs serviceAPIs = ServiceAPIs();
    final TextEditingController controllerTimer =  TextEditingController(text: '${MyString.TIME_DEFAULT_MINUTES}');
    return BlocListener<TimerBloc, TimerState>(
      listener: (context, state) {
        switch (state.status) {
          case TimerStatus.finish:
            debugPrint('timer admin finish - disable all machine');
            // service_api.updateStatusAll(status: 0).then((v) {
            //   if (v['result']['affectedRows'] > 0) {
            //     showSnackBar(context: context, message: "Disable all machine");
            //   }
            // }).catchError((e) {
            //   debugPrint(e);
            // });
            break;
          default:
        }
      },
      child: BlocBuilder<TimerBloc, TimerState>(
        builder: (context, state) {
          final minutes = (state.duration / 60).floor();
          final seconds = (state.duration % 60).floor();
          return BlocBuilder<ListMachineBloc, ListMachineState>(
            builder: (contextMachine, stateMachine) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: MyString.padding16, vertical: MyString.padding04),
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      mytextFieldTitleSizeIcon(
                          width: width / 5,
                          icon: const Icon(Icons.airplay_rounded),
                          label: "Timer Minutes",
                          text: '',
                          controller: controllerTimer,
                          enable: true,
                          textinputType: TextInputType.number),
                      const SizedBox(
                        width: MyString.padding16,
                      ),
                      _buildControlButtons(context, state, stateMachine, controllerTimer, mySocket),
                      const SizedBox(
                        width: MyString.padding16,
                      ),
                      Text(
                        // Display the timer countdown in MM:SS format
                        '$minutes:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: MyString.padding24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Tooltip(
                    message: "Display time in client view",
                    child: TextButton.icon(
                        icon: const Icon(Icons.airplay_rounded),
                        onPressed: () {
                          showConfirmationDialog(context, "Display Time", () {
                          serviceAPIs.updateTimeLatest(
                                  minutes: state.duration ~/ 60,
                                  seconds: state.duration % 60,
                                  status: MyString.TIME_SET)
                          .then((v) {mySocket!.emitTime();});
                          });
                        },
                        label: const Text('Display')),
                  ),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}

// Method to display the control buttons
Widget _buildControlButtons(
  BuildContext context,
  TimerState state,
  ListMachineState stateMachine,
  TextEditingController? controller,
  SocketManager? socket,
) {
  final timerBloc = context.read<TimerBloc>();
  final ServiceAPIs serviceAPIs = ServiceAPIs();

  if (state.status == TimerStatus.initial) {
    return TextButton.icon(
      icon: const Icon(Icons.play_arrow, color: MyColor.green),
      onPressed: () {
        late int customDuration   = int.tryParse(controller!.text) ?? MyString.TIME_DEFAULT_MINUTES;
        _showConfirmationDialogContent(context, "Start Game", () {
           customDuration = int.tryParse(controller!.text) ?? MyString.TIME_DEFAULT_MINUTES;
          final durationInSeconds = customDuration * 60; // Convert minutes to seconds
          int minutes = durationInSeconds ~/ 60; // Calculate how many full minutes
          int seconds = durationInSeconds % 60; // Get the remaining seconds
          timerBloc.add(StartTimer(durationInSeconds: durationInSeconds));
          serviceAPIs.updateTimeLatest(
                  minutes: minutes,
                  seconds: seconds,
                  status: MyString.TIME_START)
          .then((v) {
            if (v['status'] == 1) {
              socket!.emitTime();
            }
          }).catchError((error) {
            debugPrint(error);
          });
        }, Text('Are you sure you want to process?\n\n+Game Time: $customDuration (minutes)'));
      },
      label: const Text('START'),
    );
  } else if (state.status == TimerStatus.ticking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.pause),
          onPressed: () {
            timerBloc.add(PauseTimer());
            serviceAPIs.updateTimeLatest(
                    minutes: state.duration ~/ 60,
                    seconds: state.duration % 60,
                    status: MyString.TIME_PAUSE)
                .then((v) {
              if (v['status'] == 1) {
                socket!.emitTime();
              }
            });

            updateStatusAll(context);
          },
          label: const Text('PAUSE'),
        ),
        const SizedBox(width: MyString.padding16),
        TextButton.icon(
          icon: const Icon(Icons.stop, color: MyColor.red),
          onPressed: () {
            _showConfirmationDialog(context, "Stop Game", () {
              timerBloc.add(StopTimer());
              final int customDuration = int.tryParse(controller!.text) ??
                  MyString.TIME_DEFAULT_MINUTES;
              serviceAPIs
                  .updateTimeLatest(
                      minutes: customDuration,
                      seconds: 0,
                      status: MyString.TIME_STOP)
                  .then((v) {
                if (v['status'] == 1) {
                  socket!.emitTime();
                }
              });
            });
          },
          label: const Text('STOP'),
        ),
      ],
    );
  } else if (state.status == TimerStatus.paused) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.play_arrow_outlined, color: MyColor.green),
          onPressed: () {
            timerBloc.add(ResumeTimer());
            serviceAPIs
                .updateTimeLatest(
                    minutes: state.duration ~/ 60,
                    seconds: state.duration % 60,
                    status: MyString.TIME_RESUME)
                .then((v) {
              if (v['status'] == 1) {
                socket!.emitTime();
              }
            });
          },
          label: const Text('RESUME'),
        ),
        const SizedBox(width: MyString.padding16),
        TextButton.icon(
          icon: const Icon(Icons.stop, color: MyColor.red),
          onPressed: () {
            _showConfirmationDialog(context, "Stop Game", () {
              timerBloc.add(StopTimer());
              final int customDuration = int.tryParse(controller!.text) ??
                  MyString.TIME_DEFAULT_MINUTES;
              serviceAPIs
                  .updateTimeLatest(
                      minutes: customDuration,
                      seconds: 0,
                      status: MyString.TIME_STOP)
                  .then((v) {
                if (v['status'] == 1) {
                  socket!.emitTime();
                }
              });
            });
          },
          label: const Text('STOP'),
        ),
      ],
    );
  } else if (state.status == TimerStatus.finish) {
    return TextButton.icon(
      icon: const Icon(Icons.play_arrow, color: MyColor.green_accent),
      onPressed: () {
        _showConfirmationDialog(context, "Restart Game", () {
          final int customDuration = int.tryParse(controller!.text) ?? 5;
          final durationInSeconds =
              customDuration * 60; // Convert minutes to seconds
          int minutes =
              durationInSeconds ~/ 60; // Calculate how many full minutes
          int seconds = durationInSeconds % 60; // Get the remaining seconds
          timerBloc.add(StartTimer(durationInSeconds: durationInSeconds));
          serviceAPIs
              .updateTimeLatest(
                  minutes: minutes,
                  seconds: seconds,
                  status: MyString.TIME_START)
              .then((v) {
            if (v['status'] == 1) {
              socket!.emitTime();
            }
          });
        });
      },
      label: const Text('RESTART'),
    );
  }

  return Container();
}

void updateStatusAll(context) {
  //update status all APIs
  service_api.updateStatusAll(status: 0).then((v) {
    if (v['result']['affectedRows'] > 0) {
      // _onRefreshMachineList(context);
      // showSnackBar(context:context,message: "Pause/Stop & Disable all machine");
    }
  });
}

void _onRefreshMachineList(context) {
  context.read<ListMachineBloc>().add(ListMachineFetched());
}

// Method to show a confirmation dialog
Future<void> _showConfirmationDialog(
  BuildContext context,
  String actionTitle,
  VoidCallback onConfirmed,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(actionTitle),
        content: const Text('Are you sure you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false); // User pressed NO
            },
            child: const Text('NO'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.add_sharp, color: MyColor.red_accent),
            onPressed: () {
              Navigator.of(dialogContext).pop(true); // User pressed YES
            },
            label: const Text('YES'),
          ),
        ],
      );
    },
  );

  if (result == true) {
    onConfirmed(); // Call the action if the user pressed YES
  }
}




// Method to show a confirmation dialog
Future<void> _showConfirmationDialogContent(
  BuildContext context,
  String actionTitle,
  VoidCallback onConfirmed,
  Widget widget
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(actionTitle),
        content: widget,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(false); // User pressed NO
            },
            child: const Text('NO'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.add_sharp, color: MyColor.red_accent),
            onPressed: () {
              Navigator.of(dialogContext).pop(true); // User pressed YES
            },
            label: const Text('YES'),
          ),
        ],
      );
    },
  );

  if (result == true) {
    onConfirmed(); // Call the action if the user pressed YES
  }
}
