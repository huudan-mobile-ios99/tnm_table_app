import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/screen/admin/model/rankingList.dart';
import 'package:tournament_client/screen/admin/view/hover.cubit.dart';
import 'package:tournament_client/service/format.date.factory.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';

class ItemListView extends StatelessWidget {
  const ItemListView({
    Key? key,
    required this.post,
    required this.index,
    required this.onPressEdit,
    required this.onPressDelete,
  }) : super(key: key);
  final int index;
  final Ranking post;
  final Function onPressEdit;
  final Function onPressDelete;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateformat = DateFormatter();
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / 7.5;
    return BlocProvider(
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
                padding: const EdgeInsets.all(MyString.padding08),
                child: Row(
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: textcustom(text: '${index + 1}', size: MyString.padding16),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: textcustom(
                          text: post.customerNumber.toString(), size: MyString.padding16),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: textcustom(
                          text: post.customerName.toString().toUpperCase(),
                          size: MyString.padding16),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: textcustom(text: '${post.point}', size: MyString.padding16),
                    ),
                    SizedBox(
                        width: itemWidth,
                        child: textcustom(
                            text: dateformat.formatTimeAFullLocal(
                                DateTime.parse(post.createdAt!)),
                            size: MyString.padding16)),
                    SizedBox(
                        width: itemWidth,
                        child: textcustom(
                            text: dateformat
                                .formatDate(DateTime.parse(post.createdAt!)),
                            size: MyString.padding16)),
                    Expanded(
                      child: SizedBox(
                          width: itemWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    onPressEdit();
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  tooltip: "Delete",
                                  onPressed: () {
                                    onPressDelete();
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          )),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

Widget rowItem({icon, String? text}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon),
      Text(
        text!,
      )
    ],
  );
}
