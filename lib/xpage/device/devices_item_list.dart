import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/models/deviceModel.dart';
import 'package:tournament_client/screen/admin/view/hover.cubit.dart';
import 'package:tournament_client/service/format.date.factory.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';

class ItemListViewDevice extends StatelessWidget {
  const ItemListViewDevice({
    Key? key,
    required this.post,
    required this.index,
    required this.onPressEdit,
    required this.onPressDelete,
    required this.onPressSelected,
  }) : super(key: key);
  final int index;
  final DeviceModelData post;
  final Function onPressEdit;
  final Function onPressDelete;
  final Function onPressSelected;

  @override
  Widget build(BuildContext context) {
    final dateformat = DateFormatter();
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / 9;

    return BlocProvider(
      create: (_)=>HoverCubit(),
      child: BlocBuilder<HoverCubit, bool>(
          builder: (contextBloc, state) => MouseRegion(
            onEnter: (_) {
              // debugPrint('onEneter item memberapp $index');
              contextBloc.read<HoverCubit>().onHoverEnter();
            },
            onExit: (_) => contextBloc.read<HoverCubit>().onHoverExit(),
            child: Container(
                alignment: Alignment.center,
                decoration:  BoxDecoration(
                  color:state ? MyColor.bedgeLight: Colors.transparent,
                  border:const  Border(
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
                          child: textcustom(text: '${index + 1}', size: MyString.padding12),
                        ),

                        SizedBox(
                          width: itemWidth,
                          child: textcustom(
                              text: post.ipAddress.toString(),
                              size: MyString.padding12),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: textcustom(
                              text: post.deviceId.toString(),
                              size: MyString.padding12),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: textcustom(
                              text: post.deviceName.toString(), size: MyString.padding12),
                        ),
                        SizedBox(
                          width: itemWidth,
                          child: textcustom(
                              text: '${post.platform}\n\n${post.userAgent}',
                              size: MyString.padding12),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: itemWidth,
                          child: textcustom(
                              text: post.deviceInfo.toString(), size: MyString.padding14,isBold: true),
                        ),

                        SizedBox(
                            width: itemWidth,
                            child: textcustom(
                                text: dateformat.formatDateAFullLocalStandar(
                                    (post.createdAt)),
                                size: MyString.padding14)),
                        Expanded(
                          child: SizedBox(
                              width: itemWidth,
                              child: Wrap(
                                children: [
                                  TextButton(
                                      child:const Text("Update"),
                                      onPressed: () {
                                        onPressEdit();
                                      },
                                      ),
                                  TextButton(
                                      child:const Text("Emit"),
                                      onPressed: () {
                                        onPressSelected();
                                      },
                                  ),
                                  TextButton(
                                      child:const Text("Delete"),
                                      onPressed: () {
                                        onPressDelete();
                                      },
                                      ),
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



