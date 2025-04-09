import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/loading.indicator.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/jackpot/bloc/jackpot_bloc.dart';
import 'package:tournament_client/xpage/jackpot/jackpot_item.dart';
import 'package:tournament_client/xpage/jackpot/jackpot_item_title.dart';
import 'dart:async';

// ignore: must_be_immutable
class JackpotHistoryDropList extends StatefulWidget {
  SocketManager? mySocket;
  JackpotHistoryDropList({Key? key, this.mySocket}) : super(key: key);

  @override
  State<JackpotHistoryDropList> createState() => _JackpotHistoryDropListState();
}

class _JackpotHistoryDropListState extends State<JackpotHistoryDropList> {
  Timer? _debounce;
  @override
  void initState() {
    debugPrint('initState JackpotHistoryDropList');
    scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      if (_isBottom) {
        debugPrint('Debounced: reach bottom list.dart');
        context.read<JackpotDropBloc>().add(JackpotDropFetched());
      }
    });
  }

  void _onRefresh() {
    context.read<JackpotDropBloc>().add(JackpotDropFetched());
    // ignore: invalid_use_of_visible_for_testing_member
    context.read<JackpotDropBloc>().emit(const JackpotDropState());
  }

  final ServiceAPIs service_api = ServiceAPIs();
  final scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return BlocBuilder<JackpotDropBloc, JackpotDropState>(
      builder: (context, state) {
        switch (state.status) {
          case JackpotDropStatus.failure:
            return Center(
              child: TextButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: _onRefresh,
              label: const Text('No JP history founds, press to retry'),
            ));
          case JackpotDropStatus.initial:
            return const Center(child: CircularProgressIndicator());
          case JackpotDropStatus.success:
            if (state.posts!.data.isEmpty || state.posts == null) {
              return const Text('No JP history');
            }
            if (state.posts == null ) {
            return const Center(child: Text( 'No JP history', ),);
            }
            return Column(
              children: [
                 AdminItemTitleJP(
                  onRefresh: (){
                    _onRefresh();
                  },
                 ),
                Expanded(
                  child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.hasReachedMax
                      ? state.posts!.data.length // No loader if max is reached
                      : state.posts!.data.length +
                          1, // Add an extra slot for loader
                  itemBuilder: (context, index) {
                    return index >= state.posts!.data.length
                        ? SizedBox(
                            height: MyString.padding28,
                            width: width,
                            child: loadingIndicatorSize())
                        : ItemListViewJP(
                            post: state.posts!.data[index],
                            index: index,
                            onPressEdit: () {
                              debugPrint('onPressEdit $index ${state.posts!.data[index]}  ${state.posts!.data[index]}');
                            },
                            onPressDelete: () {
                              debugPrint('onPressDelete ${state.posts!.data[index].id}');
                              showDialog(
                                  context: context,
                                  builder:(context) =>AlertDialog(title: textcustom(text:'Confirm delete'),
                                  content: textcustom(text:"Are you sure to delete this item?"),
                                  actions: [
                                  TextButton(
                                      onPressed: () { try {
                                        service_api.deleteJPDropById(id:state.posts!.data[index].id).then((value) =>{ _onRefresh() }) .whenComplete(() => Navigator.of(context).pop());
                                            } catch (e) {
                                            Navigator.of(context).pop();
                                            }},child: textcustom(text:"SUBMIT")),
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child: textcustom(text:"CANCEL")),
                                                                      ],
                                                                    ));
                            },
                          );
                  },
                ))
              ],
            );
        }
      },
    );
  }

  //is bottom
  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
