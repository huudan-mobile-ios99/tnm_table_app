import 'dart:ui';
import 'package:tournament_client/screen/admin/bloc/list_bloc.dart';
import 'package:tournament_client/widget/loading.indicator.dart';
import 'item_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/textfield.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/screen/admin/view/item_list.dart';

class ListRanking extends StatefulWidget {
  const ListRanking({Key? key}) : super(key: key);

  @override
  State<ListRanking> createState() => _ListRankingState();
}

class _ListRankingState extends State<ListRanking> {
  final _scrollController = ScrollController();
  final service_api = ServiceAPIs();
  final TextEditingController controllerPointCurrent = TextEditingController();
  final TextEditingController controllerPointNew = TextEditingController();
  final TextEditingController controllerMemberCurrent = TextEditingController();
  final TextEditingController controllerMemberNew = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        switch (state.status) {
          case ListStatus.failure:
            return Center(
              child: TextButton.icon(
              icon:const Icon(Icons.refresh),
              onPressed: () {
                context.read<ListBloc>().add(ListFetched());
                // ignore: invalid_use_of_visible_for_testing_member
                context.read<ListBloc>().emit(const ListState());
              },
              label: const Text('no ranking founds, press to retry'),
            ));
          case ListStatus.success:
            if (state.posts.isEmpty) {
              return const Center(child: Text('no rankings'));
            }
            return Column(
              children: [
                const AdminItemTitle(),
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
                        child: 
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.posts.length
                                ? loadingIndicatorSize()
                                : ItemListView(
                                    post: state.posts[index],
                                    index: index,
                                    onPressEdit: () {
                                      debugPrint('onPRess Edit');
                                      showDialog(
                                      context: context,
                                      builder: (context) =>AlertDialog(
                                                              icon: const Icon( Icons.edit),
                                                              title: textcustom(text:'Confirm Update Top Rank'),
                                                              content: Column(
                                                                mainAxisSize:MainAxisSize.min,
                                                                children: [
                                                                  textcustom(text:"Are you sure to update this ranking?"),
                                                                  const Divider(color: MyColor.grey_tab),
                                                                  mytextFieldTitle(
                                                                    hint:'Current Member',
                                                                    enable:false,
                                                                    text: state.posts[index].customerNumber,
                                                                    textinputType:TextInputType.text,
                                                                    label:'Current Member',
                                                                    controller:controllerMemberCurrent,
                                                                  ),
                                                                  mytextFieldTitle(
                                                                      hint:'New Member',
                                                                      enable: true,
                                                                      text: null,
                                                                      controller:controllerMemberNew,
                                                                      textinputType:TextInputType.number,
                                                                      label: 'New Member'),
                                                                  const Divider(color: MyColor.grey_tab),
                                                                  mytextFieldTitle(
                                                                    hint:'Current Point',
                                                                    enable:false,
                                                                    text: state.posts[index].point.toString(),
                                                                    textinputType:TextInputType.text,
                                                                    label:'Current Point',
                                                                    controller:controllerPointCurrent,
                                                                  ),
                                                                  mytextFieldTitle(
                                                                      hint:'New Point',
                                                                      enable: true,
                                                                      text: null,
                                                                      controller:controllerPointNew,
                                                                      textinputType:TextInputType.number,
                                                                      label: 'New Point'),
                                                                ],
                                                              ),
                                                              actions: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed:() { try {
                                                                            if ( (controllerPointNew.text == '' || double.parse(controllerPointNew.text) == state.posts[index].point ) ) {
                                                                              showSnackBar(context: context, message: "Invalid input. Please use a new member number ");
                                                                            } else {
                                                                              service_api.updateRankingById(
                                                                                point: controllerPointNew.text==''?state.posts[index].point : controllerPointNew.text,
                                                                                customer_number: controllerMemberNew.text==''?state.posts[index].customerNumber : controllerMemberNew.text,
                                                                                id:state.posts[index].id
                                                                              ).then((value) {
                                                                                showSnackBar(context: context, message: value['message']);
                                                                                setState(() {
                                                                                  controllerMemberNew.clear();
                                                                                  controllerPointNew.clear();
                                                                                });
                                                                              }).whenComplete(() {
                                                                                Navigator.of(context).pop();
                                                                                _onRefresh();
                                                                              });
                                                                            }
                                                                          } catch (e) {
                                                                            debugPrint('$e');
                                                                            Navigator.of(context).pop();
                                                                            controllerMemberNew.clear();
                                                                            controllerPointNew.clear();
                                                                          }
                                                                        },
                                                                        child: const Text("SUBMIT",style: TextStyle(color: Colors.green))),
                                                                    TextButton(
                                                                        onPressed:() {Navigator.of(context).pop();},child: const Text( "CANCEL"))
                                                                  ],
                                                                )
                                                              ],
                                                            ));
                                    },
                                    onPressDelete: () {
                                      print('onPressDelete ${state.posts[index].id}');
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: textcustom(text: 'Confirm delete'),
                                                content: textcustom(text: "Are you sure to delete this item?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        try {
                                                          service_api.deleteRankingById(id:state.posts[index].id.toString()).then((value){
                                                            showSnackBar(context:context,message: value['message'].toString());
                                                          }).whenComplete((){
                                                          Navigator.of(context).pop();
                                                            _onRefresh();
                                                          });
                                                        } catch (e) {
                                                          Navigator.of(context).pop();
                                                        }
                                                      },
                                                      child: textcustom(text: "SUBMIT")),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: textcustom(
                                                          text: "CANCEL")),
                                                ],
                                              ));
                                    },
                                  );
                          },
                          itemCount: state.hasReachedMax
                              ? state.posts.length
                              : state.posts.length + 1,
                          controller: _scrollController,
                        ),
                      )),
                ),
                const SizedBox(height: MyString.padding16,)
              ],
            );
          case ListStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // debugPrint('reach bottom list.dart');
    if (_isBottom) context.read<ListBloc>().add(ListFetched());
  }

  void _onRefresh() {
    context.read<ListBloc>().add(ListFetched());
    // ignore: invalid_use_of_visible_for_testing_member
    context.read<ListBloc>().emit(const ListState());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
