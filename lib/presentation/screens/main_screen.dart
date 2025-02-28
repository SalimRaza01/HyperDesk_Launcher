import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperdesk/core/theme/Colors.dart';
import 'package:hyperdesk/presentation/screens/explorer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? currentDate;
  String? currentTime;
  bool showOption = false;
  bool openExplorer = false;
  bool active = false;
  bool showAppList = false;

  List<Widget> items = [
    OptionButtons(active: true, iconData: CupertinoIcons.wifi, text: 'WiFi'),
    OptionButtons(
        active: false, iconData: CupertinoIcons.bluetooth, text: 'Bluetooth'),
    OptionButtons(
        active: false,
        iconData: CupertinoIcons.battery_100,
        text: 'Battery Saver'),
    OptionButtons(
        active: false, iconData: CupertinoIcons.sun_min, text: 'Night Light'),
    OptionButtons(
        active: false,
        iconData: CupertinoIcons.arrow_2_circlepath,
        text: 'Rotate'),
    OptionButtons(
        active: false, iconData: CupertinoIcons.airplane, text: 'Airplane'),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.storage,
      Permission.systemAlertWindow,
      Permission.manageExternalStorage
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    currentTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/wallpaper2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          StartWidget(
              showAppList: showAppList,
              screenWidth: screenWidth,
              screenHeight: screenHeight),
          OptionWidget(
              showOption: showOption,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              items: items),
          Visibility(
            visible: openExplorer,
            child: Explorer()),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.darkgrey.withOpacity(0.9),
                  border: BorderDirectional(
                      top: BorderSide(
                          color: AppColor.borderlightColor, width: 0.5))),
              height: screenHeight * 0.055,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth / 6,
                    ),
                    Row(
                      spacing: 20.0,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showAppList = !showAppList;
                            });
                          },
                          child: SizedBox(
                            child: Image.asset(
                              'assets/Start.png',
                              height: screenWidth * 0.025,
                            ),
                          ),
                        ),
                        Row(children: [
                          Image.asset(
                            'assets/search.png',
                            height: screenWidth * 0.02,
                          ),
                        ]),
                        SizedBox(
                          child: Image.asset(
                            'assets/taskview.png',
                            height: screenWidth * 0.025,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              openExplorer = !openExplorer;
                            });
                          },
                          child: SizedBox(
                            child: Image.asset(
                              'assets/explorer.png',
                              height: screenWidth * 0.025,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Image.asset(
                            'assets/settings.png',
                            height: screenWidth * 0.025,
                          ),
                        )
                      ],
                    ),
                    Row(
                      spacing: 15.0,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              showOption = !showOption;
                            });
                          },
                          child: Container(
                            decoration: showOption
                                ? BoxDecoration(
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                    border: BorderDirectional(
                                        top: BorderSide(
                                            color: AppColor.borderlightColor,
                                            width: 0.5)))
                                : null,
                            child: Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Icon(
                                CupertinoIcons.chevron_up,
                                color: AppColor.white,
                                size: screenHeight * 0.015,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          CupertinoIcons.wifi,
                          color: AppColor.white,
                          size: screenHeight * 0.018,
                        ),
                        Icon(
                          CupertinoIcons.speaker_3_fill,
                          color: AppColor.white,
                          size: screenHeight * 0.018,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currentTime!,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.015,
                                  color: AppColor.white),
                            ),
                            Text(
                              currentDate!,
                              style: TextStyle(
                                  fontSize: screenHeight * 0.015,
                                  color: AppColor.white),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StartWidget extends StatelessWidget {
  StartWidget({
    super.key,
    required this.showAppList,
    required this.screenWidth,
    required this.screenHeight,
  });

  final bool showAppList;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      curve:Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      bottom: showAppList ? 55.0 : -600,
      left: screenWidth / 3,
      child: Container(
        height: screenHeight / 1.8,
        width: screenWidth / 3,
        decoration: BoxDecoration(
            color: AppColor.backgroundColor,
            borderRadius: BorderRadius.circular(9),
            border: BorderDirectional(
                top: BorderSide(color: AppColor.borderlightColor, width: 0.5))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: AppColor.lightgrey,
                      borderRadius: BorderRadius.circular(7)),
                  height: screenHeight * 0.045,
                  width: screenWidth * 0.35,
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColor.white,
                          size: screenHeight * 0.025,
                        ),
                        hintText: 'Type here to search',
                        hintStyle: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.w200,
                            fontSize: screenHeight * 0.02),
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none)),
                  )),
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(9),
                        bottomLeft: Radius.circular(9)),
                    color: AppColor.darkgrey),
                height: screenHeight * 0.05,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/user.png',
                              height: screenWidth * 0.02,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'This PC',
                              style: TextStyle(
                                color: AppColor.white,
                                fontWeight: FontWeight.w200,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Image.asset(
                          'assets/power.png',
                          height: screenWidth * 0.015,
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class OptionWidget extends StatelessWidget {
  OptionWidget(
      {super.key,
      required this.showOption,
      required this.screenWidth,
      required this.screenHeight,
      required this.items});

  final bool showOption;
  final double screenWidth;
  final double screenHeight;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
         curve:Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      bottom: showOption ? 55.0 : -600,
      right: 10,
      child: Container(
          height: screenHeight / 1.8,
          width: screenWidth / 3.2,
          decoration: BoxDecoration(
              color: AppColor.backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: BorderDirectional(
                  top: BorderSide(
                      color: AppColor.borderlightColor, width: 0.5))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: screenHeight / 2.5,
                child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0, // spacing between rows
                    crossAxisSpacing: 15.0, // spacing between columns
                    padding: EdgeInsets.all(20.0), // padding around the grid
                    children: items),
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.speaker_3_fill,
                    color: AppColor.white,
                    size: screenHeight * 0.018,
                  ),
                ],
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(9),
                          bottomLeft: Radius.circular(9)),
                      color: AppColor.darkgrey),
                  height: screenHeight * 0.05,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.battery_25_percent,
                                color: AppColor.white,
                                size: screenHeight * 0.023,
                              ),
                              SizedBox(
                                width: screenWidth * 0.006,
                              ),
                              Text(
                                '25 %',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.015,
                                  color: AppColor.white,
                                  fontWeight: FontWeight.w200,
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.settings,
                          color: AppColor.white,
                          size: screenHeight * 0.018,
                        )
                      ],
                    ),
                  )),
            ],
          )),
    );
  }
}

class OptionButtons extends StatelessWidget {
  OptionButtons(
      {super.key,
      required this.active,
      required this.iconData,
      required this.text});

  final bool active;
  final IconData iconData;
  final String text;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.07,
          decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.lighten,
              gradient: active
                  ? null
                  : LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        AppColor.lightgrey,
                        AppColor.darkgrey,
                      ],
                    ),
              color: active ? AppColor.activeColor : null,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: AppColor.borderlightColor, width: 0.5)),
          child: Center(
              child: Icon(
            size: 20.0,
            iconData,
            color: AppColor.white,
          )),
        ),
        SizedBox(
          height: screenHeight * 0.01,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: screenHeight * 0.012,
              color: AppColor.white,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

//  Expanded(
//                 child: showAppList
//                     ? GridView.builder(
//                         padding: EdgeInsets.all(20),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 5,
//                           childAspectRatio: 0.9,
//                           crossAxisSpacing: 15,
//                           mainAxisSpacing: 15,
//                         ),
//                         physics: BouncingScrollPhysics(),
//                         itemCount: apps.length,
//                         itemBuilder: (context, index) {
//                           Application app = apps[index];
//                           return GestureDetector(
//                             onTap: () => DeviceApps.openApp(app.packageName),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.memory(
//                                   (app as ApplicationWithIcon).icon,
//                                   width: screenWidth * 0.05,
//                                   height: screenWidth * 0.05,
//                                   fit: BoxFit.contain,
//                                 ),
//                                 SizedBox(height: 5),
//                                 Text(
//                                   app.appName,
//                                   style: TextStyle(
//                                     color:  AppColor.white,
//                                     fontSize: screenWidth * 0.010,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       )
//                     : Center(
//                         child: Text(
//                           "Welcome to Your Launcher",
//                           style: TextStyle(color:  AppColor.white, fontSize: 24),
//                         ),
//                       ),
//               ),
