import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/service/format.date.factory.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/widget/textfield.dart';
import 'package:tournament_client/xpage/setting/bloc_setting/settting_bloc.dart';
import 'package:tournament_client/xpage/setting/dialog.confirm.dart';

class SettingPage extends StatefulWidget {
  SocketManager? mySocket;
  SettingPage({required this.mySocket, Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController controllerRound = TextEditingController();
  final TextEditingController controllerGame = TextEditingController();

  final formatNumber = DateFormatter();


  @override
  void dispose() {
    // Dispose of controllers when the widget is disposed
    controllerRound.dispose();
    controllerGame.dispose();
    super.dispose();
  }

  void _setControllerValues(SettingState state) {
    controllerRound.text = '${state.posts.first.minbet}';
    controllerGame.text = '${state.posts.first.maxbet}';
  }

  @override
  void initState() {
    super.initState();
    widget.mySocket!.initSocket();
  }

  @override
  Widget build(BuildContext context) {
    final serviceAPIs = ServiceAPIs();
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return  SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding:const EdgeInsets.all(MyString.padding08),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text("Setting Game"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Tooltip(
                                      message: "Display game settings  in client view",
                                      child: ElevatedButton.icon(
                                          label: const Text("Display & View Setting"),
                                          onPressed: () {
                                            showConfirmationDialog(context,"Display game settings  in client view",
                                              () {
                                              debugPrint('Display game settings  in client view');
                                              widget.mySocket!.emitSettingGame();
                                            });
                                          },
                                          icon: const Icon(Icons.airplay_rounded)),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                            //VEGAS PRICE
                            SizedBox(
                              width: width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  mytextFieldTitleSizeIcon(
                                      width: width / 3,
                                      icon:const Icon(Icons.attach_money_outlined),
                                      label: "Round",
                                      text: controllerRound.text,
                                      controller: controllerRound,
                                      enable: true,
                                      textinputType: TextInputType.number),
                                  const SizedBox(
                                    width: MyString.padding04,
                                  ),
                                  mytextFieldTitleSizeIcon(
                                      width: width / 3,
                                      icon:const Icon(Icons.attach_money_outlined),
                                      label: "Game",
                                      text: controllerGame.text,
                                      controller: controllerGame,
                                      enable: true,
                                      textinputType: TextInputType.number),
                                  const SizedBox(
                                    width: MyString.padding04,
                                  ),

                                ],
                              ),
                            ),
                            const Divider(color: MyColor.grey),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                    icon: const Icon(Icons.settings_outlined),
                                    onPressed: () {
                                      debugPrint("Update Setting ");
                                      showConfirmationDialog(
                                        context,
                                        "Update Setting",
                                        () {
                                        serviceAPIs.updateSettingGame(
                                                  game:int.parse(controllerGame.text),
                                                  round:int.parse(controllerRound.text),
                                                  note:"note",
                                        ).then((v) {
                                            showSnackBar(
                                                  context: context,
                                                  message: "$v");
                                          }).whenComplete(() {
                                            debugPrint('complete update APIs');
                                          });
                                        },
                                      );
                                    },
                                    label: const Text("Update Setting")),
                                // const SizedBox(width:MyString.padding24),
                                // ElevatedButton.icon(
                                //     icon: const Icon(Icons.gamepad),
                                //     onPressed: () {
                                //       debugPrint("Refresh Game View");
                                //       showConfirmationDialog(
                                //         context,
                                //         "Refresh Game View",
                                //         () {
                                //           debugPrint('click refresh game view');
                                //           widget.mySocket!.emitEventFromClient();
                                //           widget.mySocket!.emitEventFromClientForce().then((value){
                                //             debugPrint('emitEventFromClientForce value');
                                //           });


                                //         },
                                //       );
                                //     },
                                //     label: const Text("Refresh Game View")),
                                // const SizedBox(width:MyString.padding24),
                                // ElevatedButton.icon(
                                //     icon: const Icon(Icons.bar_chart),
                                //     onPressed: () {
                                //       debugPrint("Refresh Top Ranking");
                                //       showConfirmationDialog(
                                //         context,
                                //         "Refresh Top Ranking",
                                //         () {

                                //         },
                                //       );
                                //     },
                                //     label: const Text("Refresh Top Ranking")),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );

  }
}

bool? validateInput(
    {String? percent, String? min, String? max, String? threshold}) {
  // Check if all inputs are provided and are numbers
  final percentNumber = double.tryParse(percent ?? '');
  final minNumber = double.tryParse(min ?? '');
  final maxNumber = double.tryParse(max ?? '');
  final thresholdNumber = double.tryParse(threshold ?? '');
  // Return false if any input is null or not a number
  if (percentNumber == null ||
      minNumber == null ||
      maxNumber == null ||
      thresholdNumber == null) {
    return false;
  }
  // Validate percent < 1
  if (percentNumber >= MyString.JPPercentMax) {
    return false;
  }
  // Validate min < threshold < max
  if (!(minNumber < thresholdNumber && thresholdNumber < maxNumber)) {
    return false;
  }
  return true; // All validations passed
}
