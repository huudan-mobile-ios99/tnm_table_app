import 'package:flutter/material.dart';
import 'package:tournament_client/main.dart';
import 'package:tournament_client/utils/login_manager.dart';
import 'package:tournament_client/xpage/setting/setting.container.dart';
import 'package:tournament_client/xpage/setup/setup_realtime.dart';
import 'package:tournament_client/xpage/display/displaypage.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/history/historypagetop.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xpage/setup/setup_topranking.dart';
import 'package:tournament_client/xpage/history/historypagerealtime.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';


class NavigationPage extends StatefulWidget {
   const NavigationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final double groupAligment = -1.0;
  final NavigationRailLabelType labelType = NavigationRailLabelType.all;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final SocketManager mySocket = SocketManager();

  @override
  void initState() {
    debugPrint('initState NavigationPage');
    mySocket.initSocket();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final List<Widget> mainContents = [
      // const SettingPage(), //setting realtime page
      SettingContainer(mySocket:mySocket,), //setting realtime page
      SetupTopRankingPage(mySocket: mySocket),
      SetupRealtimePage(mySocket: mySocket),
      const HistoryPageTop(),
      const HistoryPageRealTime(),
      DisplayPage(mySocket: mySocket),
      // DevicesPage(mySocket: mySocket),
      // JackpotHistory(),
    ];
    return
      Scaffold(
      key: _scaffoldKey,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: IntrinsicHeight(
                child: NavigationRail(
                  useIndicator: true,
                  indicatorColor: MyColor.grey_tab,
                  extended: false,
                  minWidth: width / 12.5,
                  // minExtendedWidth: width / 10,
                  selectedLabelTextStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500,color:MyColor.black_text),
                  unselectedLabelTextStyle: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: MyColor.grey),
                  backgroundColor: MyColor.white,
                  leading: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 75.0,
                        height: 35.0,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                            image: AssetImage('assets/logo_new.png'),
                            fit: BoxFit.contain)),
                      ),
                      const SizedBox(
                        height: MyString.padding16,
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: MyString.padding08,
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: const Text("Confirm Logout"),
                                      content: textcustom(text: "Are you sure you want to log out? Click 'OK' to proceed."),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: textcustom(text: "CANCEL")),
                                        TextButton(
                                            onPressed: () {
                                              debugPrint('confirm');
                                              // Navigator.of(context).pushNamed('/authentication');
                                              UserLoginManager.setLoggedIn(false);
                                              SocketManager().disposeSocket();
                                              Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (_) =>  const MyApp()));
                                            },
                                            child: textcustom(text: "OK")),
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: MyColor.black_text,
                            size: MyString.padding24,
                          ))
                    ],
                  ),
                  groupAlignment: groupAligment,

                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: labelType,
                  destinations: const <NavigationRailDestination>[
                     NavigationRailDestination(
                      icon: Icon(
                        Icons.settings,
                        size: MyString.padding16,
                      ),
                      indicatorColor: MyColor.orange,
                      selectedIcon: Icon(
                        Icons.settings_outlined,
                        size: MyString.padding16,
                      ),
                      label: Text('Settings',textAlign: TextAlign.center,),
                    ),


                    NavigationRailDestination(
                      icon: Icon(
                        Icons.list,
                        size: MyString.padding24,
                      ),
                      indicatorColor: MyColor.orange,
                      selectedIcon: Icon(
                        Icons.view_carousel,
                        size: MyString.padding24,
                      ),
                      label: Text('Top'),
                    ),

                    NavigationRailDestination(
                      indicatorColor: MyColor.orange,
                      icon: Icon(
                        Icons.grid_3x3,
                        size: MyString.padding24,
                      ),
                      selectedIcon: Icon(
                        Icons.grid_4x4_sharp,
                        size: MyString.padding24,
                      ),
                      label: Text('Realtime'),
                    ),

                    NavigationRailDestination(
                      icon: Icon(
                        Icons.data_array,
                        size: MyString.padding24,
                      ),
                      indicatorColor: MyColor.orange,
                      selectedIcon: Icon(
                        Icons.data_object,
                        size: MyString.padding24,
                      ),
                      label: Text('History\nTop',textAlign: TextAlign.center),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.data_array_outlined,
                        size: MyString.padding24,
                      ),
                      indicatorColor: MyColor.orange,
                      selectedIcon: Icon(
                        Icons.data_object_outlined,
                        size: MyString.padding24,
                      ),
                      label: Text('History\nRealtime',textAlign: TextAlign.center,),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.display_settings,
                        size: MyString.padding24,
                      ),
                      indicatorColor: MyColor.orange,
                      selectedIcon: Icon(
                        Icons.display_settings_rounded,
                        size: MyString.padding24,
                      ),
                      label: Text('Display'),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1, color: MyColor.grey_tab),
          Expanded(child: mainContents[_selectedIndex]),
        ],
      ),
      // ),
    );
  }
}
