// ignore_for_file: must_be_immutable, unused_catch_clause, library_private_types_in_public_api

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperdesk/core/theme/Colors.dart';
import 'package:hyperdesk/presentation/widgets/quick_panel.dart';
import 'package:hyperdesk/presentation/widgets/start_menu.dart';
import 'package:hyperdesk/presentation/widgets/explorer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String? currentDate;
  String? currentTime;
  Duration animationDuration = Duration(milliseconds: 300);
  late double screenWidth;
  late double screenHeight;
  bool active = false;
  final ValueNotifier<bool> openAppListNotifier = ValueNotifier(false);
  final ValueNotifier<bool> openQuickPaneltNotifier = ValueNotifier(false);
  final ValueNotifier<bool> openExplorerNotifier = ValueNotifier(false);

  // void fetchDevices() async {
  //   List<dynamic> apps = await DeviceService.getInstalledApps();
  //   List<dynamic> wifiNetworks = await DeviceService.scanWifiNetworks();
  //   List<dynamic> bluetoothDevices = await DeviceService.scanBluetoothDevices();

  //   print("Installed Apps: $apps");
  //   print("WiFi Networks: $wifiNetworks");
  //   print("Bluetooth Devices: $bluetoothDevices");
  // }

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.storage,
      Permission.systemAlertWindow,
      Permission.manageExternalStorage
    ].request();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    currentTime = DateFormat('hh:mm a').format(DateTime.now()).toString();


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
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
          ValueListenableBuilder<bool>(
            valueListenable: openAppListNotifier,
            builder: (context, openApplist, child) {
              return AnimatedPositioned(
                duration: animationDuration,
                bottom: openApplist ? 55.0 : -700,
                left: screenWidth / 3.5,
                child: StartWidget(),
              );
            },
          ),

          ValueListenableBuilder<bool>(
            valueListenable: openQuickPaneltNotifier,
            builder: (context, quickPanel, child) {
              return AnimatedPositioned(
                curve: Curves.ease,
                duration: animationDuration,
                bottom: 55.0,
                right: quickPanel ? 10 : -700,
                child: QuickPanel(),
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: openExplorerNotifier,
            builder: (context, openExplorer, child) {
              return AnimatedContainer(
                curve: Curves.ease,
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(0),
                duration: animationDuration,
                width: openExplorer ? screenWidth : 0.0,
                height: openExplorer ? screenHeight : 0.0,
                child: Explorer(),
              );
            },
          ),

          //taskbar
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.darkgrey.withOpacity(0.9),
                border: Border(
                    top: BorderSide(
                        color: AppColor.borderlightColor, width: 0.5)),
              ),
              height: screenHeight / 17,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Start Button and Search
                    Row(
                      spacing: 15.0,
                      children: [
                        InkWell(
                          onTap: () {
                            openAppListNotifier.value =
                                !openAppListNotifier.value;
                          },
                          child: Image.asset('assets/Start.png',
                              height: screenWidth * 0.028),
                        ),
                        Container(
                            width: screenWidth * 0.15,
                            height: screenHeight * 0.045,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  hintText: "Search"),
                            )),
                        Image.asset('assets/taskview.png',
                            height: screenWidth * 0.028),
                        InkWell(
                          onTap: () {
                            openExplorerNotifier.value =
                                !openExplorerNotifier.value;
                          },
                          child: Image.asset('assets/explorer.png',
                              height: screenWidth * 0.028),
                        ),
                        Image.asset('assets/settings.png',
                            height: screenWidth * 0.028),
                      ],
                    ),

                    // System Tray
                    Row(
                      spacing: 10.0,
                      children: [
                        InkWell(
                          onTap: () {
                            openQuickPaneltNotifier.value =
                                !openQuickPaneltNotifier.value;
                          },
                          child: ValueListenableBuilder<bool>(
                            valueListenable: openQuickPaneltNotifier,
                            builder: (context, quickPanel, child) {
                              return Container(
                                decoration: quickPanel
                                    ? BoxDecoration(
                                        color: AppColor.backgroundColor,
                                        borderRadius: BorderRadius.circular(5),
                                        border: BorderDirectional(
                                            top: BorderSide(
                                                color:
                                                    AppColor.borderlightColor,
                                                width: 0.5)))
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    spacing: 15.0,
                                    children: [
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
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
