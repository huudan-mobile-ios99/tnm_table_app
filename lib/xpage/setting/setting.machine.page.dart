import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/models/stationmodel.dart';
import 'package:tournament_client/screen/admin/view/hover.cubit.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/widget/loader.bottom.custom.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/setting/bloc_machine/machine_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/xpage/setting/dialog.confirm.dart';
import 'package:tournament_client/xpage/setting/setting.machine.title.dart';
import 'package:tournament_client/xpage/setup/list.item.dart';

class SettingMachinePage extends StatelessWidget {
  const SettingMachinePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) =>
          ListMachineBloc(httpClient: http.Client())..add(ListMachineFetched()),
      child: const SettingMachineBodyPage(),
    );
  }
}

class SettingMachineBodyPage extends StatefulWidget {
  const SettingMachineBodyPage({Key? key}) : super(key: key);

  @override
  State<SettingMachineBodyPage> createState() => _SettingMachineBodyPageState();
}

class _SettingMachineBodyPageState extends State<SettingMachineBodyPage> {
  final _scrollController = ScrollController();
  final service_api = ServiceAPIs();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // debugPrint('reach bottom setting.machine.page');
    if (_isBottom) context.read<ListMachineBloc>().add(ListMachineFetched());
  }

  void _onRefresh() {
    context.read<ListMachineBloc>().add(ListMachineFetched());
    // ignore: invalid_use_of_visible_for_testing_member
    context.read<ListMachineBloc>().emit(const ListMachineState());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Flexible(
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: MyString.padding16),
      width: width,
      height: height / 1.5,
      child: BlocListener<ListMachineBloc,ListMachineState>(
        listener: (context, state) {
            if (state.status == ListMachineStatus.success) {
              // showSnackBar(context:context,message:"list refreshed");
            } else if (state.status == ListMachineStatus.failure) {
              // Show error snackbar when data fails to load
              showSnackBar(context:context,message:"Failed to refresh machine list");
            }
          },
        child: BlocBuilder<ListMachineBloc, ListMachineState>(
          builder: (context, state) {
            switch (state.status) {
              case ListMachineStatus.initial:
                return const Center(child: CircularProgressIndicator());
              case ListMachineStatus.failure:
                return Center(
                    child: TextButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context.read<ListMachineBloc>().add(ListMachineFetched());
                    // ignore: invalid_use_of_visible_for_testing_member
                    context.read<ListMachineBloc>().emit(const ListMachineState());
                  },
                  label: const Text('No ranking founds, press to retry'),
                ));
              case ListMachineStatus.success:
                if (state.posts.isEmpty) {
                  return const Center(child: Text('no rankings'));
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Setting Machine"),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                                icon: const Icon(Icons.refresh),
                                onPressed: () {
                                  _onRefresh();
                                },
                                label: const Text("Refresh")),
                           const SizedBox(width: MyString.padding16,),
                            TextButton.icon(
                                icon: const Icon(Icons.check_circle),
                                onPressed: () {
                                  showConfirmationDialog(
                                      context, "Enable All", () {
                                      //  debugPrint('enable all');
                                      //  service_api.updateStatusAll(status: 1).then((v){
                                      //   if(v['result']['affectedRows']>0){
                                      //     _onRefresh();
                                      //   }
                                      //  });
                                      });
                                },
                                label: const Text("Enable All")),
                           const SizedBox(width: MyString.padding16,),
                            TextButton.icon(
                                icon: const Icon(Icons.disabled_by_default_sharp),
                                onPressed: () {
                                  showConfirmationDialog(
                                      context, "Disable All", () {
                                       debugPrint('disable all');
                                        //  service_api.updateStatusAll(status: 0).then((v){
                                        //   if(v['result']['affectedRows']>0){
                                        //     _onRefresh();
                                        //   }
                                        //  });
                                      });
                                },
                                label: const Text("Disable All")),
                          ],
                        ),
                      ],
                    ),
                    SettingMachineTitle(width: width),
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
                                return index >= state.posts.length
                                    ? BottomLoaderCustom(
                                        function: () => _onRefresh(),
                                      )
                                    : itemList(
                                        width: width,
                                        context: context,
                                        model: state.posts,
                                        index: index);
                              },
                              itemCount: state.hasReachedMax
                                  ? state.posts.length
                                  : state.posts.length + 1,
                              controller: _scrollController,
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: MyString.padding16,
                    )
                  ],
                );
            }
          },
        ),
      ),
    ));
  }
}

Widget itemList(
    {required double width,
    required BuildContext context,
    required int index,
    required List<StationModel?> model}) {
  return

  BlocProvider(
      create: (_) => HoverCubit(),
      child: BlocBuilder<HoverCubit, bool>(
        builder: (context, state) => MouseRegion(
         onEnter: (_) => context.read<HoverCubit>().onHoverEnter(),
         onExit: (_) => context.read<HoverCubit>().onHoverExit(),
          child: Container(
            decoration:  BoxDecoration(
              color:state ?  MyColor.bedgeLight : MyColor.white,
              border: const Border(
                bottom: BorderSide(width: 1, color: MyColor.grey_tab),
                left: BorderSide(width: 1, color: MyColor.grey_tab),
                right: BorderSide(width: 1, color: MyColor.grey_tab),
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    itemListRT(
          width: width,
          child: textcustom(size: MyString.padding14, text: '${index + 1}'),
        ),
        itemListRT(
          width: width,
          child:
              textcustom(size: MyString.padding14, text: model[index]!.member),
        ),
        itemListRT(
          width: width,
          child: textcustom(size: MyString.padding14, text: model[index]!.machine),
        ),
        itemListRT(
          width: width,
          child: textcustom(size: MyString.padding14, text: '${model[index]!.ip}'),
        ),
        itemListRT(
          width: width,
          child: textcustom(
              size: MyString.padding14,
              text: '${model[index]!.bet / 100}\$'),
        ),
        itemListRT(
          width: width,
          child: textcustom(
              size: MyString.padding14,
              text: '${model[index]!.credit / 100}\$'),
        ),
        itemListRT(
          width: width,
          child: textcustom(
              size: MyString.padding14, text: '${model[index]!.aft}'),
        ),
        itemListRT(
            width: width,
            child: textcustomColor(
              size: MyString.padding14,
              text: model[index]!.connect == 1 ? 'connected' : 'disconnected',
              color: model[index]!.connect == 1 ? Colors.green : Colors.red,
            )),
        itemListRT(
            width: width,
            child: textcustomColor(
              size: MyString.padding14,
              text: model[index]!.status == 1 ? 'enable' : 'disable',
              color: model[index]!.status == 1 ? Colors.green : Colors.red,
            )),
        Expanded(
          child: itemListRT(
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    tooltip: 'enable/disable',
                    onPressed: () {
                      debugPrint('enable/disable ${model[index]!.member}');
                    },
                    icon: const Icon(Icons.edit)),
              ],
            ),
          ),
          )],
        )),
          ),
        ),
      ),
    );

}
