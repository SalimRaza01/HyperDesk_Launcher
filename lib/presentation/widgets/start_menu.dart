import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hyperdesk/core/services/DeviceService.dart';
import 'package:hyperdesk/core/theme/Colors.dart';

class StartWidget extends StatefulWidget {
  const StartWidget({super.key});

  @override
  State<StartWidget> createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  List<dynamic> apps = [];
  late double screenWidth;
  late double screenHeight;

  @override
  void initState() {
    super.initState();
    loadApps();
  }

  void loadApps() async {
    List<dynamic> installedApps = await DeviceService.getInstalledApps();
    setState(() {
      apps = installedApps;
    });
  }

  Image? base64ToImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) return null;
    try {
      print("Decoding Base64: ${base64String.substring(0, 50)}...");
      Uint8List bytes = base64Decode(base64String);
      return Image.memory(bytes, width: 40, height: 40);
    } catch (e) {
      print("Base64 decoding error: $e \nString: $base64String");
      return null;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: screenHeight / 1.5,
      width: screenWidth / 2.5,
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColor.borderlightColor, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: AppColor.white),
                hintText: 'Type here to search',
                hintStyle: TextStyle(color: AppColor.white),
                filled: true,
                fillColor: AppColor.lightgrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('Apps', apps),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9),
                  bottomRight: Radius.circular(9)),
              color: AppColor.darkgrey,
            ),
            height: screenHeight * 0.05,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/user.png',
                          height: screenWidth * 0.02),
                      SizedBox(width: 10),
                      Text('Salim Raza',
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w200)),
                    ],
                  ),
                  Image.asset('assets/power.png', height: screenWidth * 0.015),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<dynamic> items) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColor.white,
              fontSize: screenHeight * 0.015,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.2,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              // final isSystemApp = app['isSystemApp'] == 'true';
              final appIcon = base64ToImage(app['icon']);

              return InkWell(
                onTap: () {
                  DeviceService.launchApp(app['packageName']);
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.04,
                      child: appIcon ??
                          Icon(Icons.android,
                              size: screenHeight * 0.03, color: AppColor.white),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(app['name'] ?? "Unknown",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: AppColor.white,
                            fontSize: screenHeight * 0.012),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
