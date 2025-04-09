import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/screen/admin/view/hover.cubit.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/textfield.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xpage/setup/dialog.edit.dart';
import 'package:tournament_client/xpage/setup/list.item.dart';

// ignore: must_be_immutable
class SetupRealtimePage extends StatefulWidget {
  SocketManager? mySocket;

  SetupRealtimePage({Key? key, this.mySocket}) : super(key: key);

  @override
  State<SetupRealtimePage> createState() => _SetupRealtimePageState();
}

class _SetupRealtimePageState extends State<SetupRealtimePage> {
  final TextEditingController controllerMember = TextEditingController();
  final TextEditingController controllerMC = TextEditingController();
  final TextEditingController controllerMemberCurrent = TextEditingController();
  final TextEditingController controllerMemberNew = TextEditingController();
  final TextEditingController controllerLimit =
      TextEditingController(text: MyString.DEFAULT_COLUMN);
  final TextEditingController controllerPoint = TextEditingController();
  final serviceAPIs = ServiceAPIs();

  @override
  void initState() {
    debugPrint('initState SetupPage');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void emitEvent() {}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              debugPrint('add');
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: textcustom(text: "Create New MC Display"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        mytextfield(controller: controllerMember, hint: "Member"),
                        mytextfield(controller: controllerMC, hint: "MC"),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: textcustom(text: "CANCEL")),
                      TextButton(
                          onPressed: () {
                            debugPrint( 'value: ${controllerMember.text} ${controllerMC.text}');
                            try {
                              serviceAPIs.createStation(
                                member: controllerMember.text,
                                machine: controllerMC.text,
                              ).then((value) {
                                setState(() {
                                  controllerMC.text = '';
                                  controllerMember.text = '';
                                });
                              }).whenComplete(() => Navigator.of(context).pop());
                            } catch (e) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: textcustom(text: "SUBMIT"))
                    ],
                  );
                },
              );
            },
            child: const Icon(Icons.add, color: MyColor.white)),
        appBar: AppBar(
          centerTitle: false,
          title:  textcustom(text:'Set Up Real Time Display',size:MyString.padding16),
          actions: [
            TextButton.icon(
                icon:const Icon(Icons.bar_chart,color:MyColor.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: textcustom(text: "Setting Limit Ranking Display"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: controllerLimit,
                            decoration: const InputDecoration(
                              hintText: 'FROM 1 -> 20',
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint("onPressed: emitEventChangeLimitRealTimeRanking");
                            if (int.parse(controllerLimit.text) > 20) {
                            showSnackBar(
                                  context: context,
                                  message:'Input invalid, Please input from 1-20');
                            } else {
                              debugPrint("onPressed: access emitEventChangeLimitRealTimeRanking");
                              widget.mySocket!.emitEventChangeLimitRealTimeRanking(int.parse(controllerLimit.text));
                              showSnackBar(
                                  context: context,
                                  message: 'Setting Finished');
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('SUBMIT'),
                        ),
                      ],
                    ),
                  );
                },
                label: textcustomColor(text: "Setting Limit",color:MyColor.white)),


              TextButton.icon(
                icon:const Icon(Icons.refresh_sharp,color:MyColor.white),
                onPressed: () {
                  setState(() {
                     showSnackBar(context: context, message: 'List Updated');
                  });
                },
                label: textcustomColor(text: "Refresh",color:MyColor.white)),
          ],
        ),
        body: FutureBuilder(
          future: serviceAPIs.listStationData(),
          builder: (BuildContext context,
              AsyncSnapshot<ListStationModel?> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'an error orcur or can not connection to db!',
                textAlign: TextAlign.center,
              ));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final ListStationModel? model = snapshot.data;
            return Container(
              padding: const EdgeInsets.all(0.0),
              alignment: Alignment.center,
              height: height,
              width: width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Theme.of(context).primaryColorLight,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            child: itemListRT(
                              width: width,
                              child:textcustom(text: '#', size: MyString.padding14, isBold: true),
                            ),
                          ),
                          itemListRT(
                            width: width,
                            child: textcustom(text: 'MEMBER', size: MyString.padding14, isBold: true),
                          ),
                          itemListRT(
                            width: width,
                            child: textcustom(
                              text: 'MACHINE', size: MyString.padding14, isBold: true),
                          ),
                          itemListRT(
                            width: width,
                            child: textcustom(
                              text: 'IP', size: MyString.padding14, isBold: true),
                          ),
                          itemListRT(
                            width: width,
                            child: textcustom(
                                text: 'BET', size: MyString.padding14, isBold: true),
                          ),
                          itemListRT(
                            width: width,
                            child: textcustom(
                                text: 'CREDIT', size: MyString.padding14, isBold: true),
                          ),
                          itemListRT(
                              width: width,
                              child: textcustom(
                                  text: 'AFT', size: MyString.padding14, isBold: true)),
                          itemListRT(
                              width: width,
                              child: textcustom( text: 'CONNECT', size: MyString.padding14, isBold: true)),
                          itemListRT(
                              width: width,
                              child: textcustom( text: 'STATUS', size: MyString.padding14, isBold: true)),
                          Expanded(
                              child: itemListRT(
                                  width: width,
                                  child: textcustom(
                                      text: 'ACTION',
                                      size: MyString.padding14,
                                      isBold: true))),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocProvider(
                              create: (_) => HoverCubit(),
                              child: BlocBuilder<HoverCubit,bool>(
                                builder: (context, state) =>  MouseRegion(
                                  onEnter: (_) => context.read<HoverCubit>().onHoverEnter(),
                                  onExit: (_) => context.read<HoverCubit>().onHoverExit(),
                                  child: Container(
                                    color: state ? MyColor.bedgeLight :Colors.transparent,
                                    child: ListTile(
                                      contentPadding:const EdgeInsets.all(0.0),
                                      title: Row(
                                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,text: '${index + 1}'),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                                text: model!.list[index].member),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                                text: model.list[index].machine),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                                text: '${model.list[index].ip}'),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                              text:'${model.list[index].bet / 100}\$'),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                                text:'${model.list[index].credit / 100}\$'),
                                          ),
                                          itemListRT(
                                            width: width,
                                            child: textcustom(
                                              size:MyString.padding14,
                                                text:'${model.list[index].aft}'),
                                          ),
                                          itemListRT(
                                              width: width,
                                              child: textcustomColor(
                                                size: MyString.padding12,
                                                text: model.list[index].connect == 1
                                                    ? 'connect'
                                                    : 'disconnect',
                                                color: model.list[index].connect == 1
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                          itemListRT(
                                              width: width,
                                              child: textcustomColor(
                                                size: MyString.padding14,
                                                text: model.list[index].status == 1
                                                    ? 'enable'
                                                    : 'disable',
                                                color: model.list[index].status == 1
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                          Expanded(
                                            child: itemListRT(
                                              width: width,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                        tooltip: 'update member',
                                                        onPressed: () {
                                                          debugPrint( 'update ${model.list[index].member}');
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        icon: const Icon(Icons.edit),
                                                                        title: textcustom(text:'Confirm Update RT'),
                                                                        content: Column(
                                                                          mainAxisSize:MainAxisSize.min,
                                                                          children: [
                                                                            textcustom(text:  "Are you sure to update this member?"),
                                                                            const Divider(color: MyColor.grey_tab),
                                                                            mytextFieldTitle(
                                                                              hint:'Current Member',
                                                                              enable:false,
                                                                              text: model.list[index].member,
                                                                              textinputType:TextInputType.text,
                                                                              label: 'Current Member',
                                                                              controller:  controllerMemberCurrent,
                                                                            ),
                                                                            mytextFieldTitle(
                                                                                hint: 'New Member',
                                                                                enable:  true,
                                                                                text: null,
                                                                                controller:
                                                                                    controllerMemberNew,
                                                                                textinputType:
                                                                                    TextInputType
                                                                                        .number,
                                                                                label:
                                                                                    'New Member'),
                                                                          ],
                                                                        ),
                                                                        actions: [
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              TextButton(
                                                                                  onPressed:
                                                                                      () {
                                                                                    try {
                                                                                      debugPrint('ip & member: ${model.list[index].ip} ${model.list[index].member}');
                                                                                      if (controllerMemberNew.text == '' ||
                                                                                          controllerMemberNew.text == model.list[index].member) {
                                                                                          showSnackBar(context: context, message: "Invalid input. Please use a new member number ");
                                                                                      } else {
                                                                                        serviceAPIs.updateMemberStation(
                                                                                          ip: model.list[index].ip,
                                                                                          member: controllerMemberNew.text,
                                                                                        ).then((value) {
                                                                                          showSnackBar(context: context, message: value['message']);
                                                                                          controllerMemberNew.clear();
                                                                                        }).whenComplete(() {
                                                                                          Navigator.of(context).pop();
                                                                                          controllerMemberNew.clear();
                                                                                        });
                                                                                      }
                                                                                    } catch (e) {
                                                                                      debugPrint('$e');
                                                                                      Navigator.of(context).pop();
                                                                                    }
                                                                                  },
                                                                                  child: const Text("SUBMIT", style: TextStyle(color: Colors.green))),
                                                                              TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Text("CANCEL"))
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ));
                                                        },
                                                        icon: const Icon(Icons.edit)),
                                                    IconButton(
                                                        tooltip: 'disable/enable',
                                                        onPressed: () {
                                                          //show dialog
                                                          showDialogEdit(
                                                              functionFinishDisplay: () {
                                                                debugPrint('complete display');
                                                                setState(() {});
                                                                Navigator.of(context) .pop();
                                                              },
                                                              functionFinishUnDisplay:
                                                                  () {
                                                                debugPrint('complete  un-display');
                                                                setState(() {});
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              context: context,
                                                              service_api: serviceAPIs,
                                                              ip: model.list[index].ip,
                                                              status: model
                                                                  .list[index].display);
                                                        },
                                                        icon: Icon(model.list[index]
                                                                    .display ==
                                                                0
                                                            ? Icons.close_outlined
                                                            : Icons.remove_red_eye_rounded)),
                                                    IconButton(
                                                        onPressed: () {
                                                          debugPrint('delete');
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) =>
                                                                      AlertDialog(
                                                                        title: textcustom(text:'Confirm delete'),
                                                                        content: textcustom(text:"Are you sure to delete this item?"),
                                                                        actions: [
                                                                          TextButton(
                                                                              onPressed: () {
                                                                                try {
                                                                                  serviceAPIs
                                                                                      .deleteStation(
                                                                                        machine: model.list[index].machine,
                                                                                        member: model.list[index].member,
                                                                                      )
                                                                                      .then((value) =>
                                                                                          {
                                                                                            setState(() {})
                                                                                          })
                                                                                      .whenComplete(() =>
                                                                                          Navigator.of(context).pop());
                                                                                } catch (e) {
                                                                                  Navigator.of(context)
                                                                                      .pop();
                                                                                }
                                                                              },
                                                                              child: textcustom(text:"SUBMIT")),
                                                                          TextButton(
                                                                              onPressed:
                                                                                  () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: textcustom(text:"CANCEL")),
                                                                        ],
                                                                      ));
                                                        },
                                                        icon: const Icon(Icons.delete)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                             Container(color: MyColor.grey_tab,height: 1.0,),
                          ],
                        );
                      },
                      itemCount: model!.list.length,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}




