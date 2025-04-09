import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/device/bloc/device_bloc.dart';
import 'package:tournament_client/xpage/device/devices_item_list.dart';
import 'package:tournament_client/xpage/device/devices_item_title.dart';

class DevicesListPage extends StatefulWidget {
  String? selectedId;
  SocketManager? mySocket;


   DevicesListPage({Key? key,this.selectedId, required this.mySocket}) : super(key: key);

  @override
  State<DevicesListPage> createState() => _DevicesListPageState();
}

class _DevicesListPageState extends State<DevicesListPage> {
  final _scrollController = ScrollController();
  final TextEditingController controllerName  = TextEditingController();
  final TextEditingController controllerInfo = TextEditingController();
  final service_api = ServiceAPIs();

  @override
  void initState() {
    debugPrint('Init DevicesPage ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<DeviceBloc, DeviceState>(
      builder: (context, state) {
        switch (state.status) {
          case DeviceStatus.failure:
            return Center(
                child: TextButton(
              onPressed: () {},
              child: const Text('No devices found, press to retry'),
            ));
          case DeviceStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('No devices'));
            }
            return Column(
              children: [
                itemListDeviceTitle(context:context,width:width),
                Expanded(
                  child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        physics: const BouncingScrollPhysics(),
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                          PointerDeviceKind.trackpad
                        },
                      ),
                      child: RefreshIndicator(
                        onRefresh: () async {
                          _onRefresh();
                        },
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return ItemListViewDevice(
                                onPressSelected: () {
                                  debugPrint("onPressSelected emit device_list $index");
                                  showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: textcustom(text: "Emit Device  ${index+1}?"),
                                          content: textcustom(
                                          text: 'Click confirm to emit data device'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                debugPrint('emit device confirm ${state.posts[index].deviceId} ${state.posts[index].deviceName}');
                                                widget.mySocket!.emitDevice();
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        ),);
                                },
                                post: state.posts[index],
                                index: index,
                                onPressEdit: () {
                                  controllerName.text = state.posts[index].deviceName ?? '';
                                  controllerInfo.text = state.posts[index].deviceInfo ?? '';
                                  debugPrint('onPressEdit device_list from selected ${widget.selectedId} ${state.posts[index].id}');
                                  showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: textcustom(text: "Update Device ?"),
                                          actions:[
                                           TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      debugPrint('update device confirm ${state.posts[index].deviceId} ${state.posts[index].deviceName}');
                                                      //update device info
                                                      service_api.updatedeviceByID(id: state.posts[index].id,deviceName: controllerName.text,deviceInfo: controllerInfo.text).then((v){

                                                      }).whenComplete((){
                                                        _onRefresh();
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                    child: const Text('Confirm'),
                                                  ),
                                          ],
                                          content:
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                enabled: true,
                                                controller: controllerName,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(
                                                    suffix: Icon(Icons.device_hub),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                    hintText: 'Device Name',
                                                    hintStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal),
                                                    labelStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal)),
                                              ),
                                              TextField(
                                                enabled: true,
                                                controller: controllerInfo,
                                                keyboardType: TextInputType.text,
                                                decoration: const InputDecoration(
                                                    suffix: Icon(Icons.info),
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                    hintText: 'Device Info',
                                                    hintStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal),
                                                    labelStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal)),
                                              ),
                                              textcustom(text: 'Click confirm to update name or info of this device'),
                                              ],
                                            ),
                                        ),
                                      );
                                },
                                onPressDelete: () {
                                  debugPrint( 'onPressDelete device_list  ${state.posts[index].id} ');
                                  showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: textcustom(text: "Delete Device  ${index+1}?"),
                                          content: textcustom(
                                          text: 'Click confirm to delete this item'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                debugPrint('select device confirm ${state.posts[index].deviceId} ${state.posts[index].deviceName}');
                                                service_api.deleteDeviceById(
                                                  state.posts[index].id).then((v){
                                                     _onRefresh();
                                                  }).whenComplete((){
                                                    Navigator.of(context).pop(true);
                                                  });
                                              },
                                              child: const Text('Confirm'),
                                            ),
                                          ],
                                        ),);
                                });
                          },
                          itemCount: state.posts.length,
                          controller: _scrollController,
                        ),
                      )),
                ),
              ],
            );

          case DeviceStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _onRefresh() {
    debugPrint('refresh devices page');
    context.read<DeviceBloc>().add(DeviceFetched());
    // ignore: invalid_use_of_visible_for_testing_member
    context.read<DeviceBloc>().emit(const DeviceState());
  }

  @override
  void dispose() {
    super.dispose();
  }
}
