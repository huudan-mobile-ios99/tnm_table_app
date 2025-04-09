import 'package:flutter/material.dart';
import 'package:tournament_client/xpage/container/containerpage.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/snackbar.custom.dart';
import 'package:tournament_client/widget/text.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController controller = TextEditingController(text: '');
  // final TextEditingController controllerName = TextEditingController(text: '');
  final TextEditingController controllerUrl =
      TextEditingController(text: MyString.BASEURL);
  // final TextEditingController controllerUrl = TextEditingController(text: 'http://30.0.0.53:8090');
  bool isDialogVisible = true;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var checkboxValue = true;

  @override
  void initState() {
    super.initState();
    controllerUrl.text = MyString.BASEURL;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Colors.black,
          //     Colors.black87,
          //     Colors.black54,
          //     Colors.black,
          //   ],
          //   stops: [
          //     0.0,
          //     0.35,
          //     0.75,
          //     0.95,
          //   ], // Adjust the stops to control the gradient effect
          // ),
          image: DecorationImage(
            filterQuality: FilterQuality.low,
            image: AssetImage('assets/bg.png'),
            fit: BoxFit.cover, // Make the image cover the entire container
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    alignment: Alignment.center,
                    width: 75.0,
                    height: 35.0,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo_new.png'),
                            fit: BoxFit.contain)),
                  )),
              // MyHomePage(title: 'tournament page',selectedIndex: 0,),
              // if (isDialogVisible)
              AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MyString.padding16), // Set border radius
                ),
                title:
                textcustom(text: 'Player View', size: MyString.padding18,isBold: true),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                        title:  textcustom(text: 'Member',isBold: false),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: checkboxValue,
                        onChanged: (value) {
                          setState(() {
                            checkboxValue = value!;
                          });
                        }),
                    TextField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontFamily: MyString.fontFamily,fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(fontFamily: MyString.fontFamily,fontWeight: FontWeight.normal),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        hintText:'Player Number 1->10',
                      ),
                    ),
                    TextField(
                      controller: controllerUrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintStyle: TextStyle(fontFamily: MyString.fontFamily),
                        labelStyle: TextStyle(fontFamily: MyString.fontFamily),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        hintText: 'Enter Url',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton.icon(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isDialogVisible = false; // Hide the dialog
                      });
                      Navigator.of(context).pop();
                    },
                    label: textcustom(text:'Close'),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.view_comfortable_sharp),
                    onPressed: () {
                      if (checkboxValue == false) {
                        snackbar_custom(
                            context: context,
                            text: "you must click checkbox",
                            );
                      } else {
                        if (controller.text.isNotEmpty) {
                          int? number = int.tryParse(controller.text);
                          if (number != null && number >= 1 && number <= 10) {
                            setState(() {
                              isDialogVisible = false; // Hide the dialog
                            });

                            final snackBar = SnackBar(
                                duration: const Duration(seconds: 1),
                                backgroundColor: MyColor.black_text,
                                content: Text(
                                  'You chose as player ${controller.text}',
                                  style: const TextStyle(
                                      fontFamily: 'OpenSan',
                                      fontSize: 16,
                                      color: MyColor.white),
                                ));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            // The text is a valid number within the range 1-10
                            // Do something with the number here
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ContainerPage(
                                    url: controllerUrl.text,
                                    selectedIndex: int.parse(controller.text))
                                //  MyHomePage(
                                //     url: controllerUrl.text,
                                //     title: 'Tournament Client',
                                //     selectedIndex: int.parse(controller.text))

                                ));
                          } else {
                            const snackBar = SnackBar(
                                backgroundColor: MyColor.black_text,
                                content: Text(
                                  'Please input number as displayed in real time rankings',
                                  style: TextStyle(
                                      fontFamily: 'OpenSan',
                                      fontSize: 16,
                                      color: MyColor.white),
                                ));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }
                      }
                    },
                    label: textcustom(text:'Confirm Now',),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showInSnackBar(String value, scaffoldKey) {
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
}
