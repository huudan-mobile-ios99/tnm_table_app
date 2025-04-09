import 'package:flutter/material.dart';
import 'package:tournament_client/service/service_ip.dart';
import 'package:tournament_client/utils/checkuuid.dart';
import 'package:tournament_client/utils/generate_string.dart';
import 'package:tournament_client/utils/login_manager.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/showsnackbar.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/navigation/navigation_page.dart';
import 'package:tournament_client/xgame2d_table/game/gametable_page.dart';
import 'package:tournament_client/xgame2d_table/ranking/viewrankingpage.dart';
// import "dart:html" as html;

class AdminVerify extends StatefulWidget {
  const AdminVerify({Key? key}) : super(key: key);
  @override
  State<AdminVerify> createState() => _AdminVerifyState();
}

class _AdminVerifyState extends State<AdminVerify> {
  final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerPass = TextEditingController(text: '');
  final TextEditingController controllerNumber = TextEditingController(text: '');

  GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey<RefreshIndicatorState>();
  final ServiceAPIs serviceAPIs = ServiceAPIs();
  final ServiceIP serviceIP = ServiceIP();
  final String uniqueId = getOrCreateUniqueId();
  late String ipAddress;
  late Image backgroundImage;

  bool isChecked = false;


  @override
  void initState()  {
    final userAgent =  serviceIP.getUserAgent();
    final devicePlatform = serviceIP.getDevicePlatform();
    debugPrint("userAgent: $userAgent");
    debugPrint("devicePlatform: $devicePlatform");
    serviceIP.getPublicIp().then((ip){
      setState(() {
        ipAddress = ip;
      });
      if(uniqueId.isNotEmpty){
       serviceAPIs.createNewDevice(
        userAgent: userAgent! ,platform: devicePlatform! ,ipAddress: ip, deviceId: uniqueId, deviceName: 'DEVICE_${generateRandomString(8)}', deviceInfo: "");
      }
    });

    super.initState();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          height: height,
          width: width,
          decoration:  const BoxDecoration(
            image: DecorationImage(
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          ),
          ),
          child: AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                textcustom(
                    text: 'TABLE TNM V1',
                    size: MyString.padding18,
                    isBold: true),
                const SizedBox(
                  width: MyString.padding24,
                ),
                Container(
                  alignment: Alignment.center,
                  width: 75.0,
                  height: 45.0,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/logo_new.png'),
                          fit: BoxFit.contain),
                  ),
                )
              ],
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(MyString.padding16))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFormField(
                  enabled: true,
                  controller: controllerName,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      suffix: Icon(Icons.person_2_outlined),
                      fillColor: MyColor.black_text,
                      focusColor: MyColor.black_text,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      hintText: 'User Name',
                      hintStyle: TextStyle(fontFamily: MyString.fontFamily,fontWeight: FontWeight.normal),
                      labelStyle: TextStyle(fontFamily: MyString.fontFamily,fontWeight: FontWeight.normal)),
                ),
                const SizedBox(
                  height: MyString.padding16,
                ),
                TextField(
                  enabled: true,
                  obscureText: true,
                  controller: controllerPass,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      suffix: Icon(Icons.password_outlined),
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      hintText: 'Password',
                      hintStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal),
                      labelStyle: TextStyle(fontFamily: MyString.fontFamily, fontWeight: FontWeight.normal)),
                ),
                const SizedBox(
                  height: MyString.padding36,
                ),
                TextButton.icon(
                icon: const Icon(Icons.queue_play_next_rounded),
                onPressed: () {
                  navigateToPage(isTopRanking: true,);
                },
                label: textcustom(text: "Login Admin", size: MyString.padding16)),
                const SizedBox(height: MyString.padding08),
                const Divider(color: MyColor.grey_tab),
                const SizedBox(height: MyString.padding16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                        icon: const Icon(Icons.group_add_outlined),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const RankingViewPage()));
                        },
                        label: textcustom(text: "View Ranking", size: MyString.padding16)),
                    const SizedBox(
                      width: MyString.padding24,
                    ),

                    ElevatedButton.icon(
                        icon: const Icon(Icons.person_2_outlined),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) =>const GameTablePage() ));
                          debugPrint('Game');
                        },
                        label: textcustom(text: "Game", size: MyString.padding16)),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  navigateToPage({isTopRanking, mySocket}) {
    if (validateFields(
          controllerName,
          controllerPass,
        ) ==
        true) {
      try {
        if (controllerName.text == MyString.DEFAULT_USERNAME && controllerPass.text == MyString.DEFAULTP_PASS) {
          showSnackBar(context: context, message: 'Login Default');
          UserLoginManager.setLoggedIn(true);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const NavigationPage()));
        } else {
          serviceAPIs.login(username: controllerName.text, password: controllerPass.text).then((value) {
            showSnackBar(context: context, message: value['message']);
            if (value['status'] == true ) {
              UserLoginManager.setLoggedIn(true);
              // final bool isAdmin = value['data']['role'] =='admin' ?  true :false;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const NavigationPage()));
            } else {
              // showSnackBar(context: context, message: value['message']);
            }
            if (value == null) {
              showSnackBar(
                  context: context,
                  message: 'Password or username not correct, please try again');
            } else {}
          }).catchError((e){
            showSnackBar(context: context, message: 'Can not connect to server');
          }).whenComplete(() {
            debugPrint('complete login');
          });
        }
      } catch (e) {
        showSnackBar(context: context, message: 'Can not connect to server');
      }
    } else {
      showSnackBar( context: context, message: 'Please fill  password or username');
    }
  }

  void openLoginDialog(
      {TextEditingController? controllerName,
      TextEditingController? controllerPass,
      BuildContext? context,
      String? valueName,
      function,
      String? valueNumber,
      String? valuePoint,
      ServiceAPIs? serviceAPIs}) {
    // Set default values for the text fields
    controllerName?.text = "$valueName"; // Set your default name
    controllerPass?.text = "$valueNumber"; // Set your default number
    showDialog(
      context: context!,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Login Page Admin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                enabled: false,
                controller: controllerName,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  hintText: 'Enter username',
                ),
              ),
              TextField(
                enabled: false,
                controller: controllerPass,
                // keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  hintText: 'Enter password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (validateFields(controllerName!, controllerPass!) == true) {
                  debugPrint('validateFields passed');
                } else {
                  showSnackBar(
                      context: context,
                      message: 'Please fill correct password or username');
                  // You can use a ScaffoldMessenger or other methods to display the error message.
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}

bool validateFields(TextEditingController controllerName,
    TextEditingController controllerPass) {
  // Check if any of the text controllers is null or empty
  if (controllerName.text.isEmpty || controllerPass.text.isEmpty) {
    return false;
  }

  // All validation conditions are met
  return true;
}
