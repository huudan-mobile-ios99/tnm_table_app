import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/navigation/navigation_page.dart';
import 'package:tournament_client/utils/login_manager.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/game/gametable_page.dart';
import 'package:tournament_client/xgame2d_table/ranking/viewrankingchippage.dart';
import 'package:tournament_client/xpage/admin/admin_verify.dart';
import 'package:tournament_client/xpage/container/containerpage.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/utils/mycolors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   runApp(
    // const MyApp(),
    MultiBlocProvider(providers: [
      BlocProvider(create:  (context) => ChartStreamBloc(),
    )
    ], child: MyApp()),
  );
}

class MyApp extends StatefulWidget {

   const MyApp({
    Key? key,
  }) : super(key: key);


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
     _checkLoginStatus();
    super.initState();
  }

  Future<void> _checkLoginStatus() async {
    isLoggedIn = await UserLoginManager.isLoggedIn();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: MyString.APP_NAME,
        theme: ThemeData(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          // cardColor: MyColor.grey_tab,
          platform: TargetPlatform.macOS,
          // hoverColor: Colors.grey.shade200,
          primaryColor: MyColor.green,
          // dividerColor: Colors.grey,
          indicatorColor: MyColor.green,
          // scaffoldBackgroundColor: Colors.white,
          // highlightColor: Colors.grey,
          // hintColor: Colors.grey,
          // disabledColor: Colors.grey,
          // floatingActionButtonTheme: const FloatingActionButtonThemeData(hoverColor: MyColor.grey_tab),
          colorScheme: ColorScheme.fromSeed(seedColor: MyColor.green),
          useMaterial3: false,
          visualDensity: VisualDensity.standard,
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        routes: {
          '/containerPage': (context) => ContainerPage(
                url: MyString.BASEURL,
                selectedIndex: MyString.DEFAULTNUMBER,
            ),
        },

        //STREAM TEST
        // home:  const ChartStreamPage()

        //LAYOUT TEST
        // home:    LayoutTablePage()

        //RANKING PAGE
        // home:  const RankingViewPage(),

        // //RANKING CHIP STACK VERSION PAGE
        // home:  const RankingViewChipPage(),

        //GAME PAGE
        // home: const Scaffold(body: GameTablePage())
        // home:   Scaffold(body: GameTableWithBGPage())


        //ADMIN
        home: isLoggedIn == false ? const AdminVerify() :  const NavigationPage()

        );
  }
}
